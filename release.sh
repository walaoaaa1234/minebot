#!/bin/bash
# Short script to create a release.

#base="$(dirname "$(realpath "$0")")"
#cd "$base"

tag=`git describe --exact-match --tags HEAD`

if ! [ $? -eq 0 ]; then
	echo "You should tag the current git version. Use git tag v1.2.3"
	tag=`git rev-parse --short HEAD`
fi

echo "Using version tag $tag"

mkdir -p releases/$tag || exit 1

for mod in Minebot AimBow; do
	echo "Starting to compile $mod ..."
	cd "./$mod"
	./gradlew build || exit 1
	cp "build/libs/$(ls -t1 build/libs/ | tail -n 1)" "./releases/$tag" || exit 1
done

echo "Packing release"
cd "./releases"
zip "$tag.zip" $tag/*


