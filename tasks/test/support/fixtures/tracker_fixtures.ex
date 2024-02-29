defmodule Tasks.TrackerFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Tasks.Tracker` context.
  """

  @doc """
  Generate a task.
  """
  def task_fixture(attrs \\ %{}) do
    {:ok, task} =
      attrs
      |> Enum.into(%{
        assignee_id: 42,
        status: "some status",
        title: "some title"
      })
      |> Tasks.Tracker.create_task()

    task
  end
end
