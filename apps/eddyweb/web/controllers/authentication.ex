defmodule Eddyweb.Authentication do
  import Plug.Conn
  import Logger

  def init([]), do: []

  def call(%{assigns: %{current_user: %{}}} = conn, _opts) do
    Logger.warn "already has current_user not set"
    conn
  end

  def call(conn, _opts) do
     id = get_session(conn, :user_id)

     user = if id, do: Auth.find_user(id)

     conn
     |> put_user_token(user)
     |> assign(:current_user, user)
  end

  def require_authenticated(%{assigns: %{current_user: %{}}} = conn, _opts) do
    conn
  end

  def require_authenticated(conn, _opts) do
     conn = conn
     |> put_session(:redirect_url, conn.request_path)
     |> Phoenix.Controller.put_flash(:error, "You must be signed in to access: #{conn.request_path}")
     |> Phoenix.Controller.redirect(to: "/auth/signin")
     |> halt()
  end

  def signin(conn, user) do
     conn
     |> put_session(:user_id, user.id)
     |> put_user_token(user)
     |> assign(:current_user, user)
     |> configure_session(renew: true)
  end

  def signout(conn) do
    conn
    |> configure_session(drop: true)
  end

  defp put_user_token(conn, user) do
    token = Phoenix.Token.sign(conn, "user socket", user.id)

    conn
    |> assign(:user_token, token)
  end
end
