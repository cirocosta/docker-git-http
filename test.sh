#!/bin/bash

set -o errexit
#set -o xtrace


main() {
  ./wait-for-it.sh gitserver:80 -- echo 'gitserver is up'

  assert_can_clone
  assert_can_push
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
  git clone http://gitserver/myrepo.git
  [[ -f "myrepo/myfile.txt" ]] || exit 1

  test_status 'OK'
}


assert_can_push() {
  test_status 'Testing git push'
  git clone http://gitserver/myrepo.git || true

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
  rm -rf ./myrepo
}

trap cleanup EXIT
main
