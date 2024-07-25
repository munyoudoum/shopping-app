defmodule Shopping.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ShoppingWeb.Telemetry,
      Shopping.Repo,
      {DNSCluster, query: Application.get_env(:shopping, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Shopping.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Shopping.Finch},
      # Start a worker by calling: Shopping.Worker.start_link(arg)
      # {Shopping.Worker, arg},
      # Start to serve requests, typically the last entry
      ShoppingWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Shopping.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ShoppingWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
