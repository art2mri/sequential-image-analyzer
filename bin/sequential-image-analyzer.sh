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
  --help, -h              Show this help message and exit.
EOF
  exit 1
}

DIR=""
START_NAME=""

# Parse arguments.
while [[ $# -gt 0 ]]; do
  case "$1" in
    --images-dir) DIR="$2"; shift 2 ;;
    --start-id) START_NAME="$2"; shift 2 ;;
    --help|-h) usage ;;
    *) echo "sequential-image-analyzer: invalid option: $1"; echo "Try 'sequential-image-analyzer --help'"; exit 1 ;;
  esac
done
