defmodule AccountingWeb.PageController do
  use AccountingWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
