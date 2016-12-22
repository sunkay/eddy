use Mix.Config

config :vroom, Vroom.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "sunil",
  password: "",
  database: "eddyweb_#{Mix.env}",
  hostname: "localhost"
