defmodule Vroom.Repo.Migrations.AddVideosTable do
  use Ecto.Migration

  def change do
    create table(:videos) do
      add :name, :string
      add :url, :string
      add :description, :string

      timestamps()
    end
  end
end
