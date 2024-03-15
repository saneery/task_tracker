defmodule Accounting.Users.User do
  use Ecto.Schema
  use Pow.Ecto.Schema
  use PowAssent.Ecto.Schema

  schema "users" do
    pow_user_fields()
    field :role, Ecto.Enum, values: [:admin, :employee, :manager, :accountant], default: :employee
    field :balance, :float, default: 0.0

    timestamps()
  end

  def changeset(user, attrs) do
    user
    |> Ecto.Changeset.cast(attrs, [:role, :email])
    |> Ecto.Changeset.validate_inclusion(:role, ~w(admin employee manager)a)
  end
end
