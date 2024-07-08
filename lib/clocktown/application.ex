defmodule Clocktown.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ClocktownWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:clocktown, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Clocktown.PubSub},
      # Start a worker by calling: Clocktown.Worker.start_link(arg)
      # {Clocktown.Worker, arg},
      # Start to serve requests, typically the last entry
      {Clocktown.Counter, 0},
      {Clocktown.History, 50},
      ClocktownWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Clocktown.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ClocktownWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
