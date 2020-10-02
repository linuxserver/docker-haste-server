FROM lsiobase/alpine:3.12

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="alex-phillips"

# set home dir for .npm directory
ENV HOME="/app"

RUN \
 echo "**** install build packages ****" && \
 apk add --no-cache \
	nodejs \
	npm && \
 apk add --no-cache --virtual=build-dependencies \
    curl && \
 echo "**** install haste-server ****" && \
 if [ -z ${HASTE_RELEASE+x} ]; then \
    HASTE_RELEASE=$(curl -sX GET https://api.github.com/repos/seejohnrun/haste-server/commits/master \
    | awk '/sha/{print $4;exit}' FS='[""]'); \
 fi && \
 curl -o \
	/tmp/haste-server.tar.gz -L \
    "https://github.com/seejohnrun/haste-server/archive/${HASTE_RELEASE}.tar.gz" && \
 mkdir -p \
    /app/haste-server && \
 tar xf \
    /tmp/haste-server.tar.gz -C \
    /app/haste-server --strip-components=1 && \
 cd /app/haste-server && \
 /usr/bin/npm install && \
 echo "**** cleanup ****" && \
 apk del --purge \
	build-dependencies && \
 rm -rf \
	/root/.cache \
	/tmp/*

# copy local files
COPY root/ /

# ports and volumes
EXPOSE 8000
