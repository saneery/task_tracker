defmodule Accounting.Billing.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  schema "transactions" do
    field :billing_cycle_id, :integer
    field :credit, :float
    field :debit, :float
    field :description, :string
    field :task_id, :integer
    field :type, :string
    field :user_id, :integer

    timestamps()
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:user_id, :description, :debit, :credit, :billing_cycle_id, :task_id, :type])
    |> validate_required([:user_id, :description, :debit, :credit, :billing_cycle_id, :task_id, :type])
  end
end
