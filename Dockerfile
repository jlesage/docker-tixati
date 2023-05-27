#
# tixati Dockerfile
#
# https://github.com/jlesage/docker-tixati
#

# Docker image version is provided via build arg.
ARG DOCKER_IMAGE_VERSION=

# Define software versions.
ARG TIXATI_VERSION=3.19-1

# Define software download URLs.
ARG TIXATI_URL=https://download2.tixati.com/download/tixati-${TIXATI_VERSION}.x86_64.manualinstall.tar.gz

# Build Tixati.
FROM ubuntu:22.04 AS tixati
ARG TIXATI_URL
COPY src/tixati /build
RUN /build/build.sh "$TIXATI_URL"

# Pull base image.
FROM jlesage/baseimage-gui:alpine-3.18-v4.4.2

ARG TIXATI_VERSION
ARG DOCKER_IMAGE_VERSION

# Define working directory.
WORKDIR /tmp

# Generate and install favicons.
RUN \
    APP_ICON_URL=https://raw.githubusercontent.com/jlesage/docker-templates/master/jlesage/images/tixati-icon.png && \
    install_app_icon.sh "$APP_ICON_URL"

# Add files.
COPY rootfs/ /
COPY --from=tixati /tmp/tixati-rootfs /

# Set internal environment variables.
RUN \
    set-cont-env APP_NAME "Tixati" && \
    set-cont-env APP_VERSION "$TIXATI_VERSION" && \
    set-cont-env DOCKER_IMAGE_VERSION "$DOCKER_IMAGE_VERSION" && \
    true

# Define mountable directories.
VOLUME ["/output"]

# Expose ports.
#   - 17844/tcp: Incoming port for peer connections.
#   - 17844/udp: Incoming port for DHT functionality.
EXPOSE 17844/tcp
EXPOSE 17844/udp

# Metadata.
LABEL \
      org.label-schema.name="tixati" \
      org.label-schema.description="Docker container for Tixati" \
      org.label-schema.version="${DOCKER_IMAGE_VERSION:-unknown}" \
      org.label-schema.vcs-url="https://github.com/jlesage/docker-tixati" \
      org.label-schema.schema-version="1.0"
