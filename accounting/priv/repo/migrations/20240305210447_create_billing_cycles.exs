defmodule Accounting.Repo.Migrations.CreateBillingCycles do
  use Ecto.Migration

  def change do
    create table(:billing_cycles) do
      add :user_id, :integer
      add :status, :string
      add :start_date, :naive_datetime
      add :end_date, :naive_datetime

      timestamps()
    end
  end
end
