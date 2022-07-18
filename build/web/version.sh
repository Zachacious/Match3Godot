#!/bin/bash

versionFile="version.txt"
versionRegex="([0-9]+).([0-9]+).([0-9]+)"
version=""
major=""
minor=""
patch=""

# HELP
help()
{
    echo "Usage: setVersion.sh [-h] [-v] [-p] [-m] [-M]"
    echo "--help: Display this help message"
    echo "--version: See the version number"
    echo "--bump-patch: bump the minor version"
    echo "--bump-minor: bump the minor version"
    echo "--bump-major: bump the major version"

}

# MAIN
while IFS='' read -r line || [[ -n "$line" ]]; do
    if [[ $line =~ $versionRegex ]]; then
        version=$line
        major=${BASH_REMATCH[1]}
        minor=${BASH_REMATCH[2]}
        patch=${BASH_REMATCH[3]}
    fi
done < "$versionFile"

while getopts ":hvpmM" option; do
   case $option in
    h) # display Help
        help
        exit;;
    v) # see version
        echo $version
        exit;;
    p) # bump patch
        patch=$((patch+1))
        replacement="$major.$minor.$patch"
        packageReplacement="\"version\": \"$replacement\""
        sed -i.bak -E "s/$versionRegex/$replacement/" $versionFile
        exit;;
    m) # bump minor
        minor=$((minor+1))
        patch=0
        replacement="$major.$minor.$patch"
        packageReplacement="\"version\": \"$replacement\""
        sed -i.bak -E "s/$versionRegex/$replacement/" $versionFile
        exit;;
    M) # bump major
        major=$((major+1))
        minor=0
        patch=0
        replacement="$major.$minor.$patch"
        packageReplacement="\"version\": \"$replacement\""
        sed -i.bak -E "s/$versionRegex/$replacement/" $versionFile
        exit;;
    \?) # invalid option
        echo "Invalid option"
        help
        exit;;
   esac
done

exit 0