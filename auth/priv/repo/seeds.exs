# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Auth.Repo.insert!(%Auth.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

attrs = %{email: "admin@admin.com", password: "admin", role: :admin}
%Auth.Accounts.User{}
|> Auth.Accounts.User.registration_changeset(attrs)
|> Auth.Accounts.User.changeset(attrs)
|> Auth.Repo.insert()
