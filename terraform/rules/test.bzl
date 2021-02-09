load("//terraform/private:common/common.bzl", "common")
load("//terraform/private:providers.bzl", "TerraformMain")

def _impl(ctx):
    toolchain_info = ctx.toolchains[common.tf_toolchain].info
    tf_main = ctx.attr.main[TerraformMain]

    tf_providers_dir = toolchain_info.tf_providers_dir
    tf_workdir = tf_main.workdir

    jq_cli = toolchain_info.jq_tool_target.files.to_list()[0]
    terraform_cli = toolchain_info.tf_tool_target.files.to_list()[0]
    terraformrc = toolchain_info.tf_terraformrc.files.to_list()[0]

    template_substitutions = {
        "%{severity}": ".severity==\"error\" {warning}".format(
            warning = "" if ctx.attr.ignore_warning else "or .severity==\"warning\"",
        ),
        "%{jq_cli}": jq_cli.path,
        "%{target_name}": ctx.attr.name,
        "%{tf_cli}": terraform_cli.path,
        "%{tf_config}": terraformrc.path,
        "%{tf_providers_dir}": "-plugin-dir %s" % tf_providers_dir,
        "%{tf_workdir}": tf_workdir,
    }

    ctx.actions.expand_template(
        is_executable = True,
        output = ctx.outputs.executable,
        template = ctx.file._template,
        substitutions = template_substitutions,
    )

    files = ctx.attr.main[DefaultInfo].files.to_list()
    transitive_files = depset([jq_cli, terraform_cli])

    return struct(
        runfiles = ctx.runfiles(
            files = files,
            transitive_files = transitive_files,
            collect_data = True,
        ),
    )

tf_test = rule(
    attrs = {
        "_template": attr.label(
            default = Label("//terraform/rules:test.sh.tpl"),
            allow_single_file = True,
        ),
        "main": attr.label(
            providers = [TerraformMain],
            mandatory = True,
        ),
        "ignore_warning": attr.bool(default = True),
    },
    executable = True,
    implementation = _impl,
    test = True,
    toolchains = [common.tf_toolchain],
)
