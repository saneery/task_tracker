defmodule Auth.KafkaProducer do

  def account_created(user) do
    event = event = serialize_user("account_created", user)

    Kaffe.Producer.produce_sync("accounts-cud", event)
  end

  def account_updated(user) do
    event = serialize_user("account_updated", user)

    Kaffe.Producer.produce_sync("accounts-cud", event)
  end

  def account_deleted(user) do
    event = serialize_user("account_deleted", user)

    Kaffe.Producer.produce_sync("accounts-cud", event)
  end

  defp serialize_user(event_name, user) do
    Jason.encode!(%{
      event: event_name,
      account: %{
        public_id: user.public_id,
        email: user.email,
        role: user.role
      }
    })
  end
end
