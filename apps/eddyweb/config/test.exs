use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :eddyweb, Eddyweb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :eddyweb, Eddyweb.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "sunil",
  password: "",
  database: "eddyweb_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
