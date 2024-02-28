defmodule Tasks.CtxFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Tasks.Ctx` context.
  """

  @doc """
  Generate a task.
  """
  def task_fixture(attrs \\ %{}) do
    {:ok, task} =
      attrs
      |> Enum.into(%{
        assigned_user_id: 42,
        closed_at: ~N[2024-02-26 07:28:00],
        status: "some status",
        title: "some title"
      })
      |> Tasks.Ctx.create_task()

    task
  end
end
