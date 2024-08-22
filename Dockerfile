FROM public.ecr.aws/docker/library/alpine:3.20 AS base
ENV TZ=UTC TERM=xterm-256color

# dependencies
RUN apk add --no-cache bash tzdata pipx ffmpeg mediainfo oxipng

# pipx configs
ENV PIPX_HOME=/app PIPX_BIN_DIR=/app/bin PIPX_MAN_DIR=/app/man
ENV PATH="$PATH:$PIPX_BIN_DIR"

# install upsies
ARG VERSION
RUN pipx install upsies==$VERSION

# drop permissions set dirs
USER 1000:1000
ENV HOME=/app/upsies XDG_CONFIG_HOME=/app
WORKDIR /app/upsies
VOLUME /app/upsies

COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
