# DOCKER COMMANDS CHEAT SHEET

## Check
```bash
docker --version                 # Display the installed Docker version
docker info                      # Show Docker system information
```

## Images
```bash
docker images                    # List all local images
docker pull IMAGE                # Download an image from a registry
docker build -t NAME .           # Build an image with a custom name
docker rmi IMAGE                 # Remove a local image
docker inspect IMAGE             # Display detailed image information
docker history IMAGE             # Show the layers used to build an image
```

## Containers
```bash
docker run IMAGE                 # Create and start a container
docker ps                        # List running containers
docker ps -a                     # List all containers, including stopped ones
docker start CONTAINER           # Start a stopped container
docker stop CONTAINER            # Stop a running container
docker restart CONTAINER         # Restart a container
docker rm CONTAINER              # Remove a stopped container
docker exec -it CONTAINER bash   # Open an interactive Bash shell inside a container
docker logs CONTAINER            # Display container logs
docker inspect CONTAINER         # Display detailed container information
docker cp SOURCE CONTAINER:DEST  # Copy files between host and container
```

## Move Images
```bash
docker save IMAGE -o image.tar   # Export an image to a TAR file
docker load -i image.tar         # Import an image from a TAR file
```

## Registry
```bash
docker login                     # Authenticate with a Docker registry
docker pull IMAGE                # Download an image from a registry
docker push IMAGE                # Upload an image to a registry
```

## Volumes
```bash
docker volume ls                 # List all volumes
docker volume create NAME        # Create a new volume
docker volume inspect NAME       # Display detailed volume information
docker volume rm NAME            # Remove a volume
```

## Networks
```bash
docker network ls                # List all networks
docker network create NAME       # Create a new network
docker network inspect NAME      # Display detailed network information
docker network rm NAME           # Remove a network
```

## Cleanup
```bash
docker system df                 # Show Docker disk usage
docker container prune           # Remove all stopped containers
docker image prune               # Remove unused dangling images
docker system prune              # Remove unused containers, networks, and images
docker system prune -a           # Remove all unused images and other unused resources
```

