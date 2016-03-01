FROM archlinux:2016-02-26

RUN groupadd -r redis \
 && useradd -r -d /var/lib/redis -s /bin/false -g redis redis

RUN pacman -S redis --noconfirm \
 && pacman -Scc --noconfirm

RUN mkdir -p /var/lib/redis/data \
 && chown redis:redis /var/lib/redis/data

VOLUME /var/lib/redis/data
WORKDIR /var/lib/redis/data

EXPOSE 6379

COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]

CMD ["redis-server"]
