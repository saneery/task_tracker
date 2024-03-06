defmodule AccountingWeb.PowRouter do
  use Pow.Phoenix.Routes

  @impl true
  def after_sign_out_path(conn), do: "/"
end
