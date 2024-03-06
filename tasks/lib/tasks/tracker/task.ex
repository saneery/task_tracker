defmodule Tasks.Tracker.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field :assignee_id, :integer
    field :status, Ecto.Enum, values: [:open, :closed], default: :open
    field :title, :string
    field :public_id, :string
    belongs_to :assigned_user, Tasks.Users.User, foreign_key: :assignee_id, define_field: false

    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:assignee_id, :title, :public_id])
    |> validate_required([:assignee_id, :title])
  end

  def close_task(task) do
    task
    |> put_change(:status, :closed)
  end
end
