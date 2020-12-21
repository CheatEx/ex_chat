defmodule ExChatWeb.AuthController do
  use ExChatWeb, :controller

  @behaviour Guardian.Plug.ErrorHandler

  @impl Guardian.Plug.ErrorHandler
  def auth_error(conn, {type, reason}, _opts) do
    message = case {type, reason} do
      {:no_resource_found, :no_resource_found} -> "Not logged in"
      {type, reason} -> "#{to_string(type)}: #{to_string(reason)}"
    end
    conn
    |> put_flash(:error, message)
    |> redirect(to: Routes.session_path(conn, :new))
  end
end
