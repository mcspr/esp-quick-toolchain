#!/usr/bin/env bash

# Repackage unpack.sh results after modifications
# Leave .json fragment management stuff for later

set -e -u -x

src="$1"
dst="$2"

hash="$3"
old_ver="$4"
new_ver="$5"

tool=xtensa-lx106-elf-gcc

for a in "$src"/* ; do
  pushd "$src"

  sed -i \
    -e "s/${old_ver}/${new_ver}/g" \
    -e "s/earlephilhower/mcspr/g" \
    "$a"/package.json

  base=$(basename "$a")
  if [[ "$base" =~ "Windows" ]] ; then
    cmd="zip -rq"
    ext=".zip"
  else
    cmd="tar czf"
    ext=".tar.gz"
  fi

  case "$base" in
  Darwin.64*) base="x86_64-apple-darwin14" ;;
  Linux.32*) base="i686-linux-gnu" ;;
  Linux.64*) base="x86_64-linux-gnu" ;;
  LinuxARM.32*) base="arm-linux-gnueabihf" ;;
  LinuxARM.64*) base="aarch64-linux-gnu" ;;
  Windows.32*) base="x86_64-w64-mingw32" ;;
  Windows.64*) base="i686-w64-mingw32" ;;
  *) echo "Unknown type $base" >&2; exit 1 ;;
  esac

  mv "$a" xtensa-lx106-elf
  $cmd "$dst"/"${base}.${tool}-${hash}.${new_ver}${ext}" xtensa-lx106-elf

  rm -r xtensa-lx106-elf

  popd
done
