defmodule ExChatWeb.ChatController do
  use ExChatWeb, :controller

  def index(conn, _params) do
    user = ExChat.Guardian.Plug.current_resource(conn)
    token = case ExChat.Guardian.encode_and_sign(user) do
      {:ok, token, _claims} -> token
      {:error, _} -> nil
    end
    render(conn, "index.html", token: token)
  end

  def redirect_index(conn, _params) do
    redirect(conn, to: Routes.chat_path(conn, :index))
  end
end
