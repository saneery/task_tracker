defmodule Tasks.KafkaProducer do
  require Logger

  # ---- CUD EVENTS ----

  def task_created(task) do
    event = add_meta(%{
      "event_name" => "TaskCreated",
      "data" => %{
        "public_id" => task.public_id,
        "status" => Atom.to_string(task.status),
        "title" => task.title
      }
    })

    case SchemaRegistry.validate_event(event, "tasks.created", 1) do
      :ok -> Kaffe.Producer.produce_sync("tasks-cud", "key", Jason.encode!(event))
      {:error, desc} ->
        Logger.error("TaskCreated event producing error #{inspect(desc)}")
    end
  end

  def task_updated(task) do
    event = add_meta(%{
      "event_name" => "TaskUpdated",
      "data" => %{
        "public_id" => task.public_id,
        "status" => Atom.to_string(task.status),
        "title" => task.title
      }
    })

    case SchemaRegistry.validate_event(event, "tasks.updated", 1) do
      :ok -> Kaffe.Producer.produce_sync("tasks-cud", "key", Jason.encode!(event))
      {:error, desc} ->
        Logger.error("TaskUpdated event producing error #{inspect(desc)}")
    end
  end

  def task_deleted(task) do
    event = add_meta(%{
      "event_name" => "TaskDeleted",
      "data" => %{
        "public_id" => task.public_id
      }
    })

    case SchemaRegistry.validate_event(event, "tasks.deleted", 1) do
      :ok -> Kaffe.Producer.produce_sync("tasks-cud", "key", Jason.encode!(event))
      {:error, desc} ->
        Logger.error("TaskDeleted event producing error #{inspect(desc)}")
    end
  end

  # ---- BUSINESS EVENTS ----

  def task_assigned(task, public_id) do
    event = add_meta(%{
      "event_name" => "TaskAssigned",
      "data" => %{
        "public_id" => task.public_id,
        "assignee_id" => public_id
      }
    })

    case SchemaRegistry.validate_event(event, "tasks.assigned", 1) do
      :ok -> Kaffe.Producer.produce_sync("tasks", "key", Jason.encode!(event))
      {:error, desc} ->
        Logger.error("TaskAssigned event producing error #{inspect(desc)}")
    end
  end

  def task_closed(task, uid) do
    event = add_meta(%{
      "event_name" => "TaskClosed",
      "data" => %{
        "public_id" => task.public_id,
        "assignee_id" => uid
      }
    })

    case SchemaRegistry.validate_event(event, "tasks.closed", 1) do
      :ok -> Kaffe.Producer.produce_sync("tasks", "key", Jason.encode!(event))
      {:error, desc} ->
        Logger.error("TaskClosed event producing error #{inspect(desc)}")
    end
  end



  # --- INTERNAL FUNCTIONS ----

  defp add_meta(map) do
    map
    |> Map.merge(%{
      "event_id" => Ecto.UUID.generate(),
      "event_version" => 1,
      "event_time" => DateTime.utc_now() |> DateTime.to_string,
      "producer" => "tasks_service"
    })
  end
end
