defmodule AuthWeb.PageView do
  use AuthWeb, :view

  def render("userinfo.json", %{response: response}) do
    # Boruta.Openid.UserinfoResponse.payload(response) |> IO.inspect()
    response |> IO.inspect()
  end
end
