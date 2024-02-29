defmodule Auth.Repo.Migrations.AddRoleToUsers do
  use Ecto.Migration

  def change do
    alter table("users") do
      add :role, :string
      add :public_id, :string
    end
  end
end
