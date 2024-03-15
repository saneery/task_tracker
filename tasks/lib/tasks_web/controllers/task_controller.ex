defmodule TasksWeb.TaskController do
  use TasksWeb, :controller

  alias Tasks.Tracker
  alias Tasks.Tracker.Task
  alias Tasks.KafkaProducer
  alias Tasks.UserIdentities.UserIdentity
  alias Tasks.Users.User
  alias Tasks.Repo
  import Ecto.Query

  def index(conn, _params) do
    tasks = Tracker.list_tasks()
    render(conn, "index.html", tasks: tasks)
  end

  def new(conn, _params) do
    employers = Repo.all(from(u in User, where: u.role == :employee, select: {u.email, u.id}))
    changeset = Tracker.change_task(%Task{})
    render(conn, "new.html", changeset: changeset, employers: employers)
  end

  def create(conn, %{"task" => task_params}) do
    case Tracker.create_task(task_params) do
      {:ok, task} ->
        KafkaProducer.task_created(task)
        user = Tasks.Repo.get_by!(UserIdentity, user_id: task.assignee_id)
        KafkaProducer.task_assigned(task, user.uid)

        conn
        |> put_flash(:info, "Task created successfully.")
        |> redirect(to: Routes.task_path(conn, :show, task))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    task = Tracker.get_task!(id)
    render(conn, "show.html", task: task)
  end

  def edit(conn, %{"id" => id} = p) do
    task = Tracker.get_task!(id)
    if task.status == :closed do
      conn
      |> put_flash(:info, "Задача закрыта и запрещена к редактированию")
      |> redirect(to: Routes.task_path(conn, :show, task))
    else
      employers = Repo.all(from(u in User, where: u.role == :employee, select: {u.email, u.id}))
      changeset = Tracker.change_task(task)
      render(conn, "edit.html", task: task, changeset: changeset, employers: employers)
    end
  end

  def close_task(conn, %{"id" => id}) do
    task = Tracker.get_task!(id)
    if task.status != :closed do
      case Tracker.close_task(task) do
        {:ok, task} ->
          KafkaProducer.task_updated(task)
          user = Tasks.Repo.get_by!(UserIdentity, user_id: task.assignee_id)
          KafkaProducer.task_closed(task, user.uid)

          conn
          |> put_flash(:info, "Задача закрыта")
          |> redirect(to: Routes.task_path(conn, :show, task))

        {:error, %Ecto.Changeset{} = changeset} ->
          conn
          |> put_flash(:error, "Не смогли закрыть задачу")
          |> redirect(to: Routes.task_path(conn, :show, task))
      end
    else
      conn
      |> redirect(to: Routes.task_path(conn, :show, task))
    end
  end

  def update(conn, %{"id" => id, "task" => task_params}) do
    old_task = Tracker.get_task!(id)

    case Tracker.update_task(old_task, task_params) do
      {:ok, task} ->
        KafkaProducer.task_updated(task)
        if (old_task.assignee_id != task.assignee_id) do
          user = Tasks.Repo.get_by!(UserIdentity, user_id: task.assignee_id)
          IO.inspect(task)
          KafkaProducer.task_assigned(task, user.uid)
        end

        conn
        |> put_flash(:info, "Task updated successfully.")
        |> redirect(to: Routes.task_path(conn, :show, task))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", task: old_task, changeset: changeset)
    end
  end

  def reassign_tasks(conn, _) do
    users =
      Repo.all(from(u in User, where: u.role == :employee, join: ui in UserIdentity, on: u.id == ui.user_id, select: {u.id, ui.uid}))
      |> Enum.into(%{})

    users_id = Map.keys(users)

    if users_id != [] do
      Repo.all(from(t in Task, where: t.status == :open))
      |> Enum.each(fn task ->
        case Tracker.update_task(task, %{assignee_id: Enum.random(users_id)}) do
          {:ok, new_task} ->
            if task.assignee_id != new_task.assignee_id do

              KafkaProducer.task_assigned(new_task, users[new_task.assignee_id])
            end
          error ->
            Logger.error("error with reassign task #{inspect(error)}")
        end
      end)
    end

    conn
    |> put_flash(:info, "Tasks reassigned successfully.")
    |> redirect(to: Routes.task_path(conn, :index))
  end
end
