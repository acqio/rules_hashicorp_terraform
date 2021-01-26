load("//terraform/private:providers.bzl", "TerraformToolchainInfo")

def _impl(ctx):
    return [
        platform_common.ToolchainInfo(
            info = TerraformToolchainInfo(
                jq_tool_target = ctx.attr.jq_tool_target,
                tf_plugins_dir = ctx.attr.tf_plugins_dir,
                tf_terraformrc = ctx.attr.tf_terraformrc,
                tf_tool_path = ctx.attr.tf_tool_path,
                tf_tool_target = ctx.attr.tf_tool_target,
            ),
        ),
        platform_common.TemplateVariableInfo({
            "TF_PATH": str(ctx.attr.tf_tool_path),
        }),
    ]

tf_toolchain = rule(
    implementation = _impl,
    attrs = {
        "jq_tool_target": attr.label(
            executable = True,
            allow_files = True,
            mandatory = True,
            cfg = "host",
        ),
        "tf_plugins_dir": attr.string(
            mandatory = True,
        ),
        "tf_terraformrc": attr.label(
            allow_files = True,
            mandatory = True,
            cfg = "host",
        ),
        "tf_tool_path": attr.string(),
        "tf_tool_target": attr.label(
            executable = True,
            allow_files = True,
            mandatory = True,
            cfg = "host",
        ),
    },
)
