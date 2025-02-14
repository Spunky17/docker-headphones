# syntax=docker/dockerfile:1

FROM ghcr.io/linuxserver/baseimage-alpine:3.21

# set version label
ARG BUILD_DATE
ARG VERSION
ARG HEADPHONES_COMMIT
LABEL build_version="version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="Spunky17"
# hard set UTC in case the user does not define it
ENV TZ="Etc/UTC"

# copy patches folder
COPY patches/ /tmp/patches/

RUN \
  echo "**** install build packages ****" && \
  apk add --no-cache --virtual=build-dependencies \
    build-base && \
  echo "**** install runtime packages ****" && \
  apk add --no-cache \
    ffmpeg \
    flac \
    mc \
    git \
    python3 && \
  echo "**** build packages installed ****" && \
  echo "" && \
  echo "**** compile shntool ****" && \
  mkdir -p \
    /tmp/shntool && \
  tar xf /tmp/patches/shntool-3.0.10.tar.gz -C \
    /tmp/shntool --strip-components=1 && \
  cp /tmp/patches/config.* /tmp/shntool && \
  cd /tmp/shntool && \
  ./configure \
    --infodir=/usr/share/info \
    --localstatedir=/var \
    --mandir=/usr/share/man \
    --prefix=/usr \
    --sysconfdir=/etc && \
  make && \
  make install && \
  echo "**** shntool compiled ****" && \
  echo "" && \
  echo "**** install headphones ****" && \
  git clone --branch develop https://github.com/Spunky17/headphones.git /app/headphones && \
  echo "**** headphones installed ****" && \
  echo "" && \
  echo "**** cleanup ****" && \
  apk del --purge \
    build-dependencies && \
  rm -rf /tmp/* && \
  echo "**** cleaned up ****" && \
  echo ""

# add local files
COPY root/ /

# ports and volumes
EXPOSE 8181
VOLUME /config
