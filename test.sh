#!/bin/bash
set -xeuo pipefail
docker run -ti --rm -v "$PWD":/mnt archlinux /mnt/run.sh

