#!/usr/bin/env bash

# Repackage unpack.sh results after modifications
# Leave .json fragment management stuff for later

set -e -u

src="$1"
dst="$2"

old_ver="$3"
new_ver="$4"

for a in "$src"/* ; do
  pushd "$src"

  sed -i \
    -e "s/${old_ver}/${new_ver}/g" \
    -e "s/earlephilhower/mcspr/g" \
    "$a"/package.json

  if [[ "$a" =~ "Windows" ]] ; then
    cmd="zip -rq"
    ext=".zip"
  else
    cmd="tar czf"
    ext=".tar.gz"
  fi

  mv "$a" xtensa-lx106-elf
  $cmd "$dst"/"${a}-${new_ver}${ext}" xtensa-lx106-elf

  rm -r xtensa-lx106-elf
done
