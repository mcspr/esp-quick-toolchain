#!/usr/bin/env bash

# Lazy retrieval of target package with minimal target info
# Upload & release clean-up happens later, its not necessary to retrieve either archiveName or system/host

set -e -u

dst="$1"

for system in Darwin Linux LinuxARM Windows ; do
  for bits in 32 64 ; do
    python get.py \
      --package-index-json package_esp8266com_index.template.json \
      --system "$system" \
      --platform "" \
      --bits "$bits" \
      --tool xtensa-lx106-elf
    if test -d xtensa-lx106-elf ; then
      mv xtensa-lx106-elf "$dst"/"${system}.${bits}"
    fi
  done
done

popd
