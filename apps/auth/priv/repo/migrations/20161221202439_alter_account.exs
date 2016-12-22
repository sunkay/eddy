defmodule Auth.Repo.Migrations.AlterAccount do
  use Ecto.Migration

  def change do
    alter table(:auth_accounts) do
      add :provider, :string
      add :token, :string
    end
  end
  
end
