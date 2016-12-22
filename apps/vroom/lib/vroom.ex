defmodule Vroom do
  alias Vroom.{Repo, Video}

  def add_video(params) do
     Video.changeset(%Video{}, params)
     |> Repo.insert()
  end

  def videos do
    Repo.all(Video)
  end

end
