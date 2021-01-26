load("//terraform/private:common/common.bzl", "common")

def collect_files(ctx):
    srcs = ctx.files.srcs
    ext_exclude = (
        common.bazel_common_file_ext +
        common.tf_var_file_ext +
        common.tf_file_ext +
        common.tf_state_file_ext
    )

    data = []
    data += ctx.files.data
    for d in ctx.files.data:
        if True in [d.path.endswith(ext) for ext in ext_exclude] or (
            True in [True if dir_exclude in d.dirname else False for dir_exclude in common.tf_directories]
        ):
            data.remove(d)

    return struct(
        srcs = srcs,
        data = data,
    )
