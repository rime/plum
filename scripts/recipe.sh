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

    # TODO: assert recipe/Rx is same as ${recipe}
    # TODO: apply default values and check recipe/args

    # TODO: install_files

    patch_files
}

patch_files() {
    cat "${recipe_file}" |
        sed -n '/^patch_files:/,/^[^[:space:]#]/ {
            /^[^[:space:]#]/ !p
        }' | sed '{
            1 i\
            source '"'${script_dir}/bootstrap.sh'"'\
            require recipe\
            output_dir='"'${output_dir}'"'\
            package='"'${package}'"'\
            recipe='"'${recipe}'"'\
            recipe_options=(\
            \ \ \ \ '"${recipe_options[*]}"'\
            )\
            eval "${recipe_options[@]}"
            s/^[ ][ ]//
            s/^\([^[:space:]#]*\):\s*$/patch_file \1 <<EOF/
            2,$ {
                /<<EOF/ i\
                EOF
            }
            $ i\
            EOF
        }' | bash || (
        echo $(error 'Error:') "failed to patch files in recipe :${recipe}"
        exit 1
    )
}

escape_sed_text() {
    sed -e 's/[\\\/& ]/\\&/g; s/$/\\/'
}

patch_file() {
    local file_name="$1"
    echo $(info 'Patching:') $(print_item "${file_name}")
    local target_file="${output_dir:-.}/${file_name}"
    if ! [[ -e "${target_file}" ]] || ! grep -q '^__patch:$' "${target_file}"; then
        echo '__patch:' >> "${target_file}"
    fi
    local option_list="${recipe_options[*]}"
    local rx="${package}:${recipe}:${option_list// /,}"
    if grep -Fq "# Rx: ${rx}" "${target_file}"; then
        echo $(info 'Updating patch.')
        # first remove the existing patch
        sed '/^# Rx: '"${rx//\//\\\/}"' {$/,/^# }$/ d' "${target_file}" > "${target_file}.new" &&
            mv "${target_file}.new" "${target_file}"
    fi
    # read patch contents from standard input
    local patch_contents="$(escape_sed_text)"
    sed -E '
        /^__patch:$/,/^[^[:space:]#]/ {
            $ {
                /^__patch:|^[[:space:]#]/ {
                    a\
                        # Rx: '"${rx}"' {\
'"${patch_contents}"'
                        # }
                    q
                }
                i\
                    # Rx: '"${rx}"' {\
'"${patch_contents}"'
                    # }
            }
        }
    ' "${target_file}" > "${target_file}.new" &&
    mv "${target_file}.new" "${target_file}" || (
        echo $(error 'Error patching:') "${file_name}"
        exit 1
    )
}

provide 'recipe'
