#!/bin/bash
set -xe

DIR="$( cd "$( dirname "$BASH_SOURCE" )" && pwd )"
PROJECT_DIR=$DIR/../..

DOCKER_IMAGE_NAME=`cat "$PROJECT_DIR"/ci/docker/docker-image.name`
OUR_DOCKER_REGISTRY="dockreg.onl.by:5000"

if docker pull $OUR_DOCKER_REGISTRY/$DOCKER_IMAGE_NAME ; then
    echo "Docker image with sam tag already exists in docker registry $OUR_DOCKER_REGISTRY"
    echo "Skipping build step of the image"
else
    echo "Building docker image"
    cp "$PROJECT_DIR"/ci/docker/Dockerfile "$PROJECT_DIR"/Dockerfile && docker build -t $DOCKER_IMAGE_NAME "$PROJECT_DIR"/ && rm "$PROJECT_DIR"/Dockerfile || rm "$PROJECT_DIR"/Dockerfile
    docker tag $DOCKER_IMAGE_NAME $OUR_DOCKER_REGISTRY/$DOCKER_IMAGE_NAME
    docker push $OUR_DOCKER_REGISTRY/$DOCKER_IMAGE_NAME
fi
