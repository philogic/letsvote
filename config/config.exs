# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :letsvote,
  ecto_repos: [Letsvote.Repo]

# Configures the endpoint
config :letsvote, LetsvoteWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "1mGDWNZkY0Beys7QVBt+3L9K6pSaQuaO3FjUFTwpGi9h3l86LxeebZwmxygHISao",
  render_errors: [view: LetsvoteWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Letsvote.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Configures external authentication via ueberauth
config :ueberauth, Ueberauth,
  providers: [
    google: {Ueberauth.Strategy.Google, []}
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
