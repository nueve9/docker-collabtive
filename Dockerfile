###### Updated version of fedora (20)
##FROM qnib/centos6_supervisor
##MAINTAINER "Christian Kniep <christian@qnib.org>"

FROM scratch
ADD centos-6-docker.tar.xz /

LABEL org.label-schema.schema-version="1.0" \
    org.label-schema.name="CentOS Base Image" \
    org.label-schema.vendor="CentOS" \
    org.label-schema.license="GPLv2" \
    org.label-schema.build-date="20180804"


CMD ["/bin/bash"]


EXPOSE 80
VOLUME ["/var/www/html", "/var/lib/mysql"]

RUN yum install -y tar nano vim; yum clean all

RUN yum install -y mysql-server ImageMagick-perl; yum clean all

RUN yum install -y httpd php php-pear php-xml php-mysql php-intl php-pecl-apc php-gd php-mbstring; yum clean all

# httpd start
ADD etc/supervisord.d/httpd.ini /etc/supervisord.d/httpd.ini

# Jumpstart mariadb
RUN getent passwd mysql || useradd mysql
RUN mkdir -p /var/run/mysqld; chown -R mysql:mysql /var/lib/mysql /var/run/mysqld
ADD etc/supervisord.d/start_mysqld.ini /etc/supervisord.d/start_mysqld.ini
ADD root/bin/start_mysqld.sh /root/bin/start_mysqld.sh

ADD root/bash_func /root/
ADD etc/supervisord.d/setup_collabtive.ini /etc/supervisord.d/
ADD root/bin/setup_collabtive.sh /root/bin/
ADD etc/supervisord.d/backup_site.ini /etc/supervisord.d/
ADD root/bin/backup_site.sh /root/bin/

COPY collabtive31_init.tar /root/collabtive31_init.tar
COPY backup_init.sql /root/backup_init.sql

CMD /usr/bin/supervisord -c /etc/supervisord.conf
