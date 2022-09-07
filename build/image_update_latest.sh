#!/bin/bash

IMAGE=kamuiroeru/nginx-digest-auth-with-docker:latest
docker buildx build --platform linux/amd64,linux/arm64 -t $IMAGE --push .
