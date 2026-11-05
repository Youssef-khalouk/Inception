From debian:bookworm

RUN apt update -y && apt install -y vsftpd ftp

COPY tools/scriptftp.sh /script.sh

RUN chmod +x /script.sh

CMD ["/script.sh"]