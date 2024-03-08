defmodule AccountingWeb.PageController do
  use AccountingWeb, :controller

  import Ecto.Query, warn: false
  alias Accounting.Repo
  alias Accounting.Billing
  alias Accounting.Billing.{Transaction, BillingCycle}
  alias Accounting.Users.User

  @query """
  SELECT start_date::date as sdate, sum(t.debit) as debit, sum(t.credit) as credit
  FROM "billing_cycles" as bc
  join transactions as t on t.billing_cycle_id = bc.id where t.type != 'payment'
  group by start_date::date
  order by sdate DESC
  """

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def company_dashboard(conn, _) do
    query = from b in fragment(@query), select: {b.sdate, b.debit, b.credit}
    stats = Repo.all(query)
    render(conn, "company_dashboard.html", stats: stats)
  end

  def analytics(conn, params) do
    today_earned = today_earned()
    negative_balance_count = Repo.one(from u in User, where: u.balance < 0.0, select: count(u))
    most_expensive_tasks = most_expensive_tasks(params["datetime_range"])

    render(conn, "analytics.html", today_earned: today_earned, negative_balance_count: negative_balance_count, most_expensive_tasks: most_expensive_tasks)
  end

  def today_earned() do
    query = from b in fragment(@query), select: {b.sdate, b.debit, b.credit}, where: fragment("? = CURRENT_DATE", b.sdate)

    case Repo.one(query) do
      nil -> 0
      {_, debit, credit} -> credit - debit
    end
  end

  def most_expensive_tasks(%{"start_date" => start_date, "end_date" => end_date}) do
    {:ok, start_date} = Ecto.Type.cast(:date, start_date)
    {:ok, end_date} = Ecto.Type.cast(:date, end_date)
    Repo.one(from t in Transaction, where: fragment("?::date >= ? AND ?::date <= ?", t.inserted_at, ^start_date, t.inserted_at, ^end_date), select: max(t.debit))
  end

  def most_expensive_tasks(_) do
    Repo.one(from t in Transaction, where: fragment("?::date = CURRENT_DATE", t.inserted_at), select: max(t.debit))
  end
end
