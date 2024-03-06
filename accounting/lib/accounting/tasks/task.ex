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
    |> cast(attrs, [:debit_cost, :credit_cost, :public_id])
    |> validate_required([:debit_cost, :credit_cost, :public_id])
  end
end
