defmodule Eddyweb.WatchView do
  use Eddyweb.Web, :view

  def player_id(video) do
    IO.inspect video.url
    ~r{^.*(?:youtu\.be/|\w+/|v=)(?<id>[^#&?]*)}
    |> Regex.named_captures(video.url)
    |> get_in(["id"])
    |> IO.inspect
  end
end
