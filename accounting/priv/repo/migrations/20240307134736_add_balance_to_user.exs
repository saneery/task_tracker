defmodule Accounting.Repo.Migrations.AddBalanceToUser do
  use Ecto.Migration

  def change do
    alter table("users") do
      add :balance, :float, default: 0.0
    end
  end
end
