defmodule Vroom.Repo.Migrations.AddVideosTable do
  use Ecto.Migration

  def change do
    create table(:videos) do
      add :name, :string
      add :url, :string
      add :description, :string
      add :user_id, :id

      timestamps()
    end

    create unique_index(:videos, [:name])
  end
end
