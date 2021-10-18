defmodule ExChatWeb.TestChannel do
  use ExChatWeb, :channel

  def join("area:lobby", _payload, socket) do
    {:ok, socket}
  end
end
