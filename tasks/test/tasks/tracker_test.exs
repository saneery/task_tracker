defmodule Tasks.TrackerTest do
  use Tasks.DataCase

  alias Tasks.Tracker

  describe "tasks" do
    alias Tasks.Tracker.Task

    import Tasks.TrackerFixtures

    @invalid_attrs %{assignee_id: nil, status: nil, title: nil}

    test "list_tasks/0 returns all tasks" do
      task = task_fixture()
      assert Tracker.list_tasks() == [task]
    end

    test "get_task!/1 returns the task with given id" do
      task = task_fixture()
      assert Tracker.get_task!(task.id) == task
    end

    test "create_task/1 with valid data creates a task" do
      valid_attrs = %{assignee_id: 42, status: "some status", title: "some title"}

      assert {:ok, %Task{} = task} = Tracker.create_task(valid_attrs)
      assert task.assignee_id == 42
      assert task.status == "some status"
      assert task.title == "some title"
    end

    test "create_task/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tracker.create_task(@invalid_attrs)
    end

    test "update_task/2 with valid data updates the task" do
      task = task_fixture()
      update_attrs = %{assignee_id: 43, status: "some updated status", title: "some updated title"}

      assert {:ok, %Task{} = task} = Tracker.update_task(task, update_attrs)
      assert task.assignee_id == 43
      assert task.status == "some updated status"
      assert task.title == "some updated title"
    end

    test "update_task/2 with invalid data returns error changeset" do
      task = task_fixture()
      assert {:error, %Ecto.Changeset{}} = Tracker.update_task(task, @invalid_attrs)
      assert task == Tracker.get_task!(task.id)
    end

    test "delete_task/1 deletes the task" do
      task = task_fixture()
      assert {:ok, %Task{}} = Tracker.delete_task(task)
      assert_raise Ecto.NoResultsError, fn -> Tracker.get_task!(task.id) end
    end

    test "change_task/1 returns a task changeset" do
      task = task_fixture()
      assert %Ecto.Changeset{} = Tracker.change_task(task)
    end
  end
end
