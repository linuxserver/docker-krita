# syntax=docker/dockerfile:1

FROM ghcr.io/linuxserver/baseimage-selkies:debiantrixie

# set version label
ARG BUILD_DATE
ARG VERSION
ARG KRITA_VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="thelamer"

# title
ENV TITLE=Krita 

RUN \
  echo "**** add icon ****" && \
  curl -o \
    /usr/share/selkies/www/icon.png \
    https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/krita-logo.png && \
  echo "**** install packages ****" && \
  DOWNLOAD_URL=$(curl -sL https://download.kde.org/stable/krita/updates/Krita-Stable-x86_64.appimage.zsync \
    | awk '/URL: https/ {print $2}') && \
  curl -o \
    /tmp/krita.app -L \
    "${DOWNLOAD_URL}" && \
  cd /tmp && \
  chmod +x krita.app && \
  ./krita.app --appimage-extract && \
  mv \
    squashfs-root \
    /opt/krita && \
  ln -s \
    /opt/krita/AppRun \
    /usr/bin/krita && \
  echo "**** cleanup ****" && \
  rm -rf \
    /tmp/*

# add local files
COPY /root /

# ports and volumes
EXPOSE 3000

VOLUME /config
