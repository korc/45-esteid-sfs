#!/bin/sh

set -e
. "$(dirname "$0")/.common.sh"

mkdir -p "$(dirname "$dpkg_status_save")"
cp /var/lib/dpkg/status "$dpkg_status_save"

mkdir -p "$deb_build_dir"

echo "deb [trusted=yes] file://$deb_build_dir ./" > /etc/apt/sources.list.d/lbu-deb.list
(cd "$deb_build_dir"; dpkg-scanpackages -m . >Packages)

lists_fname="$(echo "$deb_build_dir/./Packages" | tr / _)"
test -L "/var/lib/apt/lists/$lists_fname" ||
ln -vfs "$deb_build_dir"/Packages "/var/lib/apt/lists/$lists_fname"
