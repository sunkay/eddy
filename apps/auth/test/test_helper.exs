ExUnit.start()

Ecto.Adapters.SQL.Sandbox.checkout(Auth.Repo)

Ecto.Adapters.SQL.Sandbox.mode(Auth.Repo, :manual)
