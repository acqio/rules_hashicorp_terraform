load("//terraform/private:common/common.bzl", "common")
load("//terraform/private:common/utils.bzl", "utils")
load("//terraform/private:providers.bzl", "TerraformMain")
load("@bazel_skylib//lib:paths.bzl", "paths")
load("@bazel_skylib//lib:dicts.bzl", "dicts")

def _impl(ctx):
    toolchain_info = ctx.toolchains[common.tf_toolchain].info
    tf_main = ctx.attr.main[TerraformMain]

    tf_providers_dir = toolchain_info.tf_providers_dir
    tf_workdir = tf_main.workdir
    tf_ws_name = ctx.attr.name

    jq_cli = toolchain_info.jq_tool_target.files.to_list()[0]
    terraform_cli = toolchain_info.tf_tool_target.files.to_list()[0]
    terraformrc = toolchain_info.tf_terraformrc.files.to_list()[0]

    tpl_sub = {
        "%{tf_cli}": terraform_cli.path,
        "%{tf_config}": terraformrc.path,
        "%{tf_providers_dir}": "-plugin-dir %s" % tf_providers_dir,
        "%{tf_workdir}": tf_workdir,
        "%{tf_ws_name}": tf_ws_name,
    }

    transitive_files = []
    transitive_files += [terraform_cli, terraformrc]

    tf_state_arg = ""
    if ctx.attr.preserve_state:
        tf_state_arg = "-state={0}".format(
            paths.join(
                "$BUILD_WORKSPACE_DIRECTORY",
                paths.join(
                    paths.join(paths.dirname(ctx.build_file_path), "terraform.state.d"),
                    paths.join(tf_ws_name, "terraform.tfstate"),
                ),
            ),
        )

    tpl_sub = dicts.add(tpl_sub, {"%{tf_state}": tf_state_arg})

    tf_var_file_arg = ""
    if ctx.attr.var_file:
        transitive_files += [ctx.file.var_file]
        tf_var_file_arg = "-var-file={0}".format(ctx.file.var_file.path)
    tpl_sub = dicts.add(tpl_sub, {"%{tf_var_file}": tf_var_file_arg})

    tf_vars_arg = []
    for (key, value) in ctx.attr.vars.items():
        value = ctx.expand_make_variables("value", value, {})

        if utils.check_stamping_format(value):
            value_key_file = ctx.actions.declare_file(key + ".var.stamp")
            utils.resolve_stamp(ctx, value, value_key_file)
            value = "$(cat \"{0}\")".format(value_key_file.short_path)
            transitive_files.append(value_key_file)

        tf_vars_arg.append("-var {0}={1}".format(key, value))

    tpl_sub = dicts.add(tpl_sub, {"%{tf_vars}": "".join(tf_vars_arg)})

    ctx.actions.expand_template(
        is_executable = True,
        output = ctx.outputs.executable,
        substitutions = tpl_sub,
        template = ctx.file._template,
    )

    files = ctx.attr.main[DefaultInfo].files.to_list()
    transitive_files = depset(transitive_files)

    return [
        DefaultInfo(
            runfiles = ctx.runfiles(
                files = files,
                transitive_files = transitive_files,
            ),
        ),
    ]

tf_workspace = rule(
    attrs = {
        "_template": attr.label(
            default = Label("//terraform/rules:workspace.sh.tpl"),
            allow_single_file = True,
        ),
        "_stamper": attr.label(
            default = Label("//terraform/go/cmd/stamper"),
            executable = True,
            cfg = "host",
        ),
        "main": attr.label(
            providers = [TerraformMain],
            mandatory = True,
        ),
        "var_file": attr.label(
            allow_single_file = common.tf_var_file_ext,
        ),
        "vars": attr.string_dict(default = {}),
        "preserve_state": attr.bool(default = True),
    },
    executable = True,
    implementation = _impl,
    toolchains = [common.tf_toolchain],
)
