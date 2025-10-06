#!/usr/bin/env bash

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Change to the parent directory (project root) where Dockerfile is located
cd "$(dirname "$SCRIPT_DIR")"

docker build -t astar-route-planning-focal-workspace -f Dockerfile .

