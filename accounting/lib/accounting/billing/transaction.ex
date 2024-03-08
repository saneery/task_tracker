defmodule Accounting.Billing.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  schema "transactions" do
    field :billing_cycle_id, :integer
    field :credit, :float, default: 0.0
    field :debit, :float, default: 0.0
    field :description, :string
    field :task_id, :integer
    field :type, Ecto.Enum, values: [:enrollment, :withdrawal, :payment]
    field :user_id, :integer

    timestamps()
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:user_id, :description, :debit, :credit, :billing_cycle_id, :task_id, :type])
    |> validate_required([:user_id, :billing_cycle_id, :type])
  end
end
