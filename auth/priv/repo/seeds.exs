# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Auth.Repo.insert!(%Auth.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

attrs = %{email: "admin@admin.com", password: "admin", role: :admin}
{:ok, admin} = %Auth.Accounts.User{}
|> Auth.Accounts.User.registration_changeset(attrs)
|> Auth.Accounts.User.changeset(attrs)
|> Auth.Repo.insert()

Auth.KafkaProducer.account_created(admin)

id = SecureRandom.uuid()

Boruta.Ecto.Admin.create_client(%{
  id: "1f90b31b-966e-47b9-bdd0-e3d5966b518d", # OAuth client_id
  secret: "TasksClientSecret", # OAuth client_secret
  name: "TasksClient", # Display name
  access_token_ttl: 60 * 60 * 24, # one day
  authorization_code_ttl: 60, # one minute
  refresh_token_ttl: 60 * 60 * 24 * 30, # one month
  id_token_ttl: 60 * 60 * 24, # one day
  id_token_signature_alg: "RS256", # ID token signature algorithm, defaults to "RS512"
  userinfo_signed_response_alg: "RS256", # userinfo signature algorithm, defaults to nil (no signature)
  redirect_uris: ["http://localhost:4001/auth/oauth2/callback"], # OAuth client redirect_uris
  authorize_scope: true, # take following authorized_scopes into account (skip public scopes)
  authorized_scopes: [%{name: "a:scope"}], # scopes that are authorized using this client
  supported_grant_types: [ # client supported grant types
    "client_credentials",
    "password",
    "authorization_code",
    "refresh_token",
    "implicit",
    "revoke",
    "introspect"
  ],
  pkce: false, # PKCE enabled
  public_refresh_token: false, # do not require client_secret for refreshing tokens
  public_revoke: false, # do not require client_secret for revoking tokens
  confidential: true, # see OAuth 2.0 confidentiality (requires client secret for some flows)
  token_endpont_auth_methods: [ # activable client authentication methods
    "client_secret_basic",
    "client_secret_post",
    "client_secret_jwt",
    "private_key_jwt"
  ]
})

Boruta.Ecto.Admin.create_client(%{
  id: "2338ecfc-12a2-405d-9b83-b24fa5eb363a", # OAuth client_id
  secret: "BillingClientSecret", # OAuth client_secret
  name: "BillingClient", # Display name
  access_token_ttl: 60 * 60 * 24, # one day
  authorization_code_ttl: 60, # one minute
  refresh_token_ttl: 60 * 60 * 24 * 30, # one month
  id_token_ttl: 60 * 60 * 24, # one day
  id_token_signature_alg: "RS256", # ID token signature algorithm, defaults to "RS512"
  userinfo_signed_response_alg: "RS256", # userinfo signature algorithm, defaults to nil (no signature)
  redirect_uris: ["http://localhost:4002/auth/oauth2/callback"], # OAuth client redirect_uris
  authorize_scope: true, # take following authorized_scopes into account (skip public scopes)
  authorized_scopes: [%{name: "a:scope"}], # scopes that are authorized using this client
  supported_grant_types: [ # client supported grant types
    "client_credentials",
    "password",
    "authorization_code",
    "refresh_token",
    "implicit",
    "revoke",
    "introspect"
  ],
  pkce: false, # PKCE enabled
  public_refresh_token: false, # do not require client_secret for refreshing tokens
  public_revoke: false, # do not require client_secret for revoking tokens
  confidential: true, # see OAuth 2.0 confidentiality (requires client secret for some flows)
  token_endpont_auth_methods: [ # activable client authentication methods
    "client_secret_basic",
    "client_secret_post",
    "client_secret_jwt",
    "private_key_jwt"
  ]
})
