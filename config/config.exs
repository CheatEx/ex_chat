# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :ex_chat,
  ecto_repos: [ExChat.Repo]

# Configures the endpoint
config :ex_chat, ExChatWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: ExChatWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: ExChat.PubSub,
  live_view: [signing_salt: "TYP3/CgI"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
config :ex_chat, ExChat.Guardian,
  issuer: "ExChat",
  allowed_algos: ["HS512"], # optional
  verify_module: Guardian.JWT,  # optional
  ttl: { 30, :days },
  allowed_drift: 2000,
  verify_issuer: true # optional

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
