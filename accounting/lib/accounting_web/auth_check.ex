defmodule AccountingWeb.AuthCheck do
  import Plug.Conn
  import Phoenix.Controller
  alias AccountingWeb.Router.Helpers, as: Routes

  def require_authenticated_user(conn, _) do
    if conn.assigns[:current_user] do
      conn
    else
      conn
      |> put_flash(:error, "You must log in to access this page.")
      |> redirect(to: Routes.page_path(conn, :index))
      |> halt()
    end
  end

  def require_role(conn, roles) do
    if conn.assigns[:current_user] && conn.assigns[:current_user].role in roles do
      conn
    else
      conn
      |> put_flash(:error, "You must have role #{inspect(roles)} to access this page.")
      |> maybe_store_return_to()
      |> redirect(to: Routes.page_path(conn, :index))
      |> halt()
    end
  end

  defp maybe_store_return_to(%{method: "GET"} = conn) do
    put_session(conn, :user_return_to, current_path(conn))
  end

  defp maybe_store_return_to(conn), do: conn
end
