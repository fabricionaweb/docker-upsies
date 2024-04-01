My Docker image for [upsies](https://codeberg.org/plotski/upsies).

---

**Instructions**

- Bind your config directory to: `/app/upsies`
- Bind your media volume to somewhere, like `/data`, this can be ready-only
- Use docker `--user` to fix your permissions as the container runs rootless

**Examples:**

docker run
```
docker run -d --name=upsies \
  -u 99:100 \
  -v /mnt/appdata/docker/upsies:/app/upsies \
  -v /mnt/user/data:/data:ro \
  ghcr.io/fabricionaweb/docker-upsies
```

compose
```
services:
  upsies:
    image: ghcr.io/fabricionaweb/docker-upsies
    user: 99:100
    volumes:
      - /mnt/appdata/docker/upsies:/app/upsies
      - /mnt/user/data:/data:ro
```

`upsies` does not have a daemon process, in order to keep the container alive its running a `sleep infinity` program.

While this is not the perfect solution, its what I have done to prevent recreating the container (passing the paths, permissions, etc) all the time.

After have the container running there is logs. That is fine. You just need to attach an internative shell and start use it: `docker exec -it upsies bash` (adjust `upsies` as the name of your container)

Inside the interative shell you can play with `upsies`. [Check upsies docs](https://upsies.readthedocs.io/en/stable/cli_reference.html)
