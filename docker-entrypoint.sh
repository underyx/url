#!/usr/bin/env bash
set -Eeuo pipefail

echo underyx/url
echo ===========
echo [`date -Iseconds`] downloading $1

curl -o script $1 2>/dev/null
chmod +x script

echo [`date -Iseconds`] ...and running it, also!
echo
echo your script
echo ===========

exec ./script ${@:2}
