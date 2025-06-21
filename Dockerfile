FROM public.ecr.aws/docker/library/alpine:3.21 AS base
ENV TZ=UTC TERM=xterm-256color

# dependencies
RUN apk add --no-cache --virtual=build-deps build-base python3-dev && \
    apk add --no-cache bash pipx tzdata ffmpeg mediainfo oxipng && \
    apk add mono libgdiplus -X https://dl-cdn.alpinelinux.org/alpine/edge/community

# copy the BDInfo binaries from the recommended docker image
COPY --from=zoffline/bdinfocli-ng /usr/src/app/build /bdinfo
# add "bdinfo" alias to $PATH
COPY --chmod=755 <<EOF /usr/local/bin/bdinfo
#!/bin/sh
mono /bdinfo/BDInfo.exe "\$@"
EOF

# install upsies
ARG VERSION
RUN pipx install upsies==$VERSION --global

# apply custom patch
COPY patches /opt/patches
RUN find /opt/patches -name "*.patch" -print0 | sort -z | \
        xargs -t -0 -n1 patch -d /opt/pipx/venvs/upsies/lib/python3.*/site-packages -p1 -i

# clean up dependencies
RUN apk del --purge build-deps

# drop permissions and set dirs
USER 1000:1000
ENV HOME=/app/upsies XDG_CONFIG_HOME=/app XDG_CACHE_HOME=/app/upsies/.cache

WORKDIR /app/upsies
VOLUME /app/upsies

COPY sleep.sh /usr/local/bin/
ENTRYPOINT ["upsies"]
