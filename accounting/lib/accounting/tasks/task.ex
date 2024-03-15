defmodule Accounting.Tasks.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field :credit_cost, :integer
    field :debit_cost, :integer
    field :public_id, :string

    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:public_id])
    |> validate_required([:public_id])
  end

  def set_costs(changeset) do
    changeset
    |> put_change(:debit_cost, Enum.random(20..40))
    |> put_change(:credit_cost, Enum.random(10..20))
  end
end
