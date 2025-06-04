FROM public.ecr.aws/docker/library/alpine:3.21 AS base
ENV TZ=UTC TERM=xterm-256color

# dependencies
RUN apk add --no-cache --virtual=build-deps build-base python3-dev git && \
    apk add --no-cache bash pipx tzdata ffmpeg mediainfo oxipng

# install upsies
ARG VERSION
RUN pipx install 'git+https://codeberg.org/fabricionaweb/upsies.git' --global

# apply custom patch
COPY patches /opt/patches
RUN find /opt/patches -name "*.patch" -print0 | sort -z | \
        xargs -t -0 -n1 patch -d /opt/pipx/venvs/upsies/lib/python3.*/site-packages -p1 -i

# clean up dependencies
RUN apk del --purge build-deps

# drop permissions set dirs
USER 1000:1000
ENV HOME=/app/upsies XDG_CONFIG_HOME=/app XDG_CACHE_HOME=/app/upsies/.cache
WORKDIR /app/upsies
VOLUME /app/upsies

COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
