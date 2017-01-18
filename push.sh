#!/bin/bash -e
if [ "$IS_PULL_REQUEST" != true ]; then
  sudo docker push $IMAGE_NAME:wwwdev.$BUILD_NUMBER
else
  echo "skipping because it's a PR"
fi