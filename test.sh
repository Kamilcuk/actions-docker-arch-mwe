#!/bin/bash
set -xeuo pipefail
docker run -ti --rm -v "$PWD":/mnt -w /mnt archlinux /mnt/run.sh

