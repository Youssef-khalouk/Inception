FROM debian:bookworm

RUN apt update && apt install curl -y \
	&& curl -L https://github.com/portainer/portainer/releases/download/2.11.1/portainer-2.11.1-linux-amd64.tar.gz -o portainer.tar.gz \
    && tar xvzf portainer.tar.gz \
    && rm portainer.tar.gz

CMD [ "/portainer/portainer" ]