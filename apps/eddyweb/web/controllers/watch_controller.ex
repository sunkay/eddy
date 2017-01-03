defmodule Eddyweb.WatchController do
  use Eddyweb.Web, :controller
  require Logger

  alias Vroom.{Video}

  #plug :require_authenticated when action in [:new, :create]

  def show(conn, %{"id" => id}) do
    video = Vroom.Repo.get!(Video, id)
    render conn, "show.html", video: video
  end

end
