TerraformToolchainInfo = provider(
    doc = "Terraform toolchain rule parameters",
    fields = [
        "jq_tool_target",
        "tf_plugins_dir",
        "tf_terraformrc",
        "tf_tool_path",
        "tf_tool_target",
    ],
)

TerraformModule = provider(
    doc = "Terraform module rule parameters",
    fields = [
        "data",
        "srcs",
    ],
)

TerraformMain = provider(
    doc = "Terraform main rule parameters",
    fields = [
        "bazel_workdir",
        "data",
        "modules",
        "srcs",
        "statedir",
        "workdir",
    ],
)
