#!/usr/bin/env bash
set -e

# Must be run from project root (where .npm-cache exists)

ROOT="$(pwd)"

# Use project-local npm cache
npm config set cache "$ROOT/.npm-cache" --location=project >/dev/null

# Electron caches (required for offline dev & dist)
export ELECTRON_CACHE="$ROOT/.electron-cache"
export ELECTRON_BUILDER_CACHE="$ROOT/.electron-builder-cache"

echo "Offline environment ready:"
echo "  npm cache = $(npm config get cache)"
echo "  ELECTRON_CACHE = $ELECTRON_CACHE"
echo "  ELECTRON_BUILDER_CACHE = $ELECTRON_BUILDER_CACHE"
