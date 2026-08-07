#!/bin/bash

# Usage: ./run_example.sh <example_name>
# Runs a single Exclosured example from the cloned main repo.
#
# Asset build strategies per example:
#   esbuild (most):        mix esbuild APP --minify
#   live_svelte_wasm:      npm install + node build.js
#   live_vue_wasm:         npm install + npx vite build
#   kino_exclosured:       (no assets to build, excluded from demos)

set -ex

EXAMPLE_NAME="$1"
if [ -z "$EXAMPLE_NAME" ]; then
  echo "Usage: $0 <example_name>"
  exit 1
fi

REPO_DIR="$(cd "$(dirname "$0")" && pwd)/exclosured"
EXAMPLE_DIR="$REPO_DIR/examples/$EXAMPLE_NAME"

if [ ! -d "$EXAMPLE_DIR" ]; then
  echo "Example not found: $EXAMPLE_DIR"
  exit 1
fi

# Add nvm node to PATH
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

export MIX_ENV="prod"
# Generate one with `mix phx.gen.secret` and export it before running.
: "${SECRET_KEY_BASE:?SECRET_KEY_BASE is not set}"
export PHX_HOST="${EXAMPLE_NAME//_/-}.exclosured.app"
export PHX_CHECK_ORIGIN="false"

cd "$EXAMPLE_DIR"

# 1. Install Elixir deps
mix deps.get

# 2. Install npm deps (live_svelte_wasm, live_vue_wasm)
if [ -f "assets/package.json" ]; then
  echo "[run_example] Installing npm dependencies..."
  cd assets && npm install && cd ..
fi

# 3. Compile Elixir + WASM
mix compile

# 4. Build assets
case "$EXAMPLE_NAME" in
  live_svelte_wasm)
    echo "[run_example] Building assets with node build.js..."
    cd assets && node build.js && cd ..
    ;;
  live_vue_wasm)
    echo "[run_example] Building assets with vite..."
    cd assets && npx vite build && cd ..
    ;;
  *)
    # Most examples use esbuild via the hex package.
    # The esbuild profile name matches the app name.
    echo "[run_example] Building assets with esbuild..."
    mix esbuild "$EXAMPLE_NAME" --minify 2>/dev/null || true
    ;;
esac

# 5. Start the server
echo "[run_example] Starting $EXAMPLE_NAME..."
mix phx.server
