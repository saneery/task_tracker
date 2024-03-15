defmodule Tasks.Repo.Migrations.AddPublicIdToTasks do
  use Ecto.Migration

  def change do
    alter table("tasks") do
      add :public_id, :string
    end
  end
end
