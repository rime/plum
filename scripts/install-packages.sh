#!/bin/bash

script_dir="$(dirname "$0")"
root_dir="$(dirname "${script_dir}")"
configuration="$1"
output_dir="$2"

source "${script_dir}/styles.sh"

if [[ -z "$configuration" ]] || [[ -z "$output_dir" ]]; then
    echo "Usage: $(basename "$0") :<configuration>|<package-name> <output-directory>"
    exit 1
fi

set -e

[[ -d "${output_dir}" ]] || mkdir -p "${output_dir}"

files_updated=0

install_package() {
    local package="$1"
    local repo_name="${package##*/}"
    local package_name="${repo_name#rime-}"
    local package_dir="${root_dir}/${package_name}"
    if ! [[ -d "${package_dir}" ]]; then
        echo $(info 'Downloading package:') $(highlight "${package}")
        "${script_dir}"/fetch-package.sh "${package}" "${package_dir}"
    elif [[ -z "${no_update:+1}" ]]; then
        echo $(info 'Updating package:') $(highlight "${package}")
        (cd "${package_dir}"; git pull)
    else
        echo $(info 'Found package:') $(highlight "${package}")
    fi
    local IFS=$'\r\n'
    local data_files=(
        $(ls "${package_dir}"/*.* | grep -e '\.txt$' -e '\.yaml$')
    )
    if [[ "${#data_files[@]}" -eq 0 ]]; then
        return
    fi
    local file_name
    local target_file
    for data_file in "${data_files[@]}"; do
        file_name="$(basename "${data_file}")"
        target_file="${output_dir}/${file_name}"
        if ! [ -e "${target_file}" ]; then
            echo $(info 'Installing:') $(strong "${file_name}")
        elif ! diff -q "${data_file}" "${target_file}" &> /dev/null; then
            echo $(info 'Updating:') $(strong "${file_name}")
        else
            continue
        fi
        cp "${data_file}" "${target_file}"
        ((++files_updated))
    done
}

case "${configuration}" in
    https://github.com/*/raw/*-packages.conf | https://raw.githubusercontent.com/*-packages.conf)
        curl -fLO "${configuration}"
        . "$(basename "${configuration}")"
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

for package in "${package_list[@]}"; do
    install_package "${package}"
done

if [[ "${files_updated}" -eq 0 ]]; then
    echo $(result 'No files updated.')
else
    echo $(result "Updated ${files_updated} files " \
                  "from ${#package_list[@]} packages in") "'${output_dir}'"
fi
