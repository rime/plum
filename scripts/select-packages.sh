#!/bin/bash

script_dir=$(dirname "$0")
root_dir=$(dirname "${script_dir}")
configuration="$1"
output_dir="$2"

if [[ -z "$configuration" ]] || [[ -z "$output_dir" ]]; then
    echo "Usage: $(basename "$0") :<configuration>|<package-name> <output-directory>"
    exit 1
fi

set -e

[[ -d "${output_dir}" ]] || mkdir -p "${output_dir}"

files_updated=0

select_package() {
    local package="$1"
    local repo_name="${package##*/}"
    local package_name="${repo_name#rime-}"
    local package_dir="${root_dir}/${package_name}"
    if ! [[ -d "${package_dir}" ]]; then
        "${script_dir}"/fetch-package.sh "${package}" "${package_dir}"
    elif [[ -n "$BRISE_UPDATE_PACKAGES" ]]; then
        (cd "${package_dir}"; git pull)
    fi
    local data_files=$(ls "${package_dir}"/*.* | grep -e '\.txt$' -e '\.yaml$')
    if [[ -z "${data_files}" ]]; then
        return
    fi
    for data_file in ${data_files}; do
        cp "${data_file}" "${output_dir}"
        ((++files_updated))
    done
}

case "${configuration}" in
    https://github.com/*/raw/*-packages.conf | https://raw.githubusercontent.com/*-packages.conf)
        curl -fLO "${configuration}"
        . $(basename "${configuration}")
        ;;
    *.conf)
        . "${configuration}"
        ;;
    :*)
        . "${root_dir}/${configuration#:}"-packages.conf
        ;;
    *)
        package_list=("${configuration}")
        ;;
esac

for package in ${package_list[@]}; do
    echo "Package: ${package}"
    select_package "${package}"
done

if [[ "${files_updated}" -eq 0 ]]; then
    echo 'No files updated.'
else
    echo "Updated ${files_updated} files from ${#package_list[@]} packages in '${output_dir}'"
fi
