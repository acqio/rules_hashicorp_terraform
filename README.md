# Hashicorp Terraform Rules for [Bazel](https://bazel.build)

## Overview

This repository contains rules for [Hashicrop Terraform](https://www.terraform.io/).

## Setup

Add the following to your WORKSPACE file:

```python
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "rules_hashicorp_terraform",
    urls = ["https://github.com/acqio/rules_hashicorp_terraform/archive/<revision>.tar.gz"],
    strip_prefix = "rules_hashicorp_terraform-<revision>",
    sha256 = "rules_hashicorp_terraform-<revision>",
)

load("@rules_hashicorp_terraform//terraform:repositories.bzl", terraform_repositories = "repositories")

terraform_repositories()

load("@rules_hashicorp_terraform//terraform:defs.bzl", "tf_dependencies", "tf_toolchains")

tf_dependencies()

tf_toolchains(
    settings = "//:settings.tf",
    # BEGIN OPTIONAL attrs
    repository = {
        "version": "0.13.6",
        "sha256": "55f2db00b05675026be9c898bdd3e8230ff0c5c78dd12d743ca38032092abfc9",
    },  # https://releases.hashicorp.com/terraform/
    # Optional parameters to command execute:(https://docs.bazel.build/versions/master/skylark/lib/repository_ctx.html#execute).
    quiet = True,
    timeout = 600,
    # Optional parameters to terraform init: https://www.terraform.io/docs/cli/commands/init.htm
    tf_upgrade = True,
    tf_verify_plugins = True,
    tf_log = "NONE",
    # END OPTIONS attrs

)
```

### Terraform settings

This file `settings.tf` or `settgins.tf.json` file at the root of your repository. Your content should be [Terraform settings](https://www.terraform.io/docs/language/settings/index.html).

Its purpose is to declare which minimum version of Terraform is compatible with its HCL code as well as which Providers (plugins) should be available for use.

The result of running this rule is the providers available in a directory named `.terraform` at the root of your repository. Therefore it is recommended to add this directory to your `.gitignore`.

E.g.
```hcl
terraform {
    # https://www.terraform.io/docs/language/expressions/version-constraints.html#version-constraint-syntax
    required_version = ">= 0.13.0"
    # https://www.terraform.io/docs/language/providers/requirements.html#requiring-providers
    required_providers {
        null = {
            source = "hashicorp/null"
            version = "3.0.0"
        }
    }
}
```
NOTE: Just consider declaring in this file settings referring to Terraform Provider as the minimum required version and providers (plugins) to use. Any other configuration may impact the correct functioning of this project and its rules.

## Simple usage

The rules_hashicorp_terraform target can be used as executables for custom actions or can be executed directly by Bazel. For example, you can run:
```python
bazel run @terraform//:cli -- -h
```

## Rules

* [tf_main](docs/tf_main.md)
* [tf_module](docs/tf_module.md)
* [tf_test](docs/tf_test.md)
* [tf_workspace](docs/tf_workspace.md)