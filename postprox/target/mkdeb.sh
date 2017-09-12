#!/bin/bash -ex

mkdir -p /tmp
tar -xzvf /src/postprox-0.2.0.tar.gz -C /tmp/
cd /tmp/postprox-0.2.0/
dpkg-buildpackage -us -uc

cd /tmp
mv postprox_0.2.0-1_amd64.deb /build/
chown --reference=/build/ /build/postprox_0.2.0-1_amd64.deb
