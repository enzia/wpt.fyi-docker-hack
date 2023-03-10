#!/bin/bash

set -eou pipefail

docker build -t webplatformtests/wpt.fyi:latest .
