#!/bin/bash

s3tree() {
  if [ -z "$1" ]; then
    echo "Usage: s3tree <bucket-name> [prefix]"
    return 1
  fi

  BUCKET=$1
  PREFIX=$2

  if [ -n "$PREFIX" ]; then
    aws s3 ls "s3://$BUCKET/$PREFIX" --recursive | awk '{print $4}' | tree --fromfile
  else
    aws s3 ls "s3://$BUCKET" --recursive | awk '{print $4}' | tree --fromfile
  fi
}

