defmodule AuthWeb.PageController do
  use AuthWeb, :controller
  alias AuthWeb.PageView
  alias Boruta.Oauth.Authorization.AccessToken
  alias Boruta.Oauth.BearerToken

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def userinfo(%Plug.Conn{} = conn, _params) do
    with {:ok, access_token} <- BearerToken.extract_token(conn),
         {:ok, token} <- AccessToken.authorize(value: access_token),
         %Auth.Accounts.User{} = user <- Auth.Repo.get_by(Auth.Accounts.User, id: token.sub) do
      conn
      |> put_view(PageView)
      |> render("user.json", user: user)
    else
      _ -> {:error, "User not found."}
    end
  end
end
