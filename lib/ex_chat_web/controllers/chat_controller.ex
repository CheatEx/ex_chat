defmodule ExChatWeb.ChatController do
  use ExChatWeb, :controller

  def index(conn, _params) do
    token = conn
    |> ExChatWeb.Auth.current_user()
    |> ExChatWeb.Auth.ws_token()
    render(conn, "index.html", token: token)
  end

  def redirect_index(conn, _params) do
    redirect(conn, to: Routes.chat_path(conn, :index))
  end
end
