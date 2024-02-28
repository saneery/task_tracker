# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :tasks,
  ecto_repos: [Tasks.Repo]

# Configures the endpoint
config :tasks, TasksWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: TasksWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Tasks.PubSub,
  live_view: [signing_salt: "1lADoiXo"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :tasks, Tasks.Mailer, adapter: Swoosh.Adapters.Local

config :tasks, :pow,
  user: Tasks.Users.User,
  repo: Tasks.Repo

config :tasks, :pow_assent,
  providers: [
    oauth2: [
      client_id: "1f90b31b-966e-47b9-bdd0-e3d5966b518d",
      client_secret: "TasksClientSecret",
      base_url: "http://localhost:4000/",
      # authorization_params: [scope: "user:read user:write"],
      auth_method: :client_secret_post,
      nonce: true,
      strategy: TasksWeb.ProviderAuth,
      user_url: "http://localhost:4000/oauth/introspect",
      redirect_uri: "http://localhost:4001/auth/oauth2/callback"
    ]
  ]

# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, false

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.14.29",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :tasks, :pow,
  user: Tasks.Users.User,
  repo: Tasks.Repo

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
