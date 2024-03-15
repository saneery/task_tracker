defmodule Accounting.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Accounting.Repo,
      # Start the Telemetry supervisor
      AccountingWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Accounting.PubSub},
      # Start the Endpoint (http/https)
      AccountingWeb.Endpoint,
      # Start a worker by calling: Accounting.Worker.start_link(arg)
      # {Accounting.Worker, arg}
      Accounting.BillingCycleCron,
      %{
        id: Kaffe.GroupMemberSupervisor,
        start: {Kaffe.GroupMemberSupervisor, :start_link, []},
        type: :supervisor
      }
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Accounting.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    AccountingWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
