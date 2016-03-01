# redis image

Dockerfile for redis on arch base image.

 [![redis](https://upload.wikimedia.org/wikipedia/en/thumb/6/6b/Redis_Logo.svg/320px-Redis_Logo.svg.png)](http://redis.io/)

Following adaptions were made compared to the [official redis image](https://hub.docker.com/_/redis/):
* Based on archlinux
* `redis` user has default shell `/bin/false`
* `entrypoint.sh` uses `su` instead of `gosu`
* Places `data` under `/var/lib/redis`

Current version is 3.0.7 (snapshot version 2016-02-26)

#### How to use this image

##### start a postgres instance
```bash
$ docker run --name some-redis -d redis
```
This image includes `EXPOSE 6379` (the redis port), so standard container linking will make it automatically available to the linked containers.

##### start with persistent storage
```bash
$ docker run --name some-redis -d redis redis-server --appendonly yes
```
If persistence is enabled, data is stored in the `VOLUME /var/lib/redis/data`.

For more about Redis Persistence, see http://redis.io/topics/persistence.

##### connect to it from an application
```bash
$ docker run --name some-app --link some-redis:redis -d application-that-uses-redis
```

##### ... or via `redis-cli`
```bash
$ docker run -it --link some-redis:redis --rm redis sh -c 'exec redis-cli -h "$REDIS_PORT_6379_TCP_ADDR" -p "$REDIS_PORT_6379_TCP_PORT"'
```

##### Additionally, If you want to use your own redis.conf ...
You can create your own Dockerfile that adds a redis.conf from the context.

```Dockerfile
FROM redis
COPY redis.conf /etc/redis.conf
CMD [ "redis-server", "/etc/redis.conf" ]
```

Alternatively, you can specify something along the same lines with `docker run` options.

```bash
$ docker run -v /myredis/conf/redis.conf:/etc/redis.conf --name myredis redis redis-server /etc/redis.conf
```

Where `/myredis/conf/` is a local directory containing your `redis.conf` file. Using this method means that there is no need for you to have a Dockerfile for your redis container.
