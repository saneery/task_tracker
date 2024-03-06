defmodule AccountingWeb.BillingCycleControllerTest do
  use AccountingWeb.ConnCase

  import Accounting.BillingFixtures

  @create_attrs %{user_id: 42, end_date: ~N[2024-03-04 21:04:00], start_date: ~N[2024-03-04 21:04:00], status: "some status"}
  @update_attrs %{user_id: 43, end_date: ~N[2024-03-05 21:04:00], start_date: ~N[2024-03-05 21:04:00], status: "some updated status"}
  @invalid_attrs %{user_id: nil, end_date: nil, start_date: nil, status: nil}

  describe "index" do
    test "lists all billing_cycles", %{conn: conn} do
      conn = get(conn, Routes.billing_cycle_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Billing cycles"
    end
  end

  describe "new billing_cycle" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.billing_cycle_path(conn, :new))
      assert html_response(conn, 200) =~ "New Billing cycle"
    end
  end

  describe "create billing_cycle" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.billing_cycle_path(conn, :create), billing_cycle: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.billing_cycle_path(conn, :show, id)

      conn = get(conn, Routes.billing_cycle_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Billing cycle"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.billing_cycle_path(conn, :create), billing_cycle: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Billing cycle"
    end
  end

  describe "edit billing_cycle" do
    setup [:create_billing_cycle]

    test "renders form for editing chosen billing_cycle", %{conn: conn, billing_cycle: billing_cycle} do
      conn = get(conn, Routes.billing_cycle_path(conn, :edit, billing_cycle))
      assert html_response(conn, 200) =~ "Edit Billing cycle"
    end
  end

  describe "update billing_cycle" do
    setup [:create_billing_cycle]

    test "redirects when data is valid", %{conn: conn, billing_cycle: billing_cycle} do
      conn = put(conn, Routes.billing_cycle_path(conn, :update, billing_cycle), billing_cycle: @update_attrs)
      assert redirected_to(conn) == Routes.billing_cycle_path(conn, :show, billing_cycle)

      conn = get(conn, Routes.billing_cycle_path(conn, :show, billing_cycle))
      assert html_response(conn, 200) =~ "some updated status"
    end

    test "renders errors when data is invalid", %{conn: conn, billing_cycle: billing_cycle} do
      conn = put(conn, Routes.billing_cycle_path(conn, :update, billing_cycle), billing_cycle: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Billing cycle"
    end
  end

  describe "delete billing_cycle" do
    setup [:create_billing_cycle]

    test "deletes chosen billing_cycle", %{conn: conn, billing_cycle: billing_cycle} do
      conn = delete(conn, Routes.billing_cycle_path(conn, :delete, billing_cycle))
      assert redirected_to(conn) == Routes.billing_cycle_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.billing_cycle_path(conn, :show, billing_cycle))
      end
    end
  end

  defp create_billing_cycle(_) do
    billing_cycle = billing_cycle_fixture()
    %{billing_cycle: billing_cycle}
  end
end
