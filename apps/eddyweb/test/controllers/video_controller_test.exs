defmodule Eddyweb.VideoControllerTest do
  use Eddyweb.ConnCase
  #import Logger

  @valid_attrs %{name: "TEST", url: "http://test.com", description: "test description"}
  @invalid_attrs %{name: "", url: "", description: "test description"}

  setup do
     # Explicitly get a connection before each test
     Ecto.Adapters.SQL.Sandbox.checkout(Eddyweb.Repo)
     Ecto.Adapters.SQL.Sandbox.checkout(Vroom.Repo)
   end

  test "/video new", %{conn: conn} do
    conn = get conn, video_path(conn, :new)

    assert html_response(conn, 200) =~ "New Video"
  end

  test "/video create :success", %{conn: conn} do
    conn = post conn, video_path(conn, :create), video: @valid_attrs
    assert redirected_to(conn) == video_path(conn, :index)

    #video = Vroom.Repo.get_by(Vroom.Video, name: "TEST")
    #assert video
  end

  test "/video create :failure", %{conn: conn} do
    conn = post conn, video_path(conn, :create), video: @invalid_attrs
    assert html_response(conn, 200) =~ "<h2>New Video</h2>"
  end

  test "/video edit", %{conn: conn} do
    {:ok, video} = Vroom.add_video(@valid_attrs)
    conn = get conn, video_path(conn, :edit, video)

    assert html_response(conn, 200) =~ "<h2>Edit Video</h2>"
  end

  test "/video update :success", %{conn: conn} do
    {:ok, video} = Vroom.add_video(@valid_attrs)

    conn = put conn, video_path(conn, :update, video), video: @valid_attrs
    assert redirected_to(conn) == video_path(conn, :index)
  end

end
