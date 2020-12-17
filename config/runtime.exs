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

  port = System.get_env("PORT") ||
    raise """
    environment variable PORT is missing.
    """

  http_host = System.get_env("HTTP_HOST") ||
    raise """
    environment variable HTTP_HOST is missing.
    """

  http_port = System.get_env("HTTP_PORT")

  http_scheme = System.get_env("HTTP_SCHEME") ||
    raise """
    environment variable HTTP_SCHEME is missing.
    """

  config :ex_chat, ExChat.Repo,
    url: database_url

  config :ex_chat, ExChatWeb.Endpoint,
    http: [
      port: port,
      transport_options: [socket_opts: [:inet6]]
    ],
    url: [scheme: http_scheme, host: http_host, port: http_port],
    secret_key_base: secret_key_base

  config :ex_chat, ExChat.Guardian,
    secret_key: jwt_secret_key

end
