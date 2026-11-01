FROM debian:bookworm

RUN apt-get update && apt-get install -y --no-install-recommends \
    redis-server \
    && rm -rf /var/lib/apt/lists/*

COPY ./create.sh /etc/create.sh
RUN chmod 777 /etc/create.sh

ENTRYPOINT [ "/etc/create.sh" ]

CMD ["/etc/create.sh"]