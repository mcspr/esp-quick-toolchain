#!/usr/bin/env bash

# Lazy retrieval of target package with minimal target info
# Upload & release clean-up happens later, its not necessary to retrieve either archiveName or system/host

set -e -u -x

dst="$1"

for system in Darwin Linux LinuxARM Windows ; do
  for bits in 32 64 ; do
    python get.py \
      --package-index-json package_esp8266com_index.template.json \
      --no-progress \
      --system "$system" \
      --platform "" \
      --bits "$bits" \
      --tool xtensa-lx106-elf
    if test -d xtensa-lx106-elf ; then
      case "${system}.${bits}" in
        Darwin.64) target="MACOSX86" ;;
        Linux.32) target="LINUX32" ;;
        Linux.64) target="LINUX64" ;;
        LinuxARM.32) target="RPI" ;;
        LinuxARM.64) target="ARM64" ;;
        Windows.32) target="WIN32" ;;
        Windows.64) target="WIN64" ;;
        *) echo "Unknown target $target" >&2; exit 1 ;;
      esac
      mkdir -p "$dst"/"pkg.${target}.toolchain"
      mv xtensa-lx106-elf "$dst"/"pkg.${target}.toolchain/"
    fi
  done
done
