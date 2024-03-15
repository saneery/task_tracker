defmodule TasksWeb.Router do
  use TasksWeb, :router
  use Pow.Phoenix.Router
  use PowAssent.Phoenix.Router
  import TasksWeb.AuthCheck

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {TasksWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :skip_csrf_protection do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :put_secure_browser_headers
  end

  pipeline :protected do
    plug :require_authenticated_user
  end

  scope "/" do
    pipe_through :skip_csrf_protection

    pow_assent_authorization_post_callback_routes()
  end

  scope "/" do
    pipe_through [:browser]
    get "/", TasksWeb.PageController, :index
    # pow_routes()
    pow_assent_routes()
  end

  scope "/", Pow.Phoenix, as: "pow" do
    pipe_through :browser

    resources "/session", SessionController, singleton: true, only: [:delete]
  end

  scope "/", TasksWeb do
    pipe_through [:browser, :protected]

    resources "/tasks", TaskController
    post "/tasks/close", TaskController, :close_task
    post "/tasks/reassign_all", TaskController, :reassign_tasks
  end

end
