defmodule ExChatWeb.SessionController do
  use ExChatWeb, :controller

  import ExChatWeb.Auth

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"session" => %{"email" => email, "password" => password}}) do
    case login_with(conn, email, password, repo: ExChat.Repo) do
      {:ok, conn} ->
        logged_user = current_user(conn)
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
    |> logout()
    |> redirect(to: "/")
  end
end
