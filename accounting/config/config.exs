# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :accounting,
  ecto_repos: [Accounting.Repo]

# Configures the endpoint
config :accounting, AccountingWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: AccountingWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Accounting.PubSub,
  live_view: [signing_salt: "eQsQBMNG"]

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

config :accounting, :pow,
  user: Accounting.Users.User,
  repo: Accounting.Repo,
  routes_backend: AccountingWeb.Accounting

config :accounting, :pow_assent,
  providers: [
    oauth2: [
      client_id: "2338ecfc-12a2-405d-9b83-b24fa5eb363a",
      client_secret: "BillingClientSecret",
      base_url: "http://localhost:4000/",
      auth_method: :client_secret_post,
      nonce: true,
      strategy: AccountingWeb.ProviderAuth,
      user_url: "http://localhost:4000/api/user",
      redirect_uri: "http://localhost:4002/auth/oauth2/callback"
    ]
  ]

config :kaffe,
  consumer: [
    endpoints: [localhost: 9092],
    topics: ["accounts-cud"],
    consumer_group: "billing",
    group_config: [
      {:offset_commit_policy, :commit_to_kafka_v2},
      {:offset_commit_interval_seconds, 1}
    ],
    message_handler: Accounting.KafkaConsumer,
    offset_reset_policy: :reset_to_earliest,
    worker_allocation_strategy: :worker_per_topic_partition
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
