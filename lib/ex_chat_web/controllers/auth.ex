defmodule ExChatWeb.Auth do
  import Plug.Conn

  def login_with(conn, email, pass, opts) do
    repo = Keyword.fetch!(opts, :repo)
    user = repo.get_by(ExChat.User, email: email)

    cond do
      user && Argon2.verify_pass(pass, user.encrypt_pass) ->
        {:ok, login(conn, user)}
      user ->
        {:error, :unauthorized, conn}
      true ->
        Argon2.no_user_verify()
        {:error, :not_found, conn}
    end
  end

  defp login(conn, user) do
    ExChat.Guardian.Plug.sign_in(conn, user)
  end

end
