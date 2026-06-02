#!/usr/bin/env bash
set -euo pipefail

DEFAULT_REPO_URL="${GSA_BRAIN_REPO:-https://github.com/chasepkelly/GSA-brain.git}"

say() {
  printf '%s\n' "$1"
}

ask() {
  local prompt="$1"
  local default_value="${2:-}"
  local answer

  if [ -n "$default_value" ]; then
    printf '%s [%s]: ' "$prompt" "$default_value" >&2
  else
    printf '%s: ' "$prompt" >&2
  fi

  read -r answer
  if [ -z "$answer" ]; then
    printf '%s' "$default_value"
  else
    printf '%s' "$answer"
  fi
}

slugify() {
  printf '%s' "$1" \
    | tr '[:upper:]' '[:lower:]' \
    | sed -E 's/[^a-z0-9]+/-/g; s/^-+//; s/-+$//'
}

require_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    say "Missing required command: $1"
    say "Please install $1, then run this installer again."
    exit 1
  fi
}

say ""
say "GSA Brain Installer"
say "==================="
say ""

require_command git
require_command npm

workspace_name="$(ask "Workspace name" "gsa-client-workspace")"
workspace_name="$(slugify "$workspace_name")"

if [ -z "$workspace_name" ]; then
  workspace_name="gsa-client-workspace"
fi

install_parent="$(ask "Install location" "$PWD")"
target_dir="${install_parent%/}/$workspace_name"

say ""
say "Workspace folder:"
say "$target_dir"
say ""

if [ -d "$target_dir/.git" ]; then
  say "Existing GSA Brain workspace found. Pulling updates..."
  git -C "$target_dir" pull --ff-only
elif [ -d "$target_dir" ] && [ "$(find "$target_dir" -mindepth 1 -maxdepth 1 2>/dev/null | wc -l | tr -d ' ')" != "0" ]; then
  say "That folder already exists and is not empty:"
  say "$target_dir"
  say "Choose a different workspace name or move that folder first."
  exit 1
else
  say "Downloading GSA Brain..."
  git clone --depth 1 "$DEFAULT_REPO_URL" "$target_dir"
fi

say ""
say "Initializing workspace folders..."
npm --prefix "$target_dir" run init:workspace

say ""
say "Checking framework..."
npm --prefix "$target_dir" run check

say ""
say "Done."
say ""
say "Next step:"
say "Open this folder in Claude Cowork or Codex:"
say "$target_dir"
