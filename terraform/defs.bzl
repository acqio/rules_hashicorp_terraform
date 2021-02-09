load("//terraform:dependencies.bzl", _tf_dependencies = "tf_dependencies")
load("//terraform/toolchain:configure.bzl", _tf_configure = "tf_configure")
load("//terraform/rules:main.bzl", _tf_main = "tf_main")
load("//terraform/rules:module.bzl", _tf_module = "tf_module")
load("//terraform/rules:test.bzl", _tf_test = "tf_test")
load("//terraform/rules:workspace.bzl", _tf_workspace = "tf_workspace")

tf_dependencies = _tf_dependencies

tf_configure = _tf_configure

tf_main = _tf_main
tf_module = _tf_module
tf_test = _tf_test
tf_workspace = _tf_workspace
