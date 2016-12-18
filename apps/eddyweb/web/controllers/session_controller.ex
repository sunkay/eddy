defmodule Eddyweb.SessionController do
  use Eddyweb.Web, :controller
  require Logger

  # plug :require_authenticated when action in [:index]

  def new(conn, params) do
    changeset = Auth.Account.build(params)
    render conn, "register.html", changeset: changeset
  end

  def create(conn, params) do
    case Auth.register(params) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "User successfully added")
        |> redirect(to: page_path(conn, :index))
      {:error, changeset} ->
        render(conn, "register.html", changeset: changeset)
    end
  end
end
