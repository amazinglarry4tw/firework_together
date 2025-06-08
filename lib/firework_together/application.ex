defmodule FireworkTogether.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      FireworkTogetherWeb.Telemetry,
      FireworkTogether.Repo,
      {DNSCluster, query: Application.get_env(:firework_together, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: FireworkTogether.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: FireworkTogether.Finch},
      # Start the firework manager
      FireworkTogether.FireworkManager,
      # Start to serve requests, typically the last entry
      FireworkTogetherWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: FireworkTogether.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    FireworkTogetherWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
