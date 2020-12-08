defmodule ExChatWeb.AuthController do
  use ExChatWeb, :controller

  @behaviour Guardian.Plug.ErrorHandler

  @impl Guardian.Plug.ErrorHandler
  def auth_error(conn, {type, reason}, opts) do
    conn
    |> put_flash(:error, "#{to_string(type)}: #{to_string(reason)}")
    |> redirect(to: Routes.session_path(conn, :new))
  end
end
