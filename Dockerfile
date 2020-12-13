FROM elixir:1.9.0-alpine AS build

# install build dependencies
RUN apk add --no-cache build-base npm git python

# prepare build dir
WORKDIR /app

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# set build ENV
ARG MIX_ENV=prod

# install mix dependencies
COPY mix.exs mix.lock ./
COPY config config
RUN mix do deps.get, deps.compile

# build assets
COPY assets/package.json assets/package-lock.json ./assets/
RUN npm --prefix ./assets ci --progress=false --no-audit --loglevel=error

COPY priv priv
COPY assets assets
RUN npm run --prefix ./assets deploy
RUN mix phx.digest

# compile and build release
COPY lib lib
# uncomment COPY if rel/ exists
# COPY rel rel
RUN mix do compile, release

# prepare release image
FROM alpine:3.9 AS app
RUN apk add --no-cache openssl ncurses-libs

WORKDIR /app

RUN chown nobody:nobody /app

USER nobody:nobody

COPY --from=build --chown=nobody:nobody /app/_build/prod/rel/ex_chat ./

ENV HOME=/app

ENV DATABASE_URL="ecto://postgres:postgres@ex_chat-pg/postgres" \
    SECRET_KEY_BASE="vlOM4w4Qmxb5AuTKGDVwsrXQlozxKPRQkaQaFX8waE17kJQYhBkgsPe6ohGWJx2G" \
    JWT_SECRET_KEY="W/B6Qq7yzMhI3l1P+HtMXb1NwYNd2rxIVyqZmu4J22kJbodl3mkcQ4yzoz85rfCO" \
    SERVER_PORT="4000" \
    HTTP_HOST="localhost" \
    HTTP_PORT="4000"

CMD ["bin/ex_chat", "start"]