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
     |> assign(:current_user, user)
  end

  def require_authenticated(%{assigns: %{current_user: %{}}} = conn, _opts) do
    conn
  end

  def require_authenticated(conn, _opts) do
     conn
     |> Phoenix.Controller.put_flash(:alert, "You must be signed in to access that page")
     |> Phoenix.Controller.redirect(to: "/sign_in")
     |> halt()
  end

end
