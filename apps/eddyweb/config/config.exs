# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :eddyweb,
  ecto_repos: [Eddyweb.Repo]

# Configures the endpoint
config :eddyweb, Eddyweb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Yk6quqkAgn98MxUBje6kyhnpDwBXFPaeVKciAwV/TIXRnUXPRm/twO6lBSlc1nJD",
  render_errors: [view: Eddyweb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Eddyweb.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :ueberauth, Ueberauth,
  providers: [
    github: { Ueberauth.Strategy.Github, [] },
    facebook: {Ueberauth.Strategy.Facebook, [default_scope: "email,public_profile"]},
    google: {Ueberauth.Strategy.Google, []}
  ]

  config :ueberauth, Ueberauth.Strategy.Google.OAuth,
    client_id: System.get_env("GOOGLE_CLIENT_ID"),
    client_secret: System.get_env("GOOGLE_CLIENT_SECRET")

  config :ueberauth, Ueberauth.Strategy.Facebook.OAuth,
    client_id: System.get_env("FACEBOOK_CLIENT_ID"),
    client_secret: System.get_env("FACEBOOK_CLIENT_SECRET")

  config :ueberauth, Ueberauth.Strategy.Github.OAuth,
    client_id: System.get_env("GITHUB_CLIENT_ID"),
    client_secret: System.get_env("GITHUB_CLIENT_SECRET")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
