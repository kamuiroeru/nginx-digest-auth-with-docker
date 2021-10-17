#!/bin/bash

docker build -t kamuiroeru/nginx-digest-auth-with-docker:latest .
docker push kamuiroeru/nginx-digest-auth-with-docker:latest