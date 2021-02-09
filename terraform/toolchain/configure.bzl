load("@bazel_skylib//lib:paths.bzl", "paths")
load("@bazel_skylib//lib:versions.bzl", "versions")

bazel_minimal_version = "3.3.0"
terraform_minimal_version = "0.14.0"

toolchains = {
    "linux": {
        "terraform": {
            "name": "terraform_linux",
            "toolchain_name": "terraform_linux",
            "arch": "amd64",
            "host": "linux",
            "version": "0.14.0",
            "sha": "07fd7173f7a360ad5e4d5ea5035670cf426cf7a08d0486bc0fe7c9d76b447722",
        },
        "jq": {
            "name": "jq",
            "arch": "linux64",
            "version": "1.6",
            "sha": "af986793a515d500ab2d35f8d2aecd656e764504b789b66d7e1a0b727a124c44",
        },
    },
    "osx": {
        "terraform": {
            "name": "terraform_osx",
            "toolchain_name": "terraform_osx",
            "arch": "amd64",
            "host": "darwin",
            "version": "0.14.0",
            "sha": "126e1c9e058f12c247a194db5a9567e59ec755cbc0211cd5d58c8b7d37412b2c",
        },
        "jq": {
            "name": "jq",
            "arch": "osx-amd64",
            "version": "1.6",
            "sha": "5c0a0a3ea600f302ee458b30317425dd9632d1ad8882259fcaf4e9b868b2b1ef",
        },
    },
}

_GENERIC_TF_CLI_SHELL = """\
#!/usr/bin/env bash
# Immediately exit if any command fails.
set -euo pipefail

%{TF_TOOL_PATH} $@
"""

_GENERIC_TF_CONFIG_FILE = """\
provider_installation {
  filesystem_mirror {
    path    = "%{MIRROR_PROVIDERS_DIR}"
    include = ["*/*/*"]
  }
}
"""

def _check_version(tool, minimal_version, version):
    if not versions.is_at_least(minimal_version, version):
        fail(
            """{0} versions do not match.
Expected: >= {1}
Atual: {2}""".format(tool, minimal_version, version),
        )
    return

def _get_terraform(rctx, toolchain, filename, tool_path):
    version = toolchain["version"]
    sha = toolchain["sha"]
    if rctx.attr.repository:
        if "version" in rctx.attr.repository.keys() and "sha256" in rctx.attr.repository.keys():
            version = rctx.attr.repository["version"]
            sha = rctx.attr.repository["sha256"]
            _check_version("Terraform", terraform_minimal_version, version)
        else:
            fail("""The keys: version and sha256 are mandatory.
Define the repository string_dict E.g:
repository = {
    "version": "XX.YY.ZZ",
    "sha256": "..."
}""")

    # https://releases.hashicorp.com/terraform/XX.YY.ZZ/terraform_XX.YY.ZZ_OS_ARCH.zip
    rctx.download_and_extract(
        url = "{h_url}/terraform/{version}/terraform_{version}_{os}_{arch}.zip".format(
            h_url = "https://releases.hashicorp.com",
            version = version,
            os = toolchain["host"],
            arch = toolchain["arch"],
        ),
        sha256 = sha,
        type = "zip",
    )

    rctx.file(
        filename,
        content = _GENERIC_TF_CLI_SHELL.replace("%{TF_TOOL_PATH}", tool_path),
        executable = True,
    )

def _get_jq(rctx, toolchain):
    rctx.download(
        url = "https://github.com/stedolan/jq/releases/download/jq-{version}/jq-{arch}".format(
            version = toolchain["version"],
            arch = toolchain["arch"],
        ),
        sha256 = toolchain["sha"],
        output = "jq",
        executable = True,
    )

def _tf_init(rctx, settings_path, settings_symlink_path, plugins_dir, tf_cli, tf_rc_filename):
    rctx.symlink(settings_path, paths.join(settings_symlink_path, settings_path.basename))

    environment = dict()
    if rctx.attr.tf_log != "NONE":
        environment["TF_LOG"] = rctx.attr.tf_log

    result = rctx.execute(
        [
            tf_cli,
            "init",
            "-backend=false",
            "-get=false",
            "-get-plugins=true",
            "-no-color",
            "-upgrade={0}".format(str(rctx.attr.tf_upgrade).lower()),
            "-verify-plugins={0}".format(str(rctx.attr.tf_verify_plugins).lower()),
        ],
        quiet = rctx.attr.quiet,
        environment = environment,
        timeout = rctx.attr.timeout,
        working_directory = settings_symlink_path,
    )

    if result.return_code:
        fail("terraform_init failed: %s (%s)" % (result.stdout, result.stderr))

    # https://www.terraform.io/docs/commands/cli-config.html#provider-installation

    plugins_dir = paths.join(settings_symlink_path, ".terraform/plugins")
    rctx.file(
        tf_rc_filename,
        _GENERIC_TF_CONFIG_FILE.replace("%{MIRROR_PROVIDERS_DIR}", plugins_dir),
        executable = False,
    )

def _impl(rctx):
    _check_version("Bazel", bazel_minimal_version, versions.get())

    tf_toolchain = {}
    jq_toolchain = {}
    if rctx.os.name == "linux":
        tf_toolchain = toolchains["linux"]["terraform"]
        jq_toolchain = toolchains["linux"]["jq"]
    elif rctx.os.name == "mac os x":
        tf_toolchain = toolchains["osx"]["terraform"]
        jq_toolchain = toolchains["osx"]["jq"]
    else:
        fail("Unsupported operating system: " + rctx.os.name)

    settings_path = rctx.path(rctx.attr.settings)
    settings_symlink_path = paths.join(str(rctx.path(rctx.attr.name).dirname), "settings")

    tf_cli_filename = "terraform.sh"
    tf_providers_dir = paths.join(settings_symlink_path, ".terraform/providers")
    tf_rc_filename = ".terraformrc"
    tf_tool_path = str(rctx.path("terraform"))

    rctx.template(
        "BUILD.bazel",
        Label("@rules_hashicorp_terraform//terraform/toolchain:BUILD.bazel.tpl"),
        {
            "%{JQ_TOOL_TARGET}": "@{0}//:{1}".format(rctx.name, "jq"),
            "%{TF_SCRIPT_NAME}": tf_cli_filename,
            "%{TF_RC_FILENAME}": tf_rc_filename,
            "%{TF_PROVIDERS_DIR}": tf_providers_dir,
            "%{TF_RC_TARGET}": "@{0}//:{1}".format(rctx.name, tf_rc_filename),
            "%{TF_TOOL_PATH}": tf_tool_path,
            "%{TF_TOOL_TARGET}": "@{0}//:{1}".format(rctx.name, "terraform"),
        },
        False,
    )

    _get_terraform(rctx, tf_toolchain, tf_cli_filename, tf_tool_path)
    _get_jq(rctx, jq_toolchain)
    _tf_init(rctx, settings_path, settings_symlink_path, tf_providers_dir, tf_tool_path, tf_rc_filename)

_tf_configure = repository_rule(
    implementation = _impl,
    attrs = {
        "settings": attr.label(
            mandatory = True,
            allow_single_file = [".tf", ".tf.json"],
            cfg = "target",
        ),
        "quiet": attr.bool(
            default = True,
            doc = "If True, suppress printing stdout and stderr output to the terminal.",
        ),
        "repository": attr.string_dict(),
        "timeout": attr.int(
            default = 600,
            doc = "Timeout (in seconds) on the rule's execution duration.",
        ),
        "tf_upgrade": attr.bool(
            default = False,
        ),
        "tf_verify_plugins": attr.bool(
            default = True,
        ),
        "tf_log": attr.string(
            default = "NONE",
            values = ["NONE", "TRACE", "DEBUG", "INFO", "WARN", "ERROR"],
        ),
    },
)

def setup_toolchains():
    for name, toolchain in toolchains.items():
        native.register_toolchains("@rules_hashicorp_terraform//terraform/toolchain:{0}".format(
            toolchain["terraform"]["toolchain_name"],
        ))

def tf_configure(**kwargs):
    _tf_configure(
        name = "terraform",
        **kwargs
    )
    setup_toolchains()
