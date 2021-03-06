load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def repositories():
    http_archive(
        name = "bazel_skylib",
        urls = ["https://github.com/bazelbuild/bazel-skylib/archive/1.0.2.tar.gz"],
        sha256 = "e5d90f0ec952883d56747b7604e2a15ee36e288bb556c3d0ed33e818a4d971f2",
        strip_prefix = "bazel-skylib-1.0.2",
    )

    io_bazel_rules_go_version = "0.23.5"
    io_bazel_rules_go_sha = "2d536797707dd1697441876b2e862c58839f975c8fc2f0f96636cbd428f45866"
    http_archive(
        name = "io_bazel_rules_go",
        sha256 = io_bazel_rules_go_sha,
        urls = [
            "https://mirror.bazel.build/github.com/bazelbuild/rules_go/releases/" +
            "download/v{0}/rules_go-v{0}.tar.gz".format(io_bazel_rules_go_version),
            "https://github.com/bazelbuild/rules_go/releases/" +
            "download/v{0}/rules_go-v{0}.tar.gz".format(io_bazel_rules_go_version),
        ],
    )
