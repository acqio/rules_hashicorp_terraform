load("//terraform/private:common/common.bzl", "common")
load("//terraform/private:common/helpers.bzl", "collect_files")
load("//terraform/private:providers.bzl", "TerraformMain", "TerraformModule")
load("@bazel_skylib//lib:paths.bzl", "paths")

def _impl(ctx):
    tf_files = collect_files(ctx)
    tf_data = tf_files.data
    tf_sources = tf_files.srcs
    tf_modules = []

    for m in ctx.attr.modules:
        tf_modules += m[TerraformModule].srcs + m[TerraformModule].data
    bazel_workdir = paths.join("$BUILD_WORKSPACE_DIRECTORY", paths.dirname(tf_sources[0].short_path))

    return [
        TerraformMain(
            bazel_workdir = bazel_workdir,
            data = tf_data,
            modules = ctx.attr.modules,
            srcs = tf_sources,
            statedir = paths.join(bazel_workdir, "terraform.state.d"),
            workdir = paths.dirname(tf_sources[0].path),
        ),
        DefaultInfo(
            files = depset(tf_data + tf_sources + tf_modules),
        ),
    ]

tf_main = rule(
    attrs = {
        "data": attr.label_list(
            allow_files = True,
            default = [],
        ),
        "modules": attr.label_list(
            providers = [TerraformModule],
        ),
        "srcs": attr.label_list(
            allow_files = common.tf_file_ext,
            mandatory = True,
        ),
    },
    implementation = _impl,
)
