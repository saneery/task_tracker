defmodule Accounting.Billing.BillingCycle do
  use Ecto.Schema
  import Ecto.Changeset

  schema "billing_cycles" do
    field :user_id, :integer
    field :end_date, :naive_datetime
    field :start_date, :naive_datetime
    field :status, :string

    timestamps()
  end

  @doc false
  def changeset(billing_cycle, attrs) do
    billing_cycle
    |> cast(attrs, [:user_id, :status, :start_date, :end_date])
    |> validate_required([:user_id, :status, :start_date, :end_date])
  end
end
