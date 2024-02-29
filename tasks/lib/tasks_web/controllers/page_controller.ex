defmodule TasksWeb.PageController do
  use TasksWeb, :controller

  def index(conn, _params) do
    redirect(conn, to: Routes.task_path(conn, :index))
  end
end
