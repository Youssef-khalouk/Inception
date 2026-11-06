*This project has been created as part of the 42 curriculum by ykhalouk.*

# Inception

## Description

Inception is a Docker Compose infrastructure project. It builds a small WordPress site backed by MariaDB and serves it over HTTPS through Nginx. The services are built from the Dockerfiles and configuration under `srcs/requirements`; Compose connects them on a private bridge network and manages their persistent data.

The required services are Nginx, WordPress, and MariaDB. This repository also includes Redis for WordPress caching, an FTP service sharing the WordPress files, Adminer for database administration, Portainer for Docker administration, and a personal CV site.

### Design choices and concepts

- **Docker and project sources:** Each service has its own image build instructions and, where needed, startup scripts and configuration. `srcs/docker-compose.yml` describes service dependencies, ports, secrets, networks, and storage. The containers use Debian Bookworm based images; Nginx creates a self-signed certificate at image build time. Docker makes the services reproducible and keeps their runtime environments separate while allowing them to communicate over the Compose bridge network.
- **Virtual machines vs Docker:** A virtual machine runs a full guest operating system and virtual hardware. Docker containers share the host kernel and isolate processes, which generally uses fewer resources and starts faster. This project uses containers because its components are separate Linux services that can communicate through Compose.
- **Secrets vs environment variables:** Environment variables configure non-secret settings such as database names and service hostnames. Passwords are supplied to services as Docker Compose secrets mounted under `/run/secrets`. Keep secret files private and out of version control. FTP credentials are currently configured through `srcs/.env`, so protect that file as a credential-bearing configuration file too.
- **Docker network vs host network:** The Compose bridge network gives each service a private network and service-name DNS (for example, WordPress connects to `mariadb`). Only explicitly published ports are reachable from the host. Host networking would share the host network namespace and reduce this isolation; this project does not use it.
- **Docker volumes vs bind mounts:** A Docker-managed volume is managed by Docker. A bind mount maps a specific host path into a container. The Compose file declares local volumes backed by bind mounts under `/home/ykhalouk/data` for WordPress, MariaDB, and Portainer. This makes data visible at fixed host paths, but requires those directories to exist and be writable before startup. The FTP and Nginx services share the WordPress volume.

## Instructions

### Requirements

Use a Linux host with Docker Engine, the Docker Compose v2 plugin, and GNU Make. The Compose file currently expects persistent-data directories at `/home/ykhalouk/data/wordpress_data`, `/home/ykhalouk/data/mariadb_data`, and `/home/ykhalouk/data/portainer_data`.

### Configure and start

1. From the repository root, prepare `srcs/.env` using `srcs/.env.example` as a reference. Set the domain and account values for your environment. Do not commit credential-bearing `.env` files.
2. Create the three host data directories listed above and make them writable by Docker.
3. Ensure the three secret files referenced by Compose exist: `secrets/db_password.txt`, `secrets/wp_admin_password.txt`, and `secrets/wp_user_password.txt`. Use strong, private values and keep these files out of version control.
4. Point the chosen `DOMAIN_NAME` to the Docker host (for a local setup, add it to the client's hosts file). The Nginx server name and the WordPress install URL are currently set to `ykhalouk.42.fr` in project configuration, so update those settings together if you choose another domain.
5. Run `make` to build and start the stack in the background. `make down` stops and removes the containers and Compose network while retaining persistent data.

The main website is `https://ykhalouk.42.fr/` (accept the browser warning for the self-signed certificate). Adminer is available at `/adminer/`, the CV site at `/cv/`, and Portainer at `/portainer/`. The Compose file also publishes Adminer on port 8081 and Portainer on ports 9000 and 9443. FTP listens on port 21 and passive ports 30000–30009. Use the credentials configured in the environment and secret files; see [USER_DOC.md](USER_DOC.md) for access and health-check guidance.

Useful commands: `make` (build/start), `make down` (stop), and `docker compose -f srcs/docker-compose.yml ps` (status). The `make clean` target removes Docker containers, images, volumes, and networks across the host, not only this project; avoid it on a host with other Docker workloads.

## Resources

- [Docker Compose documentation](https://docs.docker.com/compose/)
- [Docker documentation](https://docs.docker.com/)
- [WordPress documentation](https://wordpress.org/documentation/)
- [MariaDB documentation](https://mariadb.org/documentation/)
- [Nginx documentation](https://nginx.org/en/docs/)
- [Docker Compose secrets](https://docs.docker.com/compose/how-tos/use-secrets/)

AI assistance was used to explain some Docker concepts.

## Further documentation

- [User documentation](USER_DOC.md)
- [Developer documentation](DEV_DOC.md)
