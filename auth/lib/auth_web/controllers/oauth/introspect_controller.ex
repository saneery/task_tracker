defmodule AuthWeb.Oauth.IntrospectController do
  @behaviour Boruta.Oauth.IntrospectApplication

  use AuthWeb, :controller

  alias Boruta.Oauth.Error
  alias Boruta.Oauth.IntrospectResponse
  alias AuthWeb.OauthView
  alias Boruta.Oauth.Authorization.AccessToken
  alias Boruta.Oauth.BearerToken

  def oauth_module, do: Application.get_env(:auth, :oauth_module, Boruta.Oauth)

  def introspect(%Plug.Conn{} = conn, _params) do
    with {:ok, access_token} <- BearerToken.extract_token(conn),
         {:ok, token} <- AccessToken.authorize(value: access_token),
         %Auth.Accounts.User{} = user <- Auth.Repo.get_by(Auth.Accounts.User, id: token.sub) do
      conn
      |> put_view(OauthView)
      |> render("user.json", user: user)
    else
      _ -> {:error, "User not found."}
    end
  end
end
