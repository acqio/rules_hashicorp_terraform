"""
This BUILD file is auto-generated from toolchain/az/BUILD.bazel.tpl
"""

load("@rules_hashicorp_terraform//terraform/toolchain:toolchains.bzl", "tf_toolchain")

exports_files([
    "%{TF_SCRIPT_NAME}",
    "terraform",
])

tf_toolchain(
    name = "terraform_toolchain",
    jq_tool_target = "%{JQ_TOOL_TARGET}",
    tf_plugins_dir = "%{TF_PLUGIN_DIR}",
    tf_terraformrc = "%{TF_RC_TARGET}",
    tf_tool_path = "%{TF_TOOL_PATH}",
    tf_tool_target = "%{TF_TOOL_TARGET}",
    visibility = ["//visibility:public"],
)

sh_binary(
    name = "cli",
    srcs = ["%{TF_SCRIPT_NAME}"],
    data = ["%{TF_TOOL_TARGET}"],
    visibility = ["//visibility:public"],
)
