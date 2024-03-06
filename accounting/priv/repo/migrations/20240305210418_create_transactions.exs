defmodule Accounting.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :user_id, :integer
      add :description, :string
      add :debit, :float
      add :credit, :float
      add :billing_cycle_id, :integer
      add :task_id, :integer
      add :type, :string

      timestamps()
    end
  end
end
