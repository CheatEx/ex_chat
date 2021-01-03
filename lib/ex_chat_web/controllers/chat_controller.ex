defmodule ExChatWeb.ChatController do
  use ExChatWeb, :controller

  alias ExChat.User
  alias ExChatWeb.Auth

  def index(conn, _params) do
    token =
      with user when not is_nil(user) <- Auth.current_user(conn) do
        Auth.ws_token(user)
      end

    render(conn, "index.html", token: token)
  end

  def redirect_index(conn, _params) do
    redirect(conn, to: Routes.chat_path(conn, :index))
  end
end
