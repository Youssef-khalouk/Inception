FROM debian:bookworm

RUN apt-get update && \
    apt-get install -y --no-install-recommends nginx && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/www/html

COPY tools/my_cv.html /var/www/html/index.html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]