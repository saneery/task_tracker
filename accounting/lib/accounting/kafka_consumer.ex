defmodule Accounting.KafkaConsumer do
  require Logger
  alias Accounting.Kafka.{Accounts, Tasks}

  def handle_messages(messages) do
    for message <- messages do
      handle_message(message)
    end
    :ok
  end

  defp handle_message(%{topic: "accounts-cud", value: value}) do
    case Jason.decode(value) do
      {:ok, event} -> Accounts.handle_event(event)
      _ -> Logger.error("cannot decode message: #{inspect(value)}")
    end
  end

  defp handle_message(%{topic: topic, value: value}) when topic in ["tasks-cud", "tasks"] do
    case Jason.decode(value) do
      {:ok, event} -> Tasks.handle_event(event)
      _ -> Logger.error("cannot decode message: #{inspect(value)}")
    end
  end

  defp handle_message(message), do: Logger.warn("unexpected message: #{inspect(message)}")

end
