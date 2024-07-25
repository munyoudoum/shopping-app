# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :shopping,
  ecto_repos: [Shopping.Repo],
  generators: [timestamp_type: :utc_datetime]

config :shopping, Shopping.UserManager.Guardian,
  issuer: "shopping",
  # Generate a new secret key with `mix guardian.gen.secret`
  # Replace in production
  secret_key: "CtnrXEYqoxAhXFOgkgs9lmVNArdzJZ4l7h1WTMyWVInnMMd4n7Gj5w6iOC0T0TfF"

# Configures the endpoint
config :shopping, ShoppingWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [json: ShoppingWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Shopping.PubSub,
  live_view: [signing_salt: "gYTPb7Qb"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :shopping, Shopping.Mailer, adapter: Swoosh.Adapters.Local


# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
