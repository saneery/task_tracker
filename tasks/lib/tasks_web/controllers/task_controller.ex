defmodule TasksWeb.TaskController do
  use TasksWeb, :controller

  alias Tasks.Tracker
  alias Tasks.Tracker.Task

  def index(conn, _params) do
    tasks = Tracker.list_tasks()
    render(conn, "index.html", tasks: tasks)
  end

  def new(conn, _params) do
    changeset = Tracker.change_task(%Task{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"task" => task_params}) do
    case Tracker.create_task(task_params) do
      {:ok, task} ->
        conn
        |> put_flash(:info, "Task created successfully.")
        |> redirect(to: Routes.task_path(conn, :show, task))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    task = Tracker.get_task!(id)
    render(conn, "show.html", task: task)
  end

  def edit(conn, %{"id" => id} = p) do
    task = Tracker.get_task!(id)
    if task.status == :closed do
      conn
      |> put_flash(:info, "Задача закрыта и запрещена к редактированию")
      |> redirect(to: Routes.task_path(conn, :show, task))
    else
      changeset = Tracker.change_task(task)
      render(conn, "edit.html", task: task, changeset: changeset)
    end
  end

  def close_task(conn, %{"id" => id}) do
    task = Tracker.get_task!(id)
    if task.status != :closed do
      case Tracker.close_task(task) do
        {:ok, task} ->
          conn
          |> put_flash(:info, "Задача закрыта")
          |> redirect(to: Routes.task_path(conn, :show, task))

        {:error, %Ecto.Changeset{} = changeset} ->
          conn
          |> put_flash(:error, "Не смогли закрыть задачу")
          |> redirect(to: Routes.task_path(conn, :show, task))
      end
    else
      conn
      |> redirect(to: Routes.task_path(conn, :show, task))
    end
  end

  def update(conn, %{"id" => id, "task" => task_params}) do
    task = Tracker.get_task!(id)

    case Tracker.update_task(task) do
      {:ok, task} ->
        conn
        |> put_flash(:info, "Task updated successfully.")
        |> redirect(to: Routes.task_path(conn, :show, task))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", task: task, changeset: changeset)
    end
  end
end
