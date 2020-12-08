defmodule ExChat.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      ExChat.Repo,
      # Start the Telemetry supervisor
      ExChatWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: ExChat.PubSub},
      # Start the Endpoint (http/https)
      ExChatWeb.Endpoint,
      # Start a worker by calling: ExChat.Worker.start_link(arg)
      # {ExChat.Worker, arg}
      ExChatWeb.Presence
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ExChat.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    ExChatWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
