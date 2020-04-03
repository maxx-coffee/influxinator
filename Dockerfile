FROM elixir:latest
MAINTAINER Josh Coffee
RUN apt-get update && apt-get install --yes postgresql-client nodejs inotify-tools
ADD . /app
RUN mix local.hex --force
RUN mix archive.install --force hex phx_new 1.4.16
WORKDIR /app
EXPOSE 4000