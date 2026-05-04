# simplewebservercontainer

A minimal, hardened nginx container that serves static files over HTTPS.

## How it works

The project uses a `nginx:alpine` Docker image (~20 MB) with a self-signed TLS certificate
generated at build time. Static files are mounted from the project directory into the container
at runtime, so you can update files without rebuilding the image.

nginx listens on port 443 inside the container, exposed on host port **4434**.

## Requirements

- Docker
- Docker Compose

## Usage

**Start**
```sh
./start.sh
```

**Stop**
```sh
./stop.sh
```

Files are served at `https://localhost:4434`. Your browser will warn about the self-signed
certificate — accept the exception to proceed.

## Adding files to be served

Place any `.html`, `.htm`, `.js`, `.css`, `.json`, or other static files directly in the
project root directory. They will be picked up automatically — no restart or rebuild required.

```
.
├── index.html       → https://localhost:4434/index.html
├── app.js           → https://localhost:4434/app.js
├── styles.css       → https://localhost:4434/styles.css
└── data/
    └── info.json    → https://localhost:4434/data/info.json
```

Subdirectories are supported. nginx will serve any file it can find under the project root.
A directory listing is shown automatically if no `index.html` is present.

## Project structure

```
.
├── Dockerfile          # Builds the nginx:alpine image with a self-signed TLS cert
├── nginx.conf          # Hardened nginx vhost (TLS 1.2/1.3, security headers)
├── docker-compose.yml  # Port mapping (4434→443) and read-only volume mount
├── start.sh            # Builds (if needed) and starts the container
└── stop.sh             # Stops and removes the container
```

## Security notes

- TLS 1.2 and 1.3 only, modern cipher suite
- Security headers: HSTS, `X-Content-Type-Options`, `X-Frame-Options`, `CSP`, and more
- `server_tokens off` — nginx version hidden from responses
- Container filesystem is read-only; nginx temp files use `tmpfs`
- Volume mounted read-only (`:ro`)
- Dotfiles (e.g. `.env`) are blocked by nginx


