defmodule ExChatWeb.UserSocket do
  alias Guardian.Phoenix.Socket, as: GuardianSocket

  use Phoenix.Socket

  ## Channels
  channel "room:*", ExChatWeb.RoomChannel

  @impl true
  def connect(%{"token" => token}, socket) do
    case GuardianSocket.authenticate(socket, ExChat.Guardian, token) do
      {:ok, authed_socket} -> {:ok, authed_socket}
      {:error, _} -> :error
    end
  end
  @impl true
  def connect(_params, socket) do
    {:ok, socket}
  end

  @impl true
  def id(socket) do
    if GuardianSocket.authenticated?(socket) do
      GuardianSocket.current_resource(socket)
      |> Map.fetch!(:id)
      |> to_string()
    else
      "anonymous"
    end
  end
end
