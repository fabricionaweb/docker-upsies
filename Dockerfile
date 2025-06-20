FROM public.ecr.aws/docker/library/alpine:3.21 AS base
ENV TZ=UTC TERM=xterm-256color

# dependencies
RUN apk add --no-cache --virtual=build-deps build-base python3-dev git && \
    apk add --no-cache bash pipx tzdata curl ffmpeg mediainfo oxipng && \
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
RUN echo $VERSION && \
    pipx install 'git+https://codeberg.org/plotski/upsies.git@dev' --global

# clean up dependencies
RUN apk del --purge build-deps

# set dirs
ENV HOME=/app/upsies XDG_CONFIG_HOME=/app XDG_CACHE_HOME=/app/upsies/.cache

WORKDIR /app/upsies
VOLUME /app/upsies

# run
ENTRYPOINT ["upsies"]
