#!/usr/bin/env bash
set -euo pipefail

# sequential-image-analyzer
# Bash script to open NIfTI files (.nii, .nii.gz) found in immediate subdirectories
# one by one with ITK-SNAP.

# sequential-image-analyzer
# Bash script to open NIfTI files (.nii, .nii.gz) found in subdirectories one
# by one using ITK-SNAP.

usage() {
  cat << EOF
sequential-image-analyzer
Usage: $(basename "$0") --images-dir PATH [--start-id SUBDIR_NAME]

Required flags:
  --images-dir PATH       Directory that contains immediate subdirectories with
                          NIfTI files.

Optional flags:
  --start-id SUBDIR_NAME  Optional subdirectory name to start from. The script
                          will skip all subdirectories until it finds a
                          subdirectory whose basename equals SUBDIR_NAME, then
                          process that one and all following subdirectories.
  --first-one             Opens only the first matching image (*.nii or
                          *.nii.gz) found in each subdirectory and ignores the
                          remainig images in that subdirectory.
  --help, -h              Show this help message and exit.
EOF
  exit 1
}

DIR=""
START_NAME=""
FIRST_ONE=false

# Parse arguments.
while [[ $# -gt 0 ]]; do
  case "$1" in
    --images-dir) DIR="$2"; shift 2 ;;
    --start-id) START_NAME="$2"; shift 2 ;;
    --first-one) FIRST_ONE=true; shift 1 ;;
    --help|-h) usage ;;
    *) echo "Invalid option: $1"; echo "Try 'sequential-image-analyzer --help'"; exit 1 ;;
  esac
done

# Check if --images-dir was passed.
if [[ -z "${DIR:-}" ]]; then
  echo "Error: --images-dir is required."
  echo "Try 'sequential-image-analyzer --help'."
  exit 1
fi

trap 'echo; echo "Interrupted by user."; exit 0' INT TERM
shopt -s nullglob

started=false
if [[ -z "${START_NAME:-}" ]]; then
  started=true
fi

count=0
opened=0

if [[ -n "${START_NAME:-}" ]]; then
  echo "The script will start from subdirectory: $START_NAME"
else
  echo "The script will start from the first subdirectory found."
fi

# Read subdirectories in alphabeticak (natural) order.
mapfile -d '' subs < <(
  find "$DIR" -maxdepth 1 -mindepth 1 -type d -print0 \
  | sort -z -V
)

for sub in "${subs[@]}"; do
  subname="$(basename "$sub")"

  # echo "$subname"

  if ! $started; then
    if [[ "$subname" == "$START_NAME" ]]; then
      started=true
    else
      continue
    fi
  fi

  found_one=false

  # Gather files in the subdirectory and sort them alphabetically.
  mapfile -d '' files < <(
    find "$sub" -maxdepth 1 -type f \( -name '*.nii' -o -name '*.nii.gz' \) -print0 \
    | sort -z -V
  )

  for f in "${files[@]}"; do
    [[ -e "$f" ]] || continue

    count=$((count + 1))
    opened=$((opened + 1))

    echo "[$count] Opening: $f"

    itksnap -g "$f"

    found_one=true
    if $FIRST_ONE; then
      break
    fi
  done

  # Optional blank line for readability.
  echo
done

echo "Done. Opened $opened file(s)."
