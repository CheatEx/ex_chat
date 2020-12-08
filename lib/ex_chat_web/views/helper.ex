defmodule ExChatWeb.ViewHelper do
  def current_user(conn), do: ExChat.Guardian.Plug.current_resource(conn)

  def current_token(conn), do: ExChat.Guardian.Plug.current_token(conn)

  def logged_in?(conn), do: ExChat.Guardian.Plug.authenticated?(conn)
end
