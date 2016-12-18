defmodule Eddyweb.SessionControllerTest do
  use Eddyweb.ConnCase

  @valid_attrs %{email: "x@y.com", password: "121212"}
  @invalid_attrs %{email: "x@y.com", password: ""}

  setup do
     # Explicitly get a connection before each test
     Ecto.Adapters.SQL.Sandbox.checkout(Eddyweb.Repo)
     Ecto.Adapters.SQL.Sandbox.checkout(Auth.Repo)
   end

  test "/register new", %{conn: conn} do
    conn = get conn, "/register"
    assert html_response(conn, 200) =~ "Registration"
  end

  test "/register create :success", %{conn: conn} do
    conn = post conn, "/register", @valid_attrs
    assert redirected_to(conn) == page_path(conn, :index)
  end

  test "/register create :failure", %{conn: conn} do
    conn = post conn, "/register", @invalid_attrs
    assert html_response(conn, 200) =~ "Registration"
  end

end
