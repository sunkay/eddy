defmodule Auth.Account do
  use Ecto.Schema
  import Ecto.Changeset

  schema "auth_accounts" do
    field :email, :string
    field :password_hash, :string
    field :password, :string, virtual: true
    field :confirm, :string, virtual: true

    timestamps()
  end

  def build(params) do
    changeset(%Auth.Account{}, params)
  end

  def changeset(account, params \\ %{}) do
    cast(account, params, ~w(email password confirm))
    |> validate_required([:email, :password, :confirm])
    |> validate_format(:email, ~r/.*@.*/)
    |> validate_length(:password, min: 6)
    |> validate_confirm_password()
    |> unique_constraint(:email)
    |> put_password_hash()
  end

  defp put_password_hash(%{changes: %{password: password}} = changeset) do
    put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(password))
  end
  defp put_password_hash(%{changes: %{}} = changeset), do: changeset

  defp validate_confirm_password(%{changes: %{password: password, confirm: confirm}} = changeset) do
    if password != confirm do
      add_error(changeset, :confirm, "password confirmation failed")
    else
      changeset
    end
  end
  defp validate_confirm_password(%{changes: %{}} = changeset), do: changeset

end
