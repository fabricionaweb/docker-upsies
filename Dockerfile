FROM public.ecr.aws/docker/library/alpine:3.19 AS base
ENV TZ=UTC

# dependencies
RUN apk add --no-cache tzdata ffmpeg mediainfo oxipng pipx

# pipx configs
ENV PIPX_HOME=/app PIPX_BIN_DIR=/app/bin PIPX_MAN_DIR=/app/man
ENV PATH="$PATH:$PIPX_BIN_DIR"

# install upsies
ARG VERSION
RUN pipx install upsies==$VERSION

# drop permissions
USER 1000:1000

# set upsies config dir
ENV XDG_CONFIG_HOME=/app
WORKDIR /app/upsies
VOLUME /app/upsies

# keep container run with a fake program
ENTRYPOINT ["sleep", "infinity"]
