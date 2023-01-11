FROM mysql:8.0.20

ENV MYSQL_ROOT_PASSWORD=1
ENV MYSQL_DATABASE=codebase
ENV MYSQL_USER=root
ENV MYSQL_PASSWORD=1

COPY ./mysql_custom.cnf /etc/mysql/conf.d/mysql_custom.cnf
RUN chmod 555 /etc/mysql/conf.d/mysql_custom.cnf
