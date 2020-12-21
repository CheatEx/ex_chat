defmodule ExChatWeb.Auth do
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

  def logout(conn), do: ExChat.Guardian.Plug.sign_out(conn)

  def current_user(conn), do: ExChat.Guardian.Plug.current_resource(conn)

  def ws_token(user) do
    case ExChat.Guardian.encode_and_sign(user) do
      {:ok, token, _claims} -> token
      {:error, _} -> nil
    end
  end

  defp login(conn, user) do
    ExChat.Guardian.Plug.sign_in(conn, user)
  end

end
