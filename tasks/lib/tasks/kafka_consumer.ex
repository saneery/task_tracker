defmodule Tasks.KafkaConsumer do
  require Logger
  alias Tasks.Repo
  alias Tasks.Users.User
  alias Tasks.UserIdentities.UserIdentity

  def handle_messages(messages) do
    for message <- messages do
      handle_message(message)
    end
    :ok
  end

  defp handle_message(%{topic: "accounts-cud", value: value}) do
    case Jason.decode(value) do
      {:ok, event} -> handle_event(event)
      _ -> Logger.error("cannot decode message: #{inspect(value)}")
    end
  end
  defp handle_message(message), do: Logger.warn("unexpected message: #{inspect(message)}")



  defp handle_event(%{"event_name" => "AccountCreated", "data" => attrs}) do
    case Repo.get_by(UserIdentity, uid: attrs["public_id"]) do
      nil ->
        create_user(attrs)

      _ -> :ok
    end
  end

  defp handle_event(%{"event_name" => "AccountUpdated", "data" => attrs}) do
    case Repo.get_by(UserIdentity, uid: attrs["public_id"]) do
      nil -> :ok
      user_identity ->
        User
        |> Repo.get_by(id: user_identity.user_id)
        |> update_user(attrs)
    end
  end

  defp handle_event(%{"event_name" => "AccountDeleted", "data" => attrs}) do
    case Repo.get_by(UserIdentity, uid: attrs["public_id"]) do
      nil -> :ok
      user_identity ->
        Repo.delete(user_identity)
        if !is_nil(user_identity.user_id) do
          case Repo.get_by(User, id: user_identity.user_id) do
            nil -> :ok
            user -> Repo.delete(user)
          end
        end
    end
  end

  defp create_user(attrs) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert(on_conflict: :nothing)
    |> case do
      {:ok, user} ->
        %UserIdentity{}
        |> UserIdentity.changeset(%{
          "uid" => attrs["public_id"],
          "user_id" => user.id,
          "provider" => "oauth2"
        })
        |> Repo.insert()
      _ -> :ok
    end
  end

  defp update_user(user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end
end
