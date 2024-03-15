defmodule AccountingWeb.TransactionController do
  use AccountingWeb, :controller

  alias Accounting.Billing
  alias Accounting.Billing.Transaction
  alias Accounting.Users.User

  def index(conn, _params) do
    transactions = Billing.list_transactions()
    render(conn, "index.html", transactions: transactions)
  end

  def balance(conn, _) do
    if conn.assigns[:current_user] do
      transactions = Billing.list_transactions(conn.assigns[:current_user].id)
      current_balance = Accounting.Repo.get(User, conn.assigns[:current_user].id).balance
      render(conn, "balance.html", transactions: transactions, current_balance: current_balance)
    else
      conn
      |> put_flash(:error, "Надо авторизоваться")
      |> redirect(to: Routes.page_path(conn, :index))
    end
  end

  def new(conn, _params) do
    changeset = Billing.change_transaction(%Transaction{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"transaction" => transaction_params}) do
    case Billing.create_transaction(transaction_params) do
      {:ok, transaction} ->
        conn
        |> put_flash(:info, "Transaction created successfully.")
        |> redirect(to: Routes.transaction_path(conn, :show, transaction))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    transaction = Billing.get_transaction!(id)
    render(conn, "show.html", transaction: transaction)
  end

  def edit(conn, %{"id" => id}) do
    transaction = Billing.get_transaction!(id)
    changeset = Billing.change_transaction(transaction)
    render(conn, "edit.html", transaction: transaction, changeset: changeset)
  end

  def update(conn, %{"id" => id, "transaction" => transaction_params}) do
    transaction = Billing.get_transaction!(id)

    case Billing.update_transaction(transaction, transaction_params) do
      {:ok, transaction} ->
        conn
        |> put_flash(:info, "Transaction updated successfully.")
        |> redirect(to: Routes.transaction_path(conn, :show, transaction))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", transaction: transaction, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    transaction = Billing.get_transaction!(id)
    {:ok, _transaction} = Billing.delete_transaction(transaction)

    conn
    |> put_flash(:info, "Transaction deleted successfully.")
    |> redirect(to: Routes.transaction_path(conn, :index))
  end

  defp nil_to_zero(nil), do: 0
  defp nil_to_zero(num), do: num
end
