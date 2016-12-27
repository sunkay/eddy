defmodule Eddyweb.VideoController do
  use Eddyweb.Web, :controller
  require Logger

  alias Vroom.Video

  plug :require_authenticated when action in [:new, :create]

  def index(conn, _params) do
    videos = Vroom.videos()
    render conn, "index.html", videos: videos
  end

  def new(conn, _params) do
    changeset = Video.changeset(%Video{})
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"video" => params}) do
    params = Map.put(params, "user_id", get_session(conn, :user_id))
    Logger.warn "#{inspect(params)}"
    conn
    |> handle_add_video(Vroom.add_video(params))
  end

  def show(conn, %{"id" => id}) do
    video = Vroom.Repo.get(Video, id)
    render conn, "show.html", video: video
  end

  def delete(conn, %{"id" => id}) do
    video = Vroom.Repo.get(Video, id)
    Vroom.Repo.delete!(video)
    conn
    |> put_flash(:info, "Video successfully deleted")
    |> redirect(to: video_path(conn, :index))
  end

  def edit(conn, %{"id" => id}) do
    video = Vroom.Repo.get!(Video, id)
    changeset = Video.changeset(video)
    render conn, "edit.html", video: video, changeset: changeset
  end

  def update(conn, %{"id" => id, "video" => video_params}) do
     video = Vroom.Repo.get(Video, id)
     changeset = Video.changeset(video, video_params)
     handle_update_video(conn, Vroom.Repo.update(changeset))
  end

  defp handle_add_video(conn, {:ok, _}) do
    conn
    |> put_flash(:info, "Video added successfully")
    |> redirect(to: video_path(conn, :index))
  end
  defp handle_add_video(conn, {:error, changeset}) do
    conn
    |> render("new.html", changeset: changeset)
  end
  defp handle_update_video(conn, {:ok, _}) do
    conn
    |> put_flash(:info, "Video updated successfully")
    |> redirect(to: video_path(conn, :index))
  end

  defp handle_update_video(conn, {:error, changeset}) do
    conn
    |> render("edit.html", changeset: changeset)
  end

end
