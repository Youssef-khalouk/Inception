# Developer documentation

## Prerequisites

- Linux host with Docker Engine and Docker Compose v2 (`docker compose`).
- GNU Make.
- Host ports 443, 21, 30000–30009, 8081, 9000, and 9443 available for the published services.
- Outbound network access during image builds and initial WordPress setup to retrieve operating-system packages, WordPress, WP-CLI, and service artifacts.

## Configure from scratch

1. Clone the repository and work from its root directory.
2. Create `srcs/.env` from `srcs/.env.example`. Set the domain, database, WordPress, and FTP values for the environment. `srcs/.env` is ignored by Git; do not commit it, especially while it contains `FTP_PASS`.
3. Create the Compose secret source files `secrets/db_password.txt`, `secrets/wp_admin_password.txt`, and `secrets/wp_user_password.txt`. Put one strong password in each, restrict host access to them, and keep them out of Git. Compose mounts them into the relevant containers under `/run/secrets`.
4. Create the host directories `/home/ykhalouk/data/wordpress_data`, `/home/ykhalouk/data/mariadb_data`, and `/home/ykhalouk/data/portainer_data`. Ensure the Docker daemon can write to them. The volume definitions in `srcs/docker-compose.yml` use these fixed Linux paths.
5. Configure DNS or a client hosts-file entry so the site domain resolves to the Docker host. The Nginx virtual host and WordPress installation URL are currently hard-coded as `ykhalouk.42.fr` in `srcs/requirements/nginx/conf/nginx.conf` and `srcs/requirements/wordpress/tools/install-wordpress.sh`; update both when changing domains.

The `.env.example` file is a template, not a complete secret store. Review it against the services before use. In this Compose setup, non-secret settings are passed through `env_file`; passwords for the database and WordPress accounts are mounted as secrets. FTP credentials are still read from environment variables by its startup script.

## Build and launch

The Makefile wraps Docker Compose. From the repository root:

```sh
make
```

This runs `docker compose -f ./srcs/docker-compose.yml up -d --build`, building configured images and starting the services in the background. Equivalent command:

```sh
docker compose -f srcs/docker-compose.yml up -d --build
```

The Compose build contexts and Dockerfiles are under `srcs/requirements`. Nginx publishes HTTPS on port 443; the other published ports and routed paths are listed in README.md and USER_DOC.md.

## Container and volume commands

```sh
# Show services and state
docker compose -f srcs/docker-compose.yml ps

# Follow logs
docker compose -f srcs/docker-compose.yml logs -f

# Restart or rebuild after configuration/source changes
docker compose -f srcs/docker-compose.yml up -d --build

# Stop and remove this project's containers and network
make down

# List Docker volumes
docker volume ls

# Inspect this project's declared volumes
docker volume ls --filter name=wordpress
docker volume ls --filter name=mariadb
docker volume ls --filter name=portainer
```

`make re` also runs Compose `up -d --build`. The `make clean` target is not project-scoped: it stops and removes every container, image, volume, and network on the Docker host. Avoid it on shared or production hosts. To reset this project, stop the stack and deliberately clear only its corresponding data directories after backing them up; deleting database or WordPress data is irreversible.

## Data and persistence

Compose declares three named local volumes using bind-backed driver options:

| Data | Container path | Host path |
| --- | --- | --- |
| WordPress files and uploads | `/var/www/html` | `/home/ykhalouk/data/wordpress_data` |
| MariaDB database | `/var/lib/mysql` | `/home/ykhalouk/data/mariadb_data` |
| Portainer state | `/data` | `/home/ykhalouk/data/portainer_data` |

The WordPress data volume is mounted by WordPress, Nginx, and FTP. MariaDB stores its database separately. These files remain on the host when Compose containers are removed, so a fresh container can reuse existing content. Back up these host directories before maintenance or migration. The fixed host paths and owner `ykhalouk` are specific to this repository's current configuration and may need editing for another machine.

## Source map

- `Makefile`: common start, stop, rebuild, and cleanup targets.
- `srcs/docker-compose.yml`: services, ports, dependencies, secrets, network, and persistent volume definitions.
- `srcs/requirements/nginx`: HTTPS reverse-proxy configuration and certificate build steps.
- `srcs/requirements/wordpress`: PHP-FPM image and WordPress initialization/configuration script.
- `srcs/requirements/mariadb`: database image and initialization script.
- `srcs/requirements/bonus`: Redis, FTP, Adminer, Portainer, and CV service builds.
- `secrets/`: Compose secret source files; keep passwords private.
