use Mix.Config

## Repo
config :vroom, Vroom.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "sunil",
  password: "",
  database: "eddyweb_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

## Comeonin
config :comeonin, :bcrypt_log_rounds, 4
