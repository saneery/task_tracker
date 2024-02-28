defmodule Tasks.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :title, :string
      add :status, :string
      add :closed_at, :naive_datetime
      add :assigned_user_id, :integer

      timestamps()
    end
  end
end
