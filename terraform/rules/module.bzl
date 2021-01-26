load("//terraform/private:common/common.bzl", "common")
load("//terraform/private:common/helpers.bzl", "collect_files")
load("//terraform/private:providers.bzl", "TerraformModule")

def _impl(ctx):
    files = collect_files(ctx)
    tf_data = files.data
    tf_files = files.srcs

    return [
        TerraformModule(
            data = tf_data,
            srcs = tf_files,
        ),
    ]

tf_module = rule(
    attrs = {
        "data": attr.label_list(
            allow_files = True,
            default = [],
        ),
        "srcs": attr.label_list(
            allow_files = common.tf_file_ext,
            mandatory = True,
        ),
    },
    implementation = _impl,
)
