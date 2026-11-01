FROM	debian:bookworm

#install all the program
RUN		apt-get update
RUN		apt-get install -y nginx openssl

# nginx SSL
RUN mkdir /etc/nginx/ssl
RUN openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes \
       -out /etc/nginx/ssl/ykhalouk.crt \
       -keyout /etc/nginx/ssl/ykhalouk.key \
       -subj "/C=MA/ST=Ben/L=Ben/O=1337 School/OU=ykhalouk/CN=ykhalouk/"

COPY ./conf/nginx.conf /etc/nginx/conf.d/

# nginx config
RUN mkdir -p /run/nginx

# Start nginx
CMD ["nginx", "-g", "daemon off;"]