#!/bin/bash

# Installs the latest docker and docker-compose releases
# according to the official apt repository.
# ps.:	it's required to be run as root

set -o errexit
set -o xtrace

main() {
  prepare_etc_hosts
  update_docker
}

prepare_etc_hosts() {
  echo "127.0.0.1 " $(hostname) | sudo tee -a /etc/hosts 2>&1 >/dev/null
}

update_docker() {
  sudo touch /etc/default/docker
  echo 'DOCKER_OPTS="-H unix:///var/run/docker.sock -H tcp://0.0.0.0:2375"' | sudo tee /etc/default/docker
  sudo apt-get update -y
  sudo apt-get install --only-upgrade docker-engine -y
  while ! docker info; do sleep 1; done
  docker swarm init
}

main
