defmodule AuthWeb.PageView do
  use AuthWeb, :view

  def render("user.json", %{user: user}) do
    %{
      public_id: user.public_id,
      role: user.role,
      email: user.email
    }
  end
end
