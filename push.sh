#!/bin/bash -e
if [ "$IS_PULL_REQUEST" != true ]; then
  sudo docker push 680976004409.dkr.ecr.us-east-1.amazonaws.com/devimages:$BRANCH.$BUILD_NUMBER_$USER
else
  echo "skipping because it's a PR"
fi