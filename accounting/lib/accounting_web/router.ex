defmodule AccountingWeb.Router do
  use AccountingWeb, :router
  use Pow.Phoenix.Router
  use PowAssent.Phoenix.Router
  # import AccountingWeb.AuthCheck

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {AccountingWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :protected do
    # plug :require_authenticated_user
  end

  scope "/" do
    pipe_through :browser

    pow_assent_authorization_post_callback_routes()
  end

  scope "/" do
    pipe_through :browser

    get "/", AccountingWeb.PageController, :index
    pow_assent_routes()
  end

  scope "/", Pow.Phoenix, as: "pow" do
    pipe_through :browser

    resources "/session", SessionController, singleton: true, only: [:delete]
  end

  # Other scopes may use custom stacks.
  # scope "/api", AccountingWeb do
  #   pipe_through :api
  # end
end
