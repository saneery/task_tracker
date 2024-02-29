defmodule Tasks.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :assignee_id, :integer
      add :title, :string
      add :status, :string

      timestamps()
    end
  end
end
