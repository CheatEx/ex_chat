defmodule ExChatWeb.ViewHelper do
  def current_user(conn), do: ExChatWeb.Auth.current_user(conn)

  def logged_in?(conn), do: ExChat.Guardian.Plug.authenticated?(conn)
end
