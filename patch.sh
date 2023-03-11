#!/bin/bash

set -eou pipefail

WPT_REPO_PATH=$1

cat << EOF >> ${WPT_REPO_PATH}/util/commands.sh
function wptd_useradd() {
  docker exec -u 0:0 "\${DOCKER_INSTANCE}" addgroup -g $(id -g $USER) user || true
  # Add user to audio & video groups to ensure Chrome can use sandbox.
  docker exec -u 0:0 "\${DOCKER_INSTANCE}" adduser -u $(id -u $USER) -g $(id -g $USER) --disabled-password user
  docker exec -u 0:0 "\${DOCKER_INSTANCE}" addgroup user user || true
  docker exec -u 0:0 "\${DOCKER_INSTANCE}" addgroup user audio || true
  docker exec -u 0:0 "\${DOCKER_INSTANCE}" addgroup user video || true
  docker exec -u 0:0 "\${DOCKER_INSTANCE}" sh -c 'echo "user ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers'
}
EOF

