#!/bin/bash

script_dir="$(dirname "$0")"
target="$1"
output_dir="$2"

option_no_update="${no_update:+1}"

source "${script_dir}"/bootstrap.sh
require 'styles'
require 'resolver'

if [[ -z "$target" ]] || [[ -z "$output_dir" ]]; then
    echo "Usage: $(basename "$0") :<configuration>|<package-name> <output-directory>"
    exit 1
fi

set -e

[[ -d "${output_dir}" ]] || mkdir -p "${output_dir}"

files_updated=0

install_package() {
    local user_name="$(resolve_user_name "$1")"
    local package_name="$(resolve_package_name "$1")"
    local branch="$(resolve_branch "$1")"
    local package="${1%@*}"
    local branch_label="${branch:+@${branch}}"
    local package_dir="${root_dir:-.}/package/${user_name}/${package_name}"
    if ! [[ -d "${package_dir}" ]]; then
        echo $(info 'Downloading package:') $(highlight "${package}") $(print_option "${branch_label}")
        local fetch_options=()
        if [[ -n "${branch}" ]]; then
            fetch_options+=(--branch "${branch}")
        fi
        "${script_dir}"/fetch-package.sh "${package}" "${package_dir}" "${fetch_options[@]}"
    else
        if [[ -z "${option_no_update}" ]]; then
            echo $(info 'Updating package:') $(highlight "${package}")
        else
            echo $(info 'Found package:') $(highlight "${package}")
        fi
        "${script_dir}"/update-package.sh "${package_dir}" "${branch}"
    fi
    install_files_from_package "${package_dir}"
}

install_files_from_package() {
    local package_dir="$1"
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
            echo $(info 'Installing:') $(print_item "${file_name}")
        elif ! diff -q "${data_file}" "${target_file}" &> /dev/null; then
            echo $(info 'Updating:') $(print_item "${file_name}")
        else
            continue
        fi
        cp "${data_file}" "${target_file}"
        ((++files_updated))
    done
}

load_package_list_from_target "${target}"

for package in "${package_list[@]}"; do
    install_package "${package}"
done

if [[ "${files_updated}" -eq 0 ]]; then
    echo $(print_result 'No files updated.')
else
    echo $(print_result "Updated ${files_updated} files " \
                        "from ${#package_list[@]} packages in") "'${output_dir}'"
fi
