#!/usr/bin/env bash
set -e

SERVER="best-linux.cs.wisc.edu"

# Resolve directory of this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="$SCRIPT_DIR/fetch.conf"

usage() {
  cat <<EOF
Usage:
  $(basename "$0")                      Interactive mode
  $(basename "$0") <project> -o <dest>  Non-interactive mode

Options:
  -o <dest>     Destination directory (created if missing)
  -h, --help    Show this help message
EOF
}

# -----------------------------
# Help option
# -----------------------------
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
  usage
  exit 0
fi

# -----------------------------
# Load config
# -----------------------------
if [[ ! -f "$CONFIG_FILE" ]]; then
  echo "Error: fetch.conf not found in $SCRIPT_DIR"
  echo
  echo "Create fetch.conf with:"
  echo 'CSUSER="your_CS_username"'
  echo 'INSTRUCTOR="your_instructor_last_name"'
  exit 1
fi

# shellcheck source=/dev/null
source "$CONFIG_FILE"

if [[ -z "$CSUSER" || -z "$INSTRUCTOR" ]]; then
  echo "Error: CS Username or INSTRUCTOR not set in fetch.conf"
  exit 1
fi

# -----------------------------
# Argument parsing
# -----------------------------
PROJECT=""
DEST=""

if [[ "$#" -eq 0 ]]; then
  # Interactive mode
  read -rp "Enter project number: " PROJECT
  DEST="."
else
  PROJECT="$1"
  shift

  while getopts ":o:h" opt; do
    case "$opt" in
    o) DEST="$OPTARG" ;;
    h)
      usage
      exit 0
      ;;
    \?)
      echo "Error: invalid option -$OPTARG"
      usage
      exit 1
      ;;
    :)
      echo "Error: option -$OPTARG requires an argument"
      exit 1
      ;;
    esac
  done

  if [[ -z "$DEST" ]]; then
    echo "Error: destination required in non-interactive mode"
    usage
    exit 1
  fi
fi

# -----------------------------
# Validation
# -----------------------------
if [[ ! "$PROJECT" =~ ^[0-9]+$ ]]; then
  echo "Error: project number must be numeric"
  exit 1
fi

# Auto-create destination directory
mkdir -p "$DEST"

REMOTE_PATH="/p/course/cs354-${INSTRUCTOR}/out/${CSUSER}/p${PROJECT}"

echo "Fetching p${PROJECT} for CS Username '${CSUSER}' → $DEST"
scp -r "${CSUSER}@${SERVER}:${REMOTE_PATH}" "$DEST"
