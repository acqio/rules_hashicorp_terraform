_BAZEL_COMMON_FILE_EXT = [".BUILD", ".WORKSPACE", ".bazel", ".bzl", "BUILD", "WORKSPACE"]
_TF_DIRECTORIES = [".terraform", "terraform.tfstate.d"]
_TF_FILE_EXT = [".tf", ".tf.json"]
_TF_STATE_FILE_EXT = [".tfstate", ".backup"]
_TF_TOOLCHAIN = "@rules_hashicorp_terraform//terraform/toolchain:toolchain_type"
_TF_VAR_FILE_EXT = [".tfvars", ".tfvars.json"]

common = struct(
    bazel_common_file_ext = _BAZEL_COMMON_FILE_EXT,
    tf_directories = _TF_DIRECTORIES,
    tf_file_ext = _TF_FILE_EXT,
    tf_var_file_ext = _TF_VAR_FILE_EXT,
    tf_state_file_ext = _TF_STATE_FILE_EXT,
    tf_toolchain = _TF_TOOLCHAIN,
)
