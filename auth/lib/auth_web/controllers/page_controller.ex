defmodule AuthWeb.PageController do
  use AuthWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def userinfo(conn, params) do
    Boruta.Openid.userinfo(conn, __MODULE__)
    # render(conn, "userinfo.json", response: %{})
  end

  def userinfo_fetched(conn, userinfo) do
    # IO.inspect((userinfo))
    render(conn, "userinfo.json", response: userinfo)
  end
end
