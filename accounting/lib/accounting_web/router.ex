defmodule AccountingWeb.Router do
  use AccountingWeb, :router
  use Pow.Phoenix.Router
  use PowAssent.Phoenix.Router
  import AccountingWeb.AuthCheck

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
    plug :browser
    plug :require_authenticated_user
    plug :require_role, [:admin, :manager]
  end

  scope "/" do
    pipe_through :browser

    pow_assent_authorization_post_callback_routes()
  end

  scope "/" do
    pipe_through :browser

    get "/", AccountingWeb.PageController, :index
    pow_assent_routes()

    resources "/transactions", AccountingWeb.TransactionController
    get "/my_balance", AccountingWeb.TransactionController, :balance

    pipe_through :protected
    get "/company_dashboard", AccountingWeb.PageController, :company_dashboard
    get "/analytics", AccountingWeb.PageController, :analytics
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
