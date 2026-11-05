From debian:bookworm

RUN apt update -y && apt install -y vsftpd ftp

COPY tools/scriptftp.sh /script.sh

RUN chmod +x /script.sh

EXPOSE 21
EXPOSE 30000-30009

CMD ["/script.sh"]