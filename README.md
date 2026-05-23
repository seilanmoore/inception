# Inception (Dockerized WordPress stack)

This repository is a small infrastructure project that builds and runs a complete web stack using **Docker Compose**. It orchestrates three services:

- **Nginx** (reverse proxy / HTTPS terminator)
- **WordPress** (PHP-FPM application)
- **MariaDB** (database)

Everything is built from custom Dockerfiles (not “latest” prebuilt images), and the services are connected through a dedicated Docker network and persistent volumes.

---

## What this project is about

The goal is to understand how a real-world web application is composed from multiple services and how those services communicate:

- **Nginx** receives HTTPS traffic on port **443** and serves the WordPress site.
- **WordPress** runs as an application service and connects to **MariaDB** for data storage.
- **MariaDB** provides the database backend and persists data on disk.

The project also uses:

- A **`.env`** file to centralize configuration (domain, site title, database/user names, etc.).
- A **`secrets/`** folder with password files mounted into containers as read-only secrets.
- Host-mounted **volumes** to persist WordPress and MariaDB data across container rebuilds.

---

## Concepts

### Docker & Docker Compose fundamentals
- Writing Dockerfiles (installing packages, copying configs, entrypoints)
- Building images locally and controlling rebuilds
- Composing multiple services with dependency ordering (`depends_on`)
- Managing networks and service-to-service communication

### Web infrastructure concepts
- Reverse proxying and TLS termination with **Nginx**
- Serving a PHP application stack (WordPress + PHP-FPM style setup)
- Understanding a typical 3-tier architecture (proxy/app/db)

### Persistence & environment management
- Persistent storage with Docker volumes / bind mounts
- Environment-based configuration using `.env`
- Handling sensitive credentials through mounted secret files instead of hardcoding

---

## Repository structure (high level)

- `Makefile` — convenience commands to build/up/down/clean/logs
- `srcs/docker-compose.yml` — the stack definition
- `srcs/.env` — environment variables used by services
- `srcs/requirements/` — service build contexts (Dockerfiles + configs + scripts)
  - `nginx/`
  - `wordpress/`
  - `mariadb/`
- `secrets/` — password files mounted into containers (read-only)

---

## Services

### Nginx
- Exposes **443:443** on the host.
- Creates a **self-signed certificate** during image build using `DOMAIN_NAME`.
- Mounts the WordPress files volume at `/var/www/wordpress` so it can serve the site.
- Uses a custom entrypoint script (`tools/nginx.sh`).

### WordPress
- Depends on MariaDB.
- Mounts the WordPress volume at `/var/www/wordpress`.
- Reads WordPress and DB secrets from `/run/secrets/*.txt`.

### MariaDB
- Persists database files at `/var/lib/mysql` via a bind-mounted volume.
- Reads DB secrets from `/run/secrets/*.txt`.

---

## Prerequisites

- Docker
- Docker Compose

On Linux, you may need sudo permissions or to add your user to the `docker` group.

---

## Configuration

### 1) `.env` file

The main configuration is in:

- `srcs/.env`

Example values included in this repo:
- `DOMAIN_NAME=smoore-a.42.fr`
- `SITE_TITLE=Inception`
- `MYSQL_DATABASE=mysql_db`
- `MYSQL_USER=mysql_user`
- WordPress users/emails (admin + regular user)

You can change `DOMAIN_NAME` to match your own setup (for local testing you can use something like `localhost` or a custom hostname mapped in `/etc/hosts`).

### 2) Secrets

The Compose file expects these secret files (mounted read-only):

- `secrets/db_password.txt`
- `secrets/db_root_password.txt`
- `secrets/wp_password.txt`
- `secrets/wp_admin_password.txt`

Make sure they exist and contain the correct passwords (one password per file, typically a single line).

---

## How to use

All the common commands are provided through the `Makefile`, which calls:

- `docker-compose -f srcs/docker-compose.yml ...`

From the repository root:

### Build and start
```bash
make
```
This runs `make build` and then `make up`.

### Start (detached)
```bash
make up
```

### Stop
```bash
make down
```

### Restart
```bash
make restart
```

### Follow logs
```bash
make logs
```

### Full cleanup (containers, volumes, images, and host data)
```bash
make fclean
```

`fclean` will:
- Bring the stack down with volumes
- Remove images
- Prune Docker aggressively
- Delete the persisted data directories under `$HOME/data/...`

Read the Makefile before running it if you have anything important in those directories.

---

## Accessing the site

- Nginx publishes **HTTPS on port 443**.
- With the default config, the site is meant to be accessed via the configured `DOMAIN_NAME`.

If you are testing locally, you can:
1. Set `DOMAIN_NAME` in `srcs/.env` to a hostname you control (e.g. `inception.local`)
2. Add it to `/etc/hosts` pointing to `127.0.0.1`
3. Visit: `https://inception.local`

Because the certificate is self-signed, your browser will warn you; you can proceed for development/testing.

---

## Troubleshooting

- **Port 443 already in use**: stop other services using 443 (another Nginx, Apache, etc.) or change the published port in `docker-compose.yml`.
- **Permissions issues with volumes**: ensure the host directories exist and have correct permissions.
- **Domain not resolving**: update `/etc/hosts` (local) or DNS (if using a real domain).
- **Old data causing weird behavior**: try `make fclean` (careful: it deletes persisted data).

---

## Notes

This project is intentionally focused on core infrastructure concepts:
- building images,
- wiring services together,
- persisting data,
- and serving a real application behind TLS.

It’s a great stepping stone before moving to more advanced topics like orchestration (Kubernetes), managed TLS certificates, observability, and CI/CD deployments.
