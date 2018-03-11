#!/bin/bash

script_dir=$(dirname "$0")
build_target="$1"
output_dir="$2"

if [[ -z "$build_target" ]] || [[ -z "$output_dir" ]]; then
    echo "Usage: $(basename "$0") :all|:preset|<package-name> <output-directory>"
    exit 1
fi

set -e

[[ -d "${output_dir}" ]] || mkdir -p "${output_dir}"

select_package() {
    local package="$1"
    local package_dir="${package##*/}"
    if ! [[ -d "${package_dir}" ]]; then
        "${script_dir}"/fetch-package.sh "${package}" "${package_dir}"
    elif [[ -n "$BRISE_UPDATE_PACKAGES" ]]; then
        (cd "${package_dir}"; git pull)
    fi
    local data_files=$(ls "${package_dir}"/*.* | grep -e '\.txt$' -e '\.yaml$')
    if [[ -z "${data_files}" ]]; then
        exit 1
    fi
    for data_file in ${data_files}; do
        cp "${data_file}" "${output_dir}"
    done
}

. "${script_dir}"/../package-list.conf

case "${build_target}" in
    :all|:preset)
        packages=$(eval echo \${${build_target#:}_packages[@]})
        ;;
    *)
        packages="${build_target}"
        ;;
esac

for package in ${packages}; do
    echo "Package: [${package}]"
    select_package "${package}"
done
