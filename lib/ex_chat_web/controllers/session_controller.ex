defmodule ExChatWeb.SessionController do
  use ExChatWeb, :controller

  import ExChatWeb.Auth

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"session" => %{"email" => user, "password" => password}}) do
    case login_with(conn, user, password, repo: ExChat.Repo) do
      {:ok, conn} ->
        logged_user = ExChat.Guardian.Plug.current_resource(conn)
        conn
        |> put_flash(:info, "logged in as #{logged_user.email}")
        |> redirect(to: Routes.chat_path(conn, :index))
      {:error, _reason, conn} ->
        conn
        |> put_flash(:error, "Wrong name/password")
        |> render("new.html")
    end
  end

  def delete(conn, _) do
    conn
    |> ExChat.Guardian.Plug.sign_out()
    |> redirect(to: "/")
  end
end
