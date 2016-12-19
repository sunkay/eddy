defmodule Eddyweb.SessionController do
  use Eddyweb.Web, :controller
  import Ecto.Changeset

  require Logger

  # plug :require_authenticated when action in [:index]

  def new(conn, params) do
    changeset = Auth.Account.build(params)
    render conn, "register.html", changeset: changeset
  end

  def create(conn, %{"register" => params}) do
    #Logger.warn "register_create: email: #{inspect(params)}"
    case Auth.register(params) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "User successfully added")
        |> redirect(to: page_path(conn, :index))
      {:error, changeset} ->
        render(conn, "register.html", changeset: changeset)
    end
  end

  def signin_new(conn, _params) do
    changeset = signin_changeset()
    render conn, "signin.html", changeset: changeset
  end

  def signin_create(conn, %{"signin" => params}) do
    changeset = signin_changeset(params)
    if changeset.valid? do
      %{"email" => email, "password" => password} = params
      handle_signin(conn, Auth.sign_in(email, password))
    else
      render conn, "signin.html", changeset: %{changeset|action: :insert}
    end
  end

  def signout(conn, _params) do
    conn = Eddyweb.Authentication.signout(conn)
    redirect(conn, to: page_path(conn, :index))
  end

  defp handle_signin(conn, {:ok, account}) do
    conn = Eddyweb.Authentication.signin(conn, account)
    conn
      |> put_flash(:info, "Welcome back")
      |> redirect(to: page_path(conn, :index))
  end

  defp handle_signin(conn, {:error, _}) do
    conn
    |> put_flash(:error, "Invalid login credentials")
    |> redirect(to: session_path(conn, :signin_new))
  end

  defp signin_changeset(params \\ %{}) do
    data = %{}
    types = %{email: :string, password: :string}

    changeset =
      {data, types}
      |> cast(params, Map.keys(types))
      |> validate_required([:email, :password])
      |> validate_format(:email, ~r/.*@.*/)

    changeset
    end

end
