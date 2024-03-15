defmodule Accounting.TasksTest do
  use Accounting.DataCase

  alias Accounting.Tasks

  describe "tasks" do
    alias Accounting.Tasks.Task

    import Accounting.TasksFixtures

    @invalid_attrs %{credit_cost: nil, debit_cost: nil, public_id: nil}

    test "list_tasks/0 returns all tasks" do
      task = task_fixture()
      assert Tasks.list_tasks() == [task]
    end

    test "get_task!/1 returns the task with given id" do
      task = task_fixture()
      assert Tasks.get_task!(task.id) == task
    end

    test "create_task/1 with valid data creates a task" do
      valid_attrs = %{credit_cost: 42, debit_cost: 42, public_id: "some public_id"}

      assert {:ok, %Task{} = task} = Tasks.create_task(valid_attrs)
      assert task.credit_cost == 42
      assert task.debit_cost == 42
      assert task.public_id == "some public_id"
    end

    test "create_task/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tasks.create_task(@invalid_attrs)
    end

    test "update_task/2 with valid data updates the task" do
      task = task_fixture()
      update_attrs = %{credit_cost: 43, debit_cost: 43, public_id: "some updated public_id"}

      assert {:ok, %Task{} = task} = Tasks.update_task(task, update_attrs)
      assert task.credit_cost == 43
      assert task.debit_cost == 43
      assert task.public_id == "some updated public_id"
    end

    test "update_task/2 with invalid data returns error changeset" do
      task = task_fixture()
      assert {:error, %Ecto.Changeset{}} = Tasks.update_task(task, @invalid_attrs)
      assert task == Tasks.get_task!(task.id)
    end

    test "delete_task/1 deletes the task" do
      task = task_fixture()
      assert {:ok, %Task{}} = Tasks.delete_task(task)
      assert_raise Ecto.NoResultsError, fn -> Tasks.get_task!(task.id) end
    end

    test "change_task/1 returns a task changeset" do
      task = task_fixture()
      assert %Ecto.Changeset{} = Tasks.change_task(task)
    end
  end
end
