# ExChat

Just a playground to learn elixir

## Notes

docker run --detach --network ex_chat -p 5432:5432 -e POSTGRES_PASSWORD=postgres --name ex_chat-pg postgres:13.1-alpine

docker build . --tag ex_chat-web

docker run --rm --network ex_chat -p 4000:4000 --name ex_chat-web ex_chat-web:latest

heroku container:push web --app ex-chat-by-cheatex

heroku container:release web --app ex-chat-by-cheatex

heroku pg:psql postgresql-horizontal-79769 --app ex-chat-by-cheatex