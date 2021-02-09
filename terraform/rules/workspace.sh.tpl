#!/usr/bin/env bash

set -euo pipefail

function help() {
    echo "Use any of the supported commands: apply|destroy|import|output|plan|refresh|graph"
    echo "E.g: bazel run //target:label -- {command}"
}

export TF_CLI_CONFIG_FILE="%{tf_config}"
export TF_CLI_ARGS="-no-color"

tf_action=${1:-"graph"}
tf_cli="%{tf_cli}"
tf_workdir="%{tf_workdir}"

${tf_cli} init -get=true -upgrade=false -verify-plugins=false %{tf_providers_dir} ${tf_workdir} 2>&1>/dev/null;

export TF_WORKSPACE="%{tf_ws_name}"

if  [[ ! "$(${tf_cli} workspace list ${tf_workdir} | grep -F $TF_WORKSPACE)" ]]; then
    ${tf_cli} workspace new $TF_WORKSPACE ${tf_workdir} 2>&1>/dev/null;
fi

if [[ "${tf_action}" =~ ^(apply|destroy|import|output|plan|refresh|graph)$ ]]; then
    declare -a tf_args

    if [[ "${tf_action}" =~ ^(apply|destroy|import|output|plan|refresh)$ ]]; then
        tf_args+=("%{tf_var_file}" "%{tf_state}" "%{tf_vars}")

        if [[ ! "${tf_action}" =~ ^(destroy|output)$ ]]; then
            tf_args+=("-input=false")
        fi
    fi

    tf_args+=(${@:2})

    ${tf_cli} ${tf_action} ${tf_args[@]} ${tf_workdir};
else
    help
fi
