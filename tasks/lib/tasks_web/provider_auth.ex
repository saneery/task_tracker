defmodule TasksWeb.ProviderAuth do
  use Assent.Strategy.OAuth2.Base

  @impl true
  def default_config(_config) do
    [
      client_id: "1f90b31b-966e-47b9-bdd0-e3d5966b518d",
      client_secret: "TasksClientSecret",
      base_url: "http://localhost:4000/",
      # authorization_params: [scope: "user:read user:write"],
      auth_method: :client_secret_post,
      nonce: true,
      strategy: Assent.Strategy.OAuth2,
      user_url: "http://localhost:4000/oauth/introspect",
      redirect_uri: "http://localhost:4001/auth/oauth2/callback"
    ]
  end

  @impl true
  def normalize(_config, user) do
    {:ok,
      %{
        "sub" => user["public_id"],
        "name" => user["email"],
        "email" => user["email"],
        "role" => user["role"]
      }
    }
  end
end
