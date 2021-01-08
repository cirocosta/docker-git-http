#!/bin/bash

set -o errexit
#set -o xtrace

main() {
  init_docker_container
  sleep 3
  assert_can_clone
  assert_can_push
}

init_docker_container() {
  docker-compose -f ./example/docker-compose.yml up -d
}

separator() {
  echo '----------------------------------'
}

test_status() {
  separator
  echo $1
  separator
}

assert_can_clone() {
  test_status 'Testing git clone'
  git clone http://localhost:8080/myrepo.git
  [[ -f "myrepo/myfile.txt" ]] || exit 1

  test_status 'OK'
}


assert_can_push() {
  test_status 'Testing git push'
  git clone http://localhost:8080/myrepo.git || true

  cd myrepo
  touch anotherfile.txt
  git add .
  git commit -m 'Another file'
  git push
  cd ..
  test_status 'OK'
}

cleanup() {
  local exit_code=$?

  test_status "Exited with [$exit_code]"

  test_status "Cleaning...."
  docker-compose -f ./example/docker-compose.yml down
  rm -rf ./myrepo
}

trap cleanup EXIT
main
