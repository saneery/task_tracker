defmodule Accounting.BillingCycleCron do
  use GenServer
  require Logger
  alias Accounting.Billing
  alias Accounting.Users.User

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], [name: __MODULE__])
  end

  def init(_) do
    # Проверяем что все биллинг циклы за вчера закрыты и выплаты проведены
    {:ok, ref} = :timer.send_interval(:timer.minutes(15), :close_billing_cycles)
    {:ok, %{timer: ref}}
  end

  def handle_info(:close_billing_cycles, state) do
    bcs = Billing.old_billing_cycles()
    Enum.each(bcs, fn bc ->
      payment_sum = Billing.calculate_transactions(bc.id)
      if (payment_sum > 0) do
        Billing.create_transaction(%{
          user_id: bc.user_id,
          billing_cycle_id: bc.id,
          description: "Ежедневная выплата",
          credit: payment_sum,
          type: :payment
        })
        Billing.update_user_balance(bc.user_id, 0)
        # TODO: HERE EMAIL NOTIFICATION
      end
    end)
    {count, _} = Billing.close_old_billing_cycles()
    Logger.info("Closed #{count} billing cycles")
    {:noreply, state}
  end
end
