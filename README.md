My Docker image for [upsies](https://codeberg.org/plotski/upsies).

---

**Instructions**

- Bind your config directory to: `/app/upsies`
- Bind your media volume to somewhere, like `/data`, this can be ready-only
- Use docker `--user` to fix your permissions as the container runs rootless

**Examples:**

docker run
```
docker run -it --rm \
  --init \
  --network host \
  -u 99:100 \
  -v /mnt/appdata/docker/upsies:/app/upsies \
  -v /mnt/user/data:/data:ro \
  ghcr.io/fabricionaweb/docker-upsies:latest \
  help
```

**Alias**

The easiest way to use this image is having `upsies` alias on host so you don't
need to write full docker run command all the time.

Put the alias in the file `~/.bashrc` or `~/.zshrc` (depends on your shell).
Adjust it by your needs:

```
upsies() {
    docker run -it --rm \
        --init \
        --network host \
        -u 99:100 \
        -v /mnt/spool/appdata/docker/upsies:/app/upsies \
        -v /mnt/user/data:/data \
        ghcr.io/fabricionaweb/docker-upsies:latest \
        "$@";
}
```

Refresh it by closing/open the current shell session. Run `upsies help`
