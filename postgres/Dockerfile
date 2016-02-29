FROM archlinux:2016-02-26

RUN groupadd -r postgres \
 && useradd -r -d /var/lib/postgres -s /bin/false -g postgres postgres 

RUN pacman -S postgresql --noconfirm \
 && pacman -Scc --noconfirm

#RUN mkdir -p /run/postgresql \
# && chown postgres:postgres /run/postgresql

RUN mkdir /etc/initdb.d

ENV LANG en_US.UTF-8

ENV PGDATA /var/lib/postgres/data

VOLUME /var/lib/postgres/data

EXPOSE 5432

COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]

CMD ["postgres"]
