#!/bin/bash

require 'styles'

install_recipe() {
    local recipe_file="$1"
    if ! [[ -f "${recipe_file}" ]]; then
        echo $(error 'Recipe not found:') "${recipe_file}"
        exit 1
    fi

    echo $(info 'Installing recipe:') $(highlight ":${recipe}")
    for option in "${recipe_options[@]}"; do
        echo $(info '- option:') $(print_option "${option}")
    done

    # TODO: install_files

    # TODO: patch_files

}

provide 'recipe'
