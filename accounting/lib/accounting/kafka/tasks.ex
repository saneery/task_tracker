defmodule Accounting.Kafka.Tasks do
  require Logger
  alias Accounting.{Repo, Billing}
  alias Accounting.Tasks.Task
  alias Accounting.Users.User

  def handle_event(%{"event_name" => "TaskCreated", "data" => attrs}) do
    case Repo.get_by(Task, public_id: attrs["public_id"]) do
      nil ->
        %Task{}
        |> Task.changeset(attrs)
        |> Task.set_costs()
        |> Repo.insert()

      _ -> :ok
    end
  end


  def handle_event(%{"event_name" => "TaskAssigned", "data" => attrs}) do
    task_uid = attrs["public_id"]
    user_uid = attrs["assignee_id"]
    case get_or_create_task(task_uid) do
      %Task{} = task ->
        case Billing.get_user_by_public_id(user_uid) do
          nil -> Logger.warn("Cannot find user with public_id = #{user_uid}")
          user ->
            case get_or_create_billing_cycle(user.id) do
              nil -> Logger.warn("Not open billing cycle for user #{user.id}, try to create")
              billing_cycle ->
                %{
                  user_id: user.id,
                  billing_cycle_id: billing_cycle.id,
                  description: "Списание денег за назначенную задачу #{task_uid}",
                  credit: task.credit_cost,
                  type: :withdrawal
                }
                |> Billing.create_transaction()
                |> case do
                  {:ok, _} -> :ok
                  error -> Logger.error("Cannot create transaction: #{inspect(error)}")
                end
            end
            Billing.update_user_balance(user, user.balance - task.credit_cost)
        end
      _ -> Logger.warn("Cannot find task with public_id = #{task_uid}")
    end
  end

  def handle_event(%{"event_name" => "TaskClosed", "data" => attrs}) do
    task_uid = attrs["public_id"]
    user_uid = attrs["assignee_id"]
    case get_or_create_task(task_uid) do
      %Task{} = task ->
        case Billing.get_user_by_public_id(user_uid) do
          nil -> Logger.warn("Cannot find user with public_id = #{user_uid}")
          user ->
            case get_or_create_billing_cycle(user.id) do
              nil -> Logger.warn("Not open billing cycle for user #{user.id}, try to create")
              billing_cycle ->
                %{
                  user_id: user.id,
                  billing_cycle_id: billing_cycle.id,
                  description: "Начисление денег за закрытую задачу #{task_uid}",
                  debit: task.debit_cost,
                  type: :enrollment
                }
                |> Billing.create_transaction()
                |> case do
                  {:ok, _} -> :ok
                  error -> Logger.error("Cannot create transaction: #{inspect(error)}")
                end
            end
            Billing.update_user_balance(user, user.balance + task.debit_cost)
        end
      _ -> Logger.warn("Cannot find task with public_id = #{task_uid}")
    end
  end

  def handle_event(m), do: Logger.warn("Unexpected message #{inspect(m)}")


  defp get_or_create_billing_cycle(user_id) do
    case Billing.get_billing_cycle_for_user(user_id) do
      nil ->
        Logger.warn("Not open billing cycle for user #{user_id}, try to create")
        start_date = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
        case Billing.create_billing_cycle(%{"user_id" => user_id, "start_date" => start_date}) do
          {:ok, bc} -> bc
          err -> Logger.error("BillingCycle creating error #{inspect(err)}")
        end

      billing_cycle -> billing_cycle
    end
  end

  defp get_or_create_task(task_uid) do
    case Repo.get_by(Task, public_id: task_uid) do
      nil ->
        Logger.warn("Cannot find task with public_id = #{task_uid}, try to create")
        %Task{}
        |> Task.changeset(%{"public_id" => task_uid})
        |> Task.set_costs()
        |> Repo.insert()
        |> case do
          {:ok, task} -> task
          error -> Logger.error("Error with creating task #{inspect(error)}")
        end

      task -> task
    end
  end
end
