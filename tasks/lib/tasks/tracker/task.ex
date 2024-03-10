defmodule Tasks.Tracker.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field :assignee_id, :integer
    field :status, Ecto.Enum, values: [:open, :closed], default: :open
    field :title, :string
    field :public_id, :string
    field :jira_id, :string
    belongs_to :assigned_user, Tasks.Users.User, foreign_key: :assignee_id, define_field: false

    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:assignee_id, :title, :public_id, :jira_id])
    |> validate_change(:title, fn field, value ->
      case String.contains?(value, ["[", "]"]) do
        true ->
          [{field, "jira_id should be in jira_id field"}]
        false ->
          []
      end
    end)
    |> validate_required([:assignee_id, :title, :jira_id])
  end

  def close_task(task) do
    task
    |> put_change(:status, :closed)
  end
end
