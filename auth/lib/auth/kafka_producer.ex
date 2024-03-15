defmodule Auth.KafkaProducer do
  require Logger

  def account_created(user) do
    event = add_meta(%{
      "event_name" => "AccountCreated",
      "data" => %{
        "public_id" => user.public_id,
        "email" => user.email,
        "role" => Atom.to_string(user.role)
      }
    })

    case SchemaRegistry.validate_event(event, "accounts.created", 1) do
      :ok -> Kaffe.Producer.produce_sync("accounts-cud", Jason.encode!(event))
      {:error, desc} ->
        Logger.error("AccountCreated event producing error #{inspect(desc)}")
    end
  end

  def account_updated(user) do
    event = add_meta(%{
      "event_name" => "AccountUpdated",
      "data" => %{
        "public_id" => user.public_id,
        "email" => user.email,
        "role" => Atom.to_string(user.role)
      }
    })

    case SchemaRegistry.validate_event(event, "accounts.updated", 1) do
      :ok -> Kaffe.Producer.produce_sync("accounts-cud", Jason.encode!(event))
      {:error, desc} ->
        Logger.error("AccountUpdated event producing error #{inspect(desc)}")
    end
  end

  def account_deleted(user) do
    event = add_meta(%{
      "event_name" => "AccountDeleted",
      "data" => %{
        "public_id" => user.public_id
      }
    })

    case SchemaRegistry.validate_event(event, "accounts.deleted", 1) do
      :ok -> Kaffe.Producer.produce_sync("accounts-cud", Jason.encode!(event))
      {:error, desc} ->
        Logger.error("AccountDeleted event producing error #{inspect(desc)}")
    end
  end

  defp add_meta(map) do
    map
    |> Map.merge(%{
      "event_id" => SecureRandom.uuid,
      "event_version" => 1,
      "event_time" => DateTime.utc_now() |> DateTime.to_string,
      "producer" => "auth_service"
    })
  end
end
