#!/bin/bash
#
# Fetch a Rime data package from GitHub
#

package_name="$1"
shift

if [[ -z "${package_name}" ]]; then
    echo "Usage: $(basename "$0") <package-name> [<directory>] [-b <branch>]"
    exit 1
fi

resolve_package_name() {
    local name="$1"
    if [[ ${name} =~ [^/]*/[^/]* ]]; then
        echo ${name}
    elif [[ ${name} =~ rime-[^/]* ]]; then
        echo rime/${name}
    else
        echo rime/rime-${name}
    fi
}

package_url="https://github.com/$(resolve_package_name "${package_name}").git"

git clone --depth 1 --shallow-submodules "${package_url}" "$@"
