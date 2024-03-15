defmodule Accounting.BillingTest do
  use Accounting.DataCase

  alias Accounting.Billing

  describe "transactions" do
    alias Accounting.Billing.Transaction

    import Accounting.BillingFixtures

    @invalid_attrs %{billing_cycle_id: nil, credit: nil, debit: nil, description: nil, task_id: nil, type: nil, user_id: nil}

    test "list_transactions/0 returns all transactions" do
      transaction = transaction_fixture()
      assert Billing.list_transactions() == [transaction]
    end

    test "get_transaction!/1 returns the transaction with given id" do
      transaction = transaction_fixture()
      assert Billing.get_transaction!(transaction.id) == transaction
    end

    test "create_transaction/1 with valid data creates a transaction" do
      valid_attrs = %{billing_cycle_id: 42, credit: 120.5, debit: 120.5, description: "some description", task_id: 42, type: "some type", user_id: 42}

      assert {:ok, %Transaction{} = transaction} = Billing.create_transaction(valid_attrs)
      assert transaction.billing_cycle_id == 42
      assert transaction.credit == 120.5
      assert transaction.debit == 120.5
      assert transaction.description == "some description"
      assert transaction.task_id == 42
      assert transaction.type == "some type"
      assert transaction.user_id == 42
    end

    test "create_transaction/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Billing.create_transaction(@invalid_attrs)
    end

    test "update_transaction/2 with valid data updates the transaction" do
      transaction = transaction_fixture()
      update_attrs = %{billing_cycle_id: 43, credit: 456.7, debit: 456.7, description: "some updated description", task_id: 43, type: "some updated type", user_id: 43}

      assert {:ok, %Transaction{} = transaction} = Billing.update_transaction(transaction, update_attrs)
      assert transaction.billing_cycle_id == 43
      assert transaction.credit == 456.7
      assert transaction.debit == 456.7
      assert transaction.description == "some updated description"
      assert transaction.task_id == 43
      assert transaction.type == "some updated type"
      assert transaction.user_id == 43
    end

    test "update_transaction/2 with invalid data returns error changeset" do
      transaction = transaction_fixture()
      assert {:error, %Ecto.Changeset{}} = Billing.update_transaction(transaction, @invalid_attrs)
      assert transaction == Billing.get_transaction!(transaction.id)
    end

    test "delete_transaction/1 deletes the transaction" do
      transaction = transaction_fixture()
      assert {:ok, %Transaction{}} = Billing.delete_transaction(transaction)
      assert_raise Ecto.NoResultsError, fn -> Billing.get_transaction!(transaction.id) end
    end

    test "change_transaction/1 returns a transaction changeset" do
      transaction = transaction_fixture()
      assert %Ecto.Changeset{} = Billing.change_transaction(transaction)
    end
  end

  describe "billing_cycles" do
    alias Accounting.Billing.BillingCycle

    import Accounting.BillingFixtures

    @invalid_attrs %{user_id: nil, end_date: nil, start_date: nil, status: nil}

    test "list_billing_cycles/0 returns all billing_cycles" do
      billing_cycle = billing_cycle_fixture()
      assert Billing.list_billing_cycles() == [billing_cycle]
    end

    test "get_billing_cycle!/1 returns the billing_cycle with given id" do
      billing_cycle = billing_cycle_fixture()
      assert Billing.get_billing_cycle!(billing_cycle.id) == billing_cycle
    end

    test "create_billing_cycle/1 with valid data creates a billing_cycle" do
      valid_attrs = %{user_id: 42, end_date: ~N[2024-03-04 21:04:00], start_date: ~N[2024-03-04 21:04:00], status: "some status"}

      assert {:ok, %BillingCycle{} = billing_cycle} = Billing.create_billing_cycle(valid_attrs)
      assert billing_cycle.user_id == 42
      assert billing_cycle.end_date == ~N[2024-03-04 21:04:00]
      assert billing_cycle.start_date == ~N[2024-03-04 21:04:00]
      assert billing_cycle.status == "some status"
    end

    test "create_billing_cycle/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Billing.create_billing_cycle(@invalid_attrs)
    end

    test "update_billing_cycle/2 with valid data updates the billing_cycle" do
      billing_cycle = billing_cycle_fixture()
      update_attrs = %{user_id: 43, end_date: ~N[2024-03-05 21:04:00], start_date: ~N[2024-03-05 21:04:00], status: "some updated status"}

      assert {:ok, %BillingCycle{} = billing_cycle} = Billing.update_billing_cycle(billing_cycle, update_attrs)
      assert billing_cycle.user_id == 43
      assert billing_cycle.end_date == ~N[2024-03-05 21:04:00]
      assert billing_cycle.start_date == ~N[2024-03-05 21:04:00]
      assert billing_cycle.status == "some updated status"
    end

    test "update_billing_cycle/2 with invalid data returns error changeset" do
      billing_cycle = billing_cycle_fixture()
      assert {:error, %Ecto.Changeset{}} = Billing.update_billing_cycle(billing_cycle, @invalid_attrs)
      assert billing_cycle == Billing.get_billing_cycle!(billing_cycle.id)
    end

    test "delete_billing_cycle/1 deletes the billing_cycle" do
      billing_cycle = billing_cycle_fixture()
      assert {:ok, %BillingCycle{}} = Billing.delete_billing_cycle(billing_cycle)
      assert_raise Ecto.NoResultsError, fn -> Billing.get_billing_cycle!(billing_cycle.id) end
    end

    test "change_billing_cycle/1 returns a billing_cycle changeset" do
      billing_cycle = billing_cycle_fixture()
      assert %Ecto.Changeset{} = Billing.change_billing_cycle(billing_cycle)
    end
  end
end
