FROM centos:7
RUN yum update -y && yum clean all
RUN yum -y install mlocate net-tools epel-release telnet hg
RUN rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
RUN rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm
RUN yum -y install php55w-5.5.38-1.w7.x86_64 php55w-fpm php55w-pdo php55w-pgsql php55w-pecl-geoip php55w-devel php55w-mysql php55w-mbstring php55w-pecl-redis php55w-mcrypt php55w-opcache php55w-intl php55w-soap php55w-pear libgearman
RUN yum -y install httpd 
COPY *.rpm /root/
COPY httpd.conf /etc/httpd/conf/
RUN echo "Listen 80" > /etc/httpd/conf/ports.conf
COPY devwww.cram.com.conf /etc/httpd/conf.d/
RUN cp /etc/mime.types /etc/httpd/conf/
RUN rpm -ivh /root/ZendFramework-1.11.12-1.x86_64.rpm
RUN rpm -ivh /root/GeoIP-initial-0.1-1.x86_64.rpm
RUN rpm -ivh  /root/php55w-pecl-gearman-1.1.2-1.w7.src.rpm
RUN rpm -ivh /root/php55w-pecl-gearman-1.1.2-1.w7.x86_64.rpm
RUN echo 127.0.0.1 devwww.cram.com > /etc/hosts
COPY GeoIP.conf.erb /etc/GeoIP/GeoIP.conf 
COPY mongo.so /usr/lib64/php/modules/ 
COPY mongo.ini /etc/php.d/
COPY php.ini /etc/
####This section is for haproxy for SSL offloading (temporary)###
RUN yum -y install haproxy
RUN mkdir /etc/cert
COPY haproxy.cfg /etc/haproxy/
COPY null.host.pem /etc/cert
COPY docker-entrypoint /
CMD ["/docker-entrypoint"]
CMD ["haproxy", "-f", "/etc/haproxy/haproxy.cfg"]
#######End of HAPROXY#############################################
#COPY httpd-start /usr/local/bin
RUN echo "#!/bin/bash" > /usr/local/bin/httpd-start
RUN echo "set -e" >> /usr/local/bin/httpd-start 
RUN echo "rm -f /usr/local/apache2/logs/httpd.pid" >> /usr/local/bin/httpd-start
RUN echo "exec httpd -DFOREGROUND" >> /usr/local/bin/httpd-start
RUN chmod 777 /usr/local/bin/httpd-start
CMD ["httpd-start"]
EXPOSE 80
EXPOSE 443



