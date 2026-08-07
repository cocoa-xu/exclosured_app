# syntax=docker/dockerfile:1
#
# Builds the landing page into an OTP release image.
#
#   docker build -t exclosured-app .

ARG ELIXIR_IMAGE=hexpm/elixir:1.19.5-erlang-28.4.3-debian-trixie-20260803
ARG RUNTIME_IMAGE=debian:trixie-slim

FROM ${ELIXIR_IMAGE} AS builder

ENV MIX_ENV=prod \
    LANG=C.UTF-8

RUN apt-get update && apt-get install -y --no-install-recommends \
      build-essential ca-certificates git \
    && rm -rf /var/lib/apt/lists/*

RUN mix local.hex --force && mix local.rebar --force

WORKDIR /src
COPY . .

RUN mix deps.get --only prod
RUN mix compile
RUN mix release --overwrite --path /app


FROM ${RUNTIME_IMAGE}

ENV LANG=C.UTF-8

RUN apt-get update && apt-get install -y --no-install-recommends \
      ca-certificates libncurses6 libssl3 libstdc++6 \
    && rm -rf /var/lib/apt/lists/* \
    && useradd --create-home --uid 10001 app

COPY --from=builder --chown=app:app /app /app

USER app
WORKDIR /app

ENTRYPOINT ["/app/bin/exclosured_app"]
CMD ["start"]
