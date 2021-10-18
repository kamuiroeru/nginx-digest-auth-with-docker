#!/bin/bash

docker buildx build --platform linux/amd64,linux/arm64 -t kamuiroeru/nginx-digest-auth-with-docker:latest --push .
docker push kamuiroeru/nginx-digest-auth-with-docker:latest