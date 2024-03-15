defmodule Accounting.BillingFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Accounting.Billing` context.
  """

  @doc """
  Generate a transaction.
  """
  def transaction_fixture(attrs \\ %{}) do
    {:ok, transaction} =
      attrs
      |> Enum.into(%{
        billing_cycle_id: 42,
        credit: 120.5,
        debit: 120.5,
        description: "some description",
        task_id: 42,
        type: "some type",
        user_id: 42
      })
      |> Accounting.Billing.create_transaction()

    transaction
  end

  @doc """
  Generate a billing_cycle.
  """
  def billing_cycle_fixture(attrs \\ %{}) do
    {:ok, billing_cycle} =
      attrs
      |> Enum.into(%{
        user_id: 42,
        end_date: ~N[2024-03-04 21:04:00],
        start_date: ~N[2024-03-04 21:04:00],
        status: "some status"
      })
      |> Accounting.Billing.create_billing_cycle()

    billing_cycle
  end
end
