#!/bin/sh
set -e

docker compose up --build -d
echo "Webserver running at https://localhost:4434"
