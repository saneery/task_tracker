defmodule Accounting.TasksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Accounting.Tasks` context.
  """

  @doc """
  Generate a task.
  """
  def task_fixture(attrs \\ %{}) do
    {:ok, task} =
      attrs
      |> Enum.into(%{
        credit_cost: 42,
        debit_cost: 42,
        public_id: "some public_id"
      })
      |> Accounting.Tasks.create_task()

    task
  end
end
