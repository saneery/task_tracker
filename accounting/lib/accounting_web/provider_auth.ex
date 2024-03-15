defmodule AccountingWeb.ProviderAuth do
  use Assent.Strategy.OAuth2.Base

  @impl true
  def default_config(_config) do
    [
      client_id: "2338ecfc-12a2-405d-9b83-b24fa5eb363a",
      client_secret: "BillingClientSecret",
      base_url: "http://localhost:4000/",
      # authorization_params: [scope: "user:read user:write"],
      auth_method: :client_secret_post,
      nonce: true,
      strategy: Assent.Strategy.OAuth2,
      user_url: "http://localhost:4000/api/user",
      redirect_uri: "http://localhost:4002/auth/oauth2/callback"
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
