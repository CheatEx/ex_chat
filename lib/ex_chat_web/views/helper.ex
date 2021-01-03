defmodule ExChatWeb.ViewHelper do
  alias ExChatWeb.Auth

  def current_user(conn), do: Auth.current_user(conn)

  def logged_in?(conn), do: ExChat.Guardian.Plug.authenticated?(conn)
end
