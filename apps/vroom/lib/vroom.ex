defmodule Vroom do
  alias Vroom.{Repo, Video}
  import Ecto.Query

  def add_video(params) do
     Video.changeset(%Video{}, params)
     |> Repo.insert()
  end

  def videos() do
    Repo.all(Video)
  end

  def videos(user_id) do
    case user_id do
      nil ->
        []
      _ ->
        query = from v in Video,
          where: v.user_id == ^user_id
        Repo.all(query)
    end
  end
  
end
