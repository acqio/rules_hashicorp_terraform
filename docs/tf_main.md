<a name="tf_main"></a>
# tf_main

A rule for declare a Terraform main code that references modules and will be used to start provisioning.

<p>tf_main(<a href="#tf_main_name">name</a>, <a href="#tf_main_data">data</a>, <a href="#tf_main_modules">modules</a>, <a href="#tf_main_srcs">srcs</a>)</p>

<p><strong>ATTRIBUTES</strong></p>
<table>
  <thead>
    <tr>
      <th style="text-align: left">Name</th>
      <th style="text-align: left">Description</th>
      <th style="text-align: left">Type</th>
      <th style="text-align: left">Mandatory</th>
      <th style="text-align: left">Default</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="text-align: left"><a id="tf_main_name"></a>name</td>
      <td style="text-align: left">A unique name for this target.</td>
      <td style="text-align: left"><a href="https://bazel.build/docs/build-ref.html#name">Name</a></td>
      <td style="text-align: left">required</td>
      <td style="text-align: left"> </td>
    </tr>
    <tr>
      <td style="text-align: left"><a id="tf_main_data"></a>data</td>
      <td style="text-align: left">The list of files needed by this rule at runtime.</td>
      <td style="text-align: left"><a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a></td>
      <td style="text-align: left">optional</td>
      <td style="text-align: left">[]</td>
    </tr>
    <tr>
      <td style="text-align: left"><a id="tf_main_modules"></a>modules</td>
      <td style="text-align: left">
      The list of tf_modules target to be using as a <a href="https://www.terraform.io/docs/language/modules/sources.html#local-paths">local path</a> for Terraform Module.</td>
      <td style="text-align: left"><a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a></td>
      <td style="text-align: left">optional</td>
      <td style="text-align: left">[]</td>
    </tr>
    <tr>
      <td style="text-align: left"><a id="tf_main_srcs"></a>srcs</td>
      <td style="text-align: left">The list of source files (<code>.tf</code> and/or <code>.tf.json</code>) that are processed to create the target.</td>
      <td style="text-align: left"><a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a></td>
      <td style="text-align: left">required</td>
      <td style="text-align: left"></td>
    </tr>
  </tbody>
</table>

## Examples

```python
# An example can be found under //example/main

load("@rules_hashicorp_terraform//terraform:defs.bzl", "tf_main")

tf_main(
    name = "main",
    srcs = glob([
        "**/*.tf",
        "**/*.tf.json",
    ]),
    data = glob(["**/*"]),
    modules = [
        "//examples/modules/bar",
    ],
)
```
