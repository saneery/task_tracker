defmodule TasksWeb.Router do
  use TasksWeb, :router

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

  scope "/", TasksWeb do
    pipe_through :browser

    get "/", PageController, :index
    resources "/tasks", TaskController
    post "/tasks/close", TaskController, :close_task
  end

end
