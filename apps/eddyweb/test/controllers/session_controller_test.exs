defmodule Eddyweb.SessionControllerTest do
  use Eddyweb.ConnCase
  #import Logger

  @valid_attrs %{email: "x@y.com", password: "121212"}
  @invalid_attrs %{email: "x@y.com", password: ""}

  setup do
     # Explicitly get a connection before each test
     Ecto.Adapters.SQL.Sandbox.checkout(Eddyweb.Repo)
     Ecto.Adapters.SQL.Sandbox.checkout(Auth.Repo)
   end

  test "/register new", %{conn: conn} do
    conn = get conn, session_path(conn, :new)

    assert html_response(conn, 200) =~ "Registration"
  end

  test "/register create :success", %{conn: conn} do
    conn = post conn, session_path(conn, :create), register: @valid_attrs
    assert redirected_to(conn) == page_path(conn, :index)

    account = Auth.Repo.get_by(Auth.Account, email: "x@y.com")
    assert account
  end

  test "/register create :failure", %{conn: conn} do
    conn = post conn, session_path(conn, :create), register: @invalid_attrs
    assert html_response(conn, 200) =~ "<h2>Registration</h2>"
  end

  test "/signin new", %{conn: conn} do
    conn = get conn, session_path(conn, :signin_new)
    assert html_response(conn, 200) =~ "<h2>Login</h2>"
  end

  test "/signin create :success", %{conn: conn} do
    {:ok, _account} = Auth.register(@valid_attrs)

    conn = post conn, session_path(conn, :signin_create), signin: @valid_attrs
    assert redirected_to(conn) == page_path(conn, :index)
  end

  test "/signin create :failure", %{conn: conn} do
    {:ok, _account} = Auth.register(@valid_attrs)

    conn = post conn, session_path(conn, :signin_create), signin: @invalid_attrs
    assert html_response(conn, 200) =~ "<h2>Login</h2>"
  end


end
