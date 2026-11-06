# User documentation

This guide explains how to use the Inception stack after an administrator has configured Docker, the environment file, secrets, and host data directories.

## Services

- **Nginx:** HTTPS entry point and reverse proxy for the website and web tools.
- **WordPress:** Website and publishing interface; its files are shared with Nginx and FTP.
- **MariaDB:** WordPress database.
- **Redis:** Object cache used by WordPress.
- **Adminer:** Browser-based database administration.
- **Portainer:** Browser-based Docker administration.
- **FTP:** File transfer access to the WordPress files.
- **CV:** Static personal CV page.

## Start and stop

Run these commands from the repository root:

```sh
make
make down
```

`make` builds images and starts the services in the background. `make down` stops and removes this Compose project's containers and network. It preserves the data directories. To start it again, run `make`.

## Open the website and administration tools

Make sure the configured domain resolves to the Docker host. For a local setup, an administrator may need to add `ykhalouk.42.fr` to the client's hosts file using the host's IP address.

- Website: `https://ykhalouk.42.fr/`
- WordPress administration: `https://ykhalouk.42.fr/wp-admin/`
- Adminer: `https://ykhalouk.42.fr/adminer/` (also published on host port 8081)
- CV: `https://ykhalouk.42.fr/cv/`
- Portainer: `https://ykhalouk.42.fr/portainer/` (also published on ports 9000 and 9443)
- FTP: connect to the Docker host on port 21; allow passive ports 30000–30009 through any firewall.

Nginx uses a self-signed certificate, so browsers will show a certificate warning until a trusted certificate is configured.

For Adminer, select `mariadb` as the server and use the database name and username from `srcs/.env` with the database password from `secrets/db_password.txt`. WordPress administrator and regular-user passwords are in `secrets/wp_admin_password.txt` and `secrets/wp_user_password.txt`; their usernames are configured in `srcs/.env`. FTP username and password are configured in `srcs/.env` (`FTP_USER` and `FTP_PASS`). Treat all these files as private. Do not share their contents or commit them.

## Check service health

From the repository root, inspect Compose status and logs:

```sh
docker compose -f srcs/docker-compose.yml ps
docker compose -f srcs/docker-compose.yml logs --tail=100
docker compose -f srcs/docker-compose.yml logs --tail=100 nginx wordpress mariadb
```

The containers should show as running. Open the website and sign in to `/wp-admin/` to confirm the web and WordPress path works. Adminer should load and be able to connect to `mariadb`. If a service is restarting or unavailable, check its logs and confirm the `.env`, secret files, host data directories, DNS/hosts mapping, and required host ports.

Persistent website files, database files, and Portainer state are stored on the host under `/home/ykhalouk/data/wordpress_data`, `/home/ykhalouk/data/mariadb_data`, and `/home/ykhalouk/data/portainer_data`. Stopping the stack does not erase these directories.
