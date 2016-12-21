defmodule Auth do
  @moduledoc ~S"""
  Authentication system for the platform.
  See `register/1` for creating an account and `sign_in/2` for signing in.
  """

  alias Auth.{Account, Repo}

  def register(params) do
    Account.build(params)
    |> Repo.insert()
  end

  def sign_in(email, password) do
    account = Repo.get_by(Account, email: email)
    do_sign_in(account, password)
  end

  def change_password(email, old, new) do
    account = Repo.get_by(Account, email: email)
    password_hash = account.password_hash
    if Comeonin.Bcrypt.checkpw(old, password_hash) do
      new_hash = Comeonin.Bcrypt.hashpwsalt(new)
      Repo.update_all(Account, set: [password_hash: new_hash])
      {:ok, account}
    else
      {:error}
    end
  end

  def find_user(id) do
    Repo.get(Account, id)
  end

  defp do_sign_in(%Account{password_hash: password_hash} = account, password) do
    if Comeonin.Bcrypt.checkpw(password, password_hash) do
      {:ok, account}
    else
      {:error, :unauthorized}
    end
  end
  defp do_sign_in(nil, _) do
    Comeonin.Bcrypt.dummy_checkpw()
    {:error, :not_found}
  end
end
