import Config

if (config_env() != :dev) do
  database_url = System.get_env("DATABASE_URL") ||
    raise """
    environment variable DATABASE_URL is missing.
    For example: ecto://USER:PASS@HOST/DATABASE
    """

  secret_key_base = System.get_env("SECRET_KEY_BASE") ||
    raise """
    environment variable SECRET_KEY_BASE is missing.
    You can generate one by calling: mix phx.gen.secret
    """

  jwt_secret_key = System.get_env("JWT_SECRET_KEY") ||
    raise """
    environment variable JWT_SECRET_KEY is missing.
    You can generate one by calling: mix guardian.gen.secret
    """

  server_port = System.get_env("SERVER_PORT") ||
    raise """
    environment variable SERVER_PORT is missing.
    """

  http_host = System.get_env("HTTP_HOST") ||
    raise """
    environment variable HTTP_HOST is missing.
    """

  http_port = System.get_env("HTTP_PORT") ||
    raise """
    environment variable HTTP_PORT is missing.
    """

  config :ex_chat, ExChat.Repo,
    url: database_url

  config :ex_chat, ExChatWeb.Endpoint,
    http: [
      port: server_port,
      transport_options: [socket_opts: [:inet6]]
    ],
    url: [host: http_host, port: http_port],
    secret_key_base: secret_key_base

  config :ex_chat, ExChat.Guardian,
    secret_key: jwt_secret_key

end
