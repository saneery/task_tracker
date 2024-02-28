defmodule Tasks.Ctx.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field :assigned_user_id, :integer
    field :closed_at, :naive_datetime
    field :status, :string
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:title, :status, :closed_at, :assigned_user_id])
    |> validate_required([:title, :status, :closed_at, :assigned_user_id])
  end
end
