FROM public.ecr.aws/docker/library/alpine:3.23
ENV TZ=UTC TERM=xterm-256color

# dependencies
RUN apk add --no-cache --virtual=build-deps build-base python3-dev git && \
    apk add --no-cache bash tzdata pipx ffmpeg mediainfo oxipng mono libgdiplus

# copy the BDInfo.exe binary from another docker image
# it doesnt worth trying to setup or rebuild this pre-historic code
COPY --from=zoffline/bdinfocli-ng /usr/src/app/build /bdinfo
# add "bdinfo" alias to $PATH
COPY --chmod=755 <<EOF /usr/local/bin/bdinfo
#!/bin/sh
mono /bdinfo/BDInfo.exe "\$@"
EOF

# install upsies from pypi
ARG VERSION
RUN pipx install upsies==$VERSION --global

# apply custom patch
COPY patches /opt/patches
RUN find /opt/patches -name "*.patch" -print0 | sort -z | \
        xargs -t -0 -n1 patch -d /opt/pipx/venvs/upsies/lib/python3.*/site-packages -p1 -i

# clean up dependencies
RUN apk del --purge build-deps

# set dirs
ENV HOME=/app/upsies XDG_CONFIG_HOME=/app XDG_CACHE_HOME=/app/upsies/.cache

WORKDIR /app/upsies
VOLUME /app/upsies

COPY sleep.sh /usr/local/bin/
ENTRYPOINT ["upsies"]
