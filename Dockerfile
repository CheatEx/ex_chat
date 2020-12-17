FROM elixir:1.11.2-alpine AS build

# install build dependencies
RUN apk add --no-cache build-base npm

WORKDIR /app

RUN mix local.hex --force && \
    mix local.rebar --force

ARG MIX_ENV=docker

COPY mix.exs mix.lock ./
RUN mix do deps.get, deps.compile

COPY assets/package.json assets/package-lock.json ./assets/
RUN npm --prefix ./assets ci --progress=false --no-audit --loglevel=error

COPY config config
COPY priv priv
COPY assets assets
RUN npm run --prefix ./assets deploy
RUN mix phx.digest

COPY lib lib
RUN mix release


FROM alpine:3.9 AS app
RUN apk add --no-cache openssl ncurses-libs

WORKDIR /app

RUN chown nobody:nobody /app

USER nobody:nobody

COPY --from=build --chown=nobody:nobody /app/_build/docker/rel/ex_chat ./

ENV HOME=/app

ENV DATABASE_URL="ecto://postgres:postgres@ex_chat-pg/postgres" \
    SECRET_KEY_BASE="vlOM4w4Qmxb5AuTKGDVwsrXQlozxKPRQkaQaFX8waE17kJQYhBkgsPe6ohGWJx2G" \
    JWT_SECRET_KEY="W/B6Qq7yzMhI3l1P+HtMXb1NwYNd2rxIVyqZmu4J22kJbodl3mkcQ4yzoz85rfCO" \
    PORT="4000" \
    HTTP_SCHEME="http" \
    HTTP_HOST="localhost" \
    HTTP_PORT="4000"

CMD bin/ex_chat eval "ExChat.Migrations.migrate" && bin/ex_chat start
