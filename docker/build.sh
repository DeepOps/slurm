#!/usr/bin/env bash
set -ex

SLURM_VERSION=18.08.5-2
UBUNTU_CODENAMES='xenial bionic'
CENTOS_RELEASES='7'

NAME=slurm-build
DIST_DIR=./dist

for codename in $UBUNTU_CODENAMES
do
        docker build --pull -t "$NAME" \
                --file=./Dockerfile.ubuntu \
                --build-arg SLURM_VERSION="$SLURM_VERSION" \
                --build-arg UBUNTU_CODENAME="$codename" \
                .
        docker ps -q -a -f "name=$NAME" | xargs -r docker rm
        docker create --name="$NAME" "$NAME"
        rm -rf "$DIST_DIR"
        docker cp "${NAME}:/dist" "$DIST_DIR"
        docker rm "$NAME"
        cp "$DIST_DIR"/* .
done

for release in $CENTOS_RELEASES
do
        docker build --pull -t "$NAME" \
                --file=./Dockerfile.centos \
                --build-arg SLURM_VERSION="$SLURM_VERSION" \
                --build-arg CENTOS_RELEASE="$release" \
                .
        docker ps -q -a -f "name=$NAME" | xargs -r docker rm
        docker create --name="$NAME" "$NAME"
        rm -rf "$DIST_DIR"
        docker cp "${NAME}:/dist" "$DIST_DIR"
        docker rm "$NAME"
        cp "$DIST_DIR"/* .
done
