#!/usr/bin/env bash

export TF_CLI_ARGS="-no-color"
export TF_CLI_CONFIG_FILE="%{tf_config}"

jq_cli="%{jq_cli}"
tf_cli="%{tf_cli}"
tf_workdir="%{tf_workdir}"

INIT_OUTPUT=$(${tf_cli} init \
    -backend=false -get=true \
    -upgrade=false -verify-plugins=false \
    %{tf_providers_dir} ${tf_workdir} 2>&1>/dev/null);

EXIT_CODE=$?
EXPECTED_EXIT_CODE=0

if [ $EXIT_CODE -ne $EXPECTED_EXIT_CODE ] ; then
    echo "FAIL (exit code): Terraform initialization"
    echo "Expected: $EXPECTED_EXIT_CODE"
    echo "Actual: $EXIT_CODE"
    echo "Output: $INIT_OUTPUT"
    exit 1
else
    VALID_OUTPUT=$(${tf_cli} validate -json ${tf_workdir} 2>&1)
    if [ $(${jq_cli} .error_count <<< $VALID_OUTPUT) != 0 ]; then
        OUTPUT=$(${jq_cli} '.diagnostics[] | select (%{severity})' <<< $VALID_OUTPUT 2>&1)
        echo "FAIL (output mismatch): %{target_name}"
        echo "Output: $OUTPUT"
        exit 1
    fi
fi
