#!bin/bash

mkdir -p /var/run/vsftpd/empty

cat <<EOF > /etc/vsftpd.conf
listen=YES
anonymous_enable=NO
local_enable=YES
write_enable=YES
pasv_enable=YES
pasv_min_port=30000
pasv_max_port=30009
local_root=/var/www/html
chroot_local_user=NO
secure_chroot_dir=/var/run/vsftpd/empty
EOF

useradd -m ${FTP_USER}
echo "${FTP_USER}:${FTP_PASS}" | chpasswd

chown -R "$FTP_USER:$FTP_USER" /var/www/html
chmod -R 755 /var/www/html

#start ftp server 
/usr/sbin/vsftpd /etc/vsftpd.conf