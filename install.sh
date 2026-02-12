#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://github.com/maddix123/cv2.git"
INSTALL_DIR="/opt/cv2"
BIN_PATH="/usr/local/bin/cv2"
TMP_DIR="$(mktemp -d)"

cleanup() {
  rm -rf "$TMP_DIR"
}
trap cleanup EXIT

if ! command -v git >/dev/null 2>&1; then
  echo "git is required. Installing..."
  if command -v apt-get >/dev/null 2>&1; then
    apt-get update && apt-get install -y git
  elif command -v dnf >/dev/null 2>&1; then
    dnf install -y git
  elif command -v yum >/dev/null 2>&1; then
    yum install -y git
  else
    echo "Unsupported package manager. Install git manually." >&2
    exit 1
  fi
fi

if ! command -v python3 >/dev/null 2>&1; then
  echo "python3 is required. Please install it and rerun." >&2
  exit 1
fi

echo "Cloning $REPO_URL"
git clone --depth 1 "$REPO_URL" "$TMP_DIR/repo"

mkdir -p "$INSTALL_DIR"
install -m 0644 "$TMP_DIR/repo/index.html" "$INSTALL_DIR/index.html"
install -m 0755 "$TMP_DIR/repo/cv2" "$BIN_PATH"

echo "Installed successfully."
echo "Run: cv2"
echo "Then open: http://<your-vps-ip>:8080"
