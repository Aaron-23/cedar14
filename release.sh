#!/bin/bash
set -xe

image_name="cedar14"

trap 'clean_tmp; exit' QUIT TERM EXIT

function clean_tmp() {
  echo "clean temporary file..."
  [ -f Dockerfile.template ] && rm -rf Dockerfile.template
}


function release(){

  branch_name="master"
  release_ver="latest"
  
  git checkout master

  # get git describe info
  release_desc=master-`git rev-parse --short master`
  sed  "s/__RELEASE_DESC__/$release_desc/" Dockerfile > Dockerfile.template
  
  docker build -t hub.goodrain.com/dc-deploy/${image_name} -f Dockerfile.template .
  docker push hub.goodrain.com/dc-deploy/${image_name}
}

#=== main ===
release