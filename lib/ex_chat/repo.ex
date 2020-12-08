defmodule ExChat.Repo do
  use Ecto.Repo,
    otp_app: :ex_chat,
    adapter: Ecto.Adapters.Postgres
end
