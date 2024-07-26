defmodule TaskApp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      TaskAppWeb.Telemetry,
      TaskApp.Repo,
      {DNSCluster, query: Application.get_env(:task_app, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: TaskApp.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: TaskApp.Finch},
      # Start a worker by calling: TaskApp.Worker.start_link(arg)
      # {TaskApp.Worker, arg},
      # Start to serve requests, typically the last entry
      TaskAppWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TaskApp.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TaskAppWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
