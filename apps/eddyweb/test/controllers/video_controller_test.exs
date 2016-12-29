defmodule Eddyweb.VideoControllerTest do
  use Eddyweb.ConnCase
  #import Logger

  @valid_user_attrs %{email: "x@y.com", password: "121212", confirm: "121212"}
  @valid_attrs %{name: "TEST", url: "http://test.com", description: "test description"}
  @invalid_attrs %{name: "", url: "", description: "test description"}

  setup config do
     # Explicitly get a connection before each test
     Ecto.Adapters.SQL.Sandbox.checkout(Eddyweb.Repo)
     Ecto.Adapters.SQL.Sandbox.checkout(Vroom.Repo)
     Ecto.Adapters.SQL.Sandbox.checkout(Auth.Repo)

     if config[:logged_in] do
       {:ok, user} = Auth.register(@valid_user_attrs)
       conn = build_conn()
       conn = post conn, session_path(conn, :signin_create), signin: @valid_user_attrs
       assert get_session(conn, :user_id) == user.id
       {:ok, conn: conn, user: user}
      else
        :ok
     end
   end

  @tag :logged_in
  test "/video new", %{conn: conn} do
    conn = get conn, video_path(conn, :new)

    assert html_response(conn, 200) =~ "New Video"
  end

  @tag :logged_in
  test "/video create :success", %{conn: conn} do
    conn = post conn, video_path(conn, :create), video: @valid_attrs
    assert redirected_to(conn) == video_path(conn, :index)

    #video = Vroom.Repo.get_by(Vroom.Video, name: "TEST")
    #assert video
  end

  @tag :logged_in
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

  test "/video unauthenticated access", %{conn: conn} do
    Enum.each([
      get(conn, video_path(conn, :new)),
      post(conn, video_path(conn, :create), video: @valid_attrs),
      ], fn conn ->
        assert conn.status == 302
        assert conn.halted
        assert redirected_to(conn) == session_path(conn, :signin_new)
      end)
  end
end
