defmodule ExChatWeb.RoomChannel do
  alias Guardian.Phoenix.Socket, as: GuardianSocket

  alias ExChat.Message
  alias ExChat.Repo
  alias ExChatWeb.Presence

  use ExChatWeb, :channel

  def join("room:lobby", _payload, socket) do
    if GuardianSocket.authenticated?(socket) do
      send(self(), :after_join)
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_info(:after_join, socket) do
    user = GuardianSocket.current_resource(socket)
    Presence.track(socket, user.email,
      %{online_at: :os.system_time(:milli_seconds)})
    Repo.all(Message, limit: 20)
    |> Enum.each(fn msg -> push(socket, "message:new",
    %{
      user: msg.name,
      body: msg.message,
      timestamp: msg.updated_at
    }) end)
    push socket, "presence_state", Presence.list(socket)
    {:noreply, socket}
  end

  def handle_in("message:new", message, socket) do
    %Message{}
    |> Message.changeset(%{name: user_email(socket), message: message})
    |> Repo.insert()

    broadcast!(socket, "message:new", %{
      user: user_email(socket),
      body: message,
      timestamp: :os.system_time(:milli_seconds)
    })
    {:noreply, socket}
  end

  defp user_email(socket) do
     GuardianSocket.current_resource(socket).email
  end

end
