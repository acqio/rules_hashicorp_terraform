workspace(
    name = "rules_hashicorp_terraform",
)

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "bazel_gazelle",
    sha256 = "cdb02a887a7187ea4d5a27452311a75ed8637379a1287d8eeb952138ea485f7d",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/bazel-gazelle/releases/" +
        "download/v0.21.1/bazel-gazelle-v0.21.1.tar.gz",
        "https://github.com/bazelbuild/bazel-gazelle/releases/" +
        "download/v0.21.1/bazel-gazelle-v0.21.1.tar.gz",
    ],
)

load("//terraform:repositories.bzl", terraform_repositories = "repositories")

terraform_repositories()

load("@bazel_gazelle//:deps.bzl", "gazelle_dependencies")

gazelle_dependencies()

load("//terraform:defs.bzl", "tf_dependencies", "tf_toolchains")

tf_dependencies()

tf_toolchains(
    quiet = False,
    settings = "//:settings.tf",
    # tf_log = "TRACE"
)
