defmodule AccountingWeb.BillingCycleController do
  use AccountingWeb, :controller

  alias Accounting.Billing
  alias Accounting.Billing.BillingCycle

  def index(conn, _params) do
    billing_cycles = Billing.list_billing_cycles()
    render(conn, "index.html", billing_cycles: billing_cycles)
  end

  def new(conn, _params) do
    changeset = Billing.change_billing_cycle(%BillingCycle{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"billing_cycle" => billing_cycle_params}) do
    case Billing.create_billing_cycle(billing_cycle_params) do
      {:ok, billing_cycle} ->
        conn
        |> put_flash(:info, "Billing cycle created successfully.")
        |> redirect(to: Routes.billing_cycle_path(conn, :show, billing_cycle))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    billing_cycle = Billing.get_billing_cycle!(id)
    render(conn, "show.html", billing_cycle: billing_cycle)
  end

  def edit(conn, %{"id" => id}) do
    billing_cycle = Billing.get_billing_cycle!(id)
    changeset = Billing.change_billing_cycle(billing_cycle)
    render(conn, "edit.html", billing_cycle: billing_cycle, changeset: changeset)
  end

  def update(conn, %{"id" => id, "billing_cycle" => billing_cycle_params}) do
    billing_cycle = Billing.get_billing_cycle!(id)

    case Billing.update_billing_cycle(billing_cycle, billing_cycle_params) do
      {:ok, billing_cycle} ->
        conn
        |> put_flash(:info, "Billing cycle updated successfully.")
        |> redirect(to: Routes.billing_cycle_path(conn, :show, billing_cycle))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", billing_cycle: billing_cycle, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    billing_cycle = Billing.get_billing_cycle!(id)
    {:ok, _billing_cycle} = Billing.delete_billing_cycle(billing_cycle)

    conn
    |> put_flash(:info, "Billing cycle deleted successfully.")
    |> redirect(to: Routes.billing_cycle_path(conn, :index))
  end
end
