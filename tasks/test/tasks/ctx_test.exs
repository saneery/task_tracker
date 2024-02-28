defmodule Tasks.CtxTest do
  use Tasks.DataCase

  alias Tasks.Ctx

  describe "tasks" do
    alias Tasks.Ctx.Task

    import Tasks.CtxFixtures

    @invalid_attrs %{assigned_user_id: nil, closed_at: nil, status: nil, title: nil}

    test "list_tasks/0 returns all tasks" do
      task = task_fixture()
      assert Ctx.list_tasks() == [task]
    end

    test "get_task!/1 returns the task with given id" do
      task = task_fixture()
      assert Ctx.get_task!(task.id) == task
    end

    test "create_task/1 with valid data creates a task" do
      valid_attrs = %{assigned_user_id: 42, closed_at: ~N[2024-02-26 07:28:00], status: "some status", title: "some title"}

      assert {:ok, %Task{} = task} = Ctx.create_task(valid_attrs)
      assert task.assigned_user_id == 42
      assert task.closed_at == ~N[2024-02-26 07:28:00]
      assert task.status == "some status"
      assert task.title == "some title"
    end

    test "create_task/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Ctx.create_task(@invalid_attrs)
    end

    test "update_task/2 with valid data updates the task" do
      task = task_fixture()
      update_attrs = %{assigned_user_id: 43, closed_at: ~N[2024-02-27 07:28:00], status: "some updated status", title: "some updated title"}

      assert {:ok, %Task{} = task} = Ctx.update_task(task, update_attrs)
      assert task.assigned_user_id == 43
      assert task.closed_at == ~N[2024-02-27 07:28:00]
      assert task.status == "some updated status"
      assert task.title == "some updated title"
    end

    test "update_task/2 with invalid data returns error changeset" do
      task = task_fixture()
      assert {:error, %Ecto.Changeset{}} = Ctx.update_task(task, @invalid_attrs)
      assert task == Ctx.get_task!(task.id)
    end

    test "delete_task/1 deletes the task" do
      task = task_fixture()
      assert {:ok, %Task{}} = Ctx.delete_task(task)
      assert_raise Ecto.NoResultsError, fn -> Ctx.get_task!(task.id) end
    end

    test "change_task/1 returns a task changeset" do
      task = task_fixture()
      assert %Ecto.Changeset{} = Ctx.change_task(task)
    end
  end
end
