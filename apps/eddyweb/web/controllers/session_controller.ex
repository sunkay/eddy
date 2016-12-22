defmodule Eddyweb.SessionController do
  use Eddyweb.Web, :controller
  import Ecto.Changeset

  require Logger

  plug Ueberauth
  plug :require_authenticated when action in [:index, :chgpwd_new, :chgpwd_create]

  def index(conn, _params) do
    users = Auth.Repo.all(Auth.Account)
    render conn, "index.html", users: users
  end

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

  def oAuth_callback(
    %{assigns: %{ueberauth_auth: auth}} = conn,
    %{"provider" => provider})
  do
    email = auth.info.email
    # if Email is nil -> use name field & create a dummy email
    if auth.info.email == nil do
      name = auth.info.name
      email = Enum.join(String.split(name, " ") ++ ["@#{provider}.com"])
      Logger.warn "email was nil, updated to: #{email}"
    end
    user_params = %{provider: provider, email: email, token: auth.credentials.token}
    handle_signin(conn, Auth.oAuth_register(user_params))
  end

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: session_path(conn, :signin_new))
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

  def chgpwd_new(conn, _params) do
    changeset = chgpwd_changeset()
    render conn, "chgpwd.html", changeset: changeset
  end

  def chgpwd_create(conn, %{"chgpwd" => params}) do
    changeset = chgpwd_changeset(params)
    if changeset.valid? do
      %{"old_password" => old, "password" => new} = params
      email = conn.assigns.current_user.email
      handle_chgpwd(conn, Auth.change_password(email, old, new))
    else
      render conn, "chgpwd.html", changeset: %{changeset|action: :insert}
    end
  end

  defp handle_signin(conn, {:ok, account}) do
    conn = Eddyweb.Authentication.signin(conn, account)
    path = get_session(conn, :redirect_url) || page_path(conn, :index)
    conn
      |> put_flash(:info, "Welcome back")
      |> redirect(to: path)
  end

  defp handle_signin(conn, {:error, changeset}) do
    Logger.warn "changeset: #{inspect(changeset)}"
    conn
    |> put_flash(:error, "Invalid login credentials")
    |> redirect(to: session_path(conn, :signin_new))
  end

  defp handle_chgpwd(conn, {:ok, _account}) do
    conn
      |> put_flash(:info, "Successfully changed password")
      |> redirect(to: page_path(conn, :index))
  end

  defp handle_chgpwd(conn, {:error}) do
    conn
      |> put_flash(:info, "invalid credentials")
      |> redirect(to: session_path(conn, :chgpwd_new))
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

    defp chgpwd_changeset(params \\ %{}) do
      data = %{}
      types = %{old_password: :string, password: :string, confirm: :string}

      changeset =
        {data, types}
        |> cast(params, Map.keys(types))
        |> validate_required([:old_password, :password, :confirm])
        |> validate_confirm()

      changeset
    end

    defp validate_confirm(%{changes: %{password: password, confirm: confirm}} = changeset) do
      if password != confirm do
        add_error(changeset, :confirm, "password confirmation failed")
      else
        changeset
      end
    end
    defp validate_confirm(%{changes: %{}} = changeset), do: changeset

end
