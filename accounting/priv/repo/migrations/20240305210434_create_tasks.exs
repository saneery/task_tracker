defmodule Accounting.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :debit_cost, :integer
      add :credit_cost, :integer
      add :public_id, :string

      timestamps()
    end
  end
end
