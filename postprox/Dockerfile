FROM ubuntu:16.04
MAINTAINER Jean-Sebastien Legare

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -q --fix-missing && \
  apt-get -y upgrade && \
  apt-get -y install --no-install-recommends \
  	  build-essential \
  	  cdbs patchutils \
 	  debhelper && \
  mkdir -p /src /build

COPY target/mkdeb.sh /usr/local/bin/

ADD https://downloads.sourceforge.net/project/postprox/postprox/0.2.0/postprox-0.2.0.tar.gz /src

ENTRYPOINT ["/usr/local/bin/mkdeb.sh"]
