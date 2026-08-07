#!/bin/bash

set -ex

export PORT="5000"
# Generate one with `mix phx.gen.secret` and export it before running.
: "${SECRET_KEY_BASE:?SECRET_KEY_BASE is not set}"
export PHX_HOST="exclosured.app"
export MIX_ENV="prod"

mix deps.get && mix phx.server
