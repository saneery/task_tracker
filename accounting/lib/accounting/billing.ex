defmodule Accounting.Billing do
  @moduledoc """
  The Billing context.
  """

  import Ecto.Query, warn: false
  alias Accounting.Billing
  alias Accounting.Repo

  alias Accounting.Billing.Transaction
  alias Accounting.UserIdentities.UserIdentity
  alias Accounting.Users.User

  @doc """
  Returns the list of transactions.

  ## Examples

      iex> list_transactions()
      [%Transaction{}, ...]

  """
  def list_transactions do
    Repo.all(Transaction)
  end

  def list_transactions(user_id) do
    Repo.all(from(t in Transaction, where: t.user_id == ^user_id))
  end

  def calculate_transactions(bc_id) do
    query = from t in Transaction,
      where: t.billing_cycle_id == ^bc_id,
      select: sum(t.debit) - sum(t.credit)

    Repo.one(query)
  end

  @doc """
  Gets a single transaction.

  Raises `Ecto.NoResultsError` if the Transaction does not exist.

  ## Examples

      iex> get_transaction!(123)
      %Transaction{}

      iex> get_transaction!(456)
      ** (Ecto.NoResultsError)

  """
  def get_transaction!(id), do: Repo.get!(Transaction, id)

  @doc """
  Creates a transaction.

  ## Examples

      iex> create_transaction(%{field: value})
      {:ok, %Transaction{}}

      iex> create_transaction(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_transaction(attrs \\ %{}) do
    %Transaction{}
    |> Transaction.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a transaction.

  ## Examples

      iex> update_transaction(transaction, %{field: new_value})
      {:ok, %Transaction{}}

      iex> update_transaction(transaction, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_transaction(%Transaction{} = transaction, attrs) do
    transaction
    |> Transaction.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a transaction.

  ## Examples

      iex> delete_transaction(transaction)
      {:ok, %Transaction{}}

      iex> delete_transaction(transaction)
      {:error, %Ecto.Changeset{}}

  """
  def delete_transaction(%Transaction{} = transaction) do
    Repo.delete(transaction)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking transaction changes.

  ## Examples

      iex> change_transaction(transaction)
      %Ecto.Changeset{data: %Transaction{}}

  """
  def change_transaction(%Transaction{} = transaction, attrs \\ %{}) do
    Transaction.changeset(transaction, attrs)
  end

  alias Accounting.Billing.BillingCycle

  @doc """
  Returns the list of billing_cycles.

  ## Examples

      iex> list_billing_cycles()
      [%BillingCycle{}, ...]

  """
  def list_billing_cycles do
    Repo.all(BillingCycle)
  end

  @doc """
  Gets a single billing_cycle.

  Raises `Ecto.NoResultsError` if the Billing cycle does not exist.

  ## Examples

      iex> get_billing_cycle!(123)
      %BillingCycle{}

      iex> get_billing_cycle!(456)
      ** (Ecto.NoResultsError)

  """
  def get_billing_cycle!(id), do: Repo.get!(BillingCycle, id)

  @doc """
  Creates a billing_cycle.

  ## Examples

      iex> create_billing_cycle(%{field: value})
      {:ok, %BillingCycle{}}

      iex> create_billing_cycle(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_billing_cycle(attrs \\ %{}) do
    %BillingCycle{}
    |> BillingCycle.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a billing_cycle.

  ## Examples

      iex> update_billing_cycle(billing_cycle, %{field: new_value})
      {:ok, %BillingCycle{}}

      iex> update_billing_cycle(billing_cycle, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_billing_cycle(%BillingCycle{} = billing_cycle, attrs) do
    billing_cycle
    |> BillingCycle.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a billing_cycle.

  ## Examples

      iex> delete_billing_cycle(billing_cycle)
      {:ok, %BillingCycle{}}

      iex> delete_billing_cycle(billing_cycle)
      {:error, %Ecto.Changeset{}}

  """
  def delete_billing_cycle(%BillingCycle{} = billing_cycle) do
    Repo.delete(billing_cycle)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking billing_cycle changes.

  ## Examples

      iex> change_billing_cycle(billing_cycle)
      %Ecto.Changeset{data: %BillingCycle{}}

  """
  def change_billing_cycle(%BillingCycle{} = billing_cycle, attrs \\ %{}) do
    BillingCycle.changeset(billing_cycle, attrs)
  end

  def get_billing_cycle_for_user(user_id) do
    Repo.get_by(BillingCycle, user_id: user_id)
  end

  def get_user_by_public_id(public_id) do
    query =
      from ui in UserIdentity,
      join: u in User, on: [id: ui.user_id],
      where: ui.uid == ^public_id,
      select: u

    Repo.one(query)
  end

  def close_old_billing_cycles() do
    Repo.update_all(
      from(bc in BillingCycle, where: fragment("?::date < CURRENT_DATE AND ? = 'open'", bc.start_date, bc.status)),
      set: [end_date: NaiveDateTime.utc_now(), status: :closed]
    )
  end

  def old_billing_cycles() do
    Repo.all(
      from(bc in BillingCycle, where: fragment("?::date < CURRENT_DATE AND ? = 'open'", bc.start_date, bc.status))
    )
  end

  def update_user_balance(user, balance) do
    user
    |> User.changeset(%{balance: balance})
    |> Repo.update()
  end
end
