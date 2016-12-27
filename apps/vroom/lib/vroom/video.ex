defmodule Vroom.Video do
  use Ecto.Schema
  import Ecto.Changeset

  schema "videos" do
    field :name, :string
    field :url, :string
    field :description, :string
    field :user_id, :id

    timestamps()
  end

  def changeset(video, params \\ %{}) do
    cast(video, params, ~w(name url description user_id))
    |> validate_required([:name, :url])
  end

end
