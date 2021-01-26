<a name="tf_module"></a>
# tf_module

A rule for declare [terraform module](https://www.terraform.io/docs/language/modules/develop/index.html)

<p>tf_module(<a href="#tf_module_name">name</a>, <a href="#tf_module_data">data</a>, <a href="#tf_module_srcs">srcs</a>)</p>

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
      <td style="text-align: left"><a id="tf_module_name"></a>name</td>
      <td style="text-align: left">A unique name for this target.</td>
      <td style="text-align: left"><a href="https://bazel.build/docs/build-ref.html#name">Name</a></td>
      <td style="text-align: left">required</td>
      <td style="text-align: left"> </td>
    </tr>
    <tr>
      <td style="text-align: left"><a id="tf_module_data"></a>data</td>
      <td style="text-align: left">The list of files needed by this rule at runtime.</td>
      <td style="text-align: left"><a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a></td>
      <td style="text-align: left">optional</td>
      <td style="text-align: left">[]</td>
    </tr>
    <tr>
      <td style="text-align: left"><a id="tf_module_srcs"></a>srcs</td>
      <td style="text-align: left">The list of source files (<code>.tf</code> and/or <code>.tf.json</code>) that are processed to create the target.</td>
      <td style="text-align: left"><a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a></td>
      <td style="text-align: left">required</td>
      <td style="text-align: left"></td>
    </tr>
  </tbody>
</table>

## Examples

```python
# An example can be found under //example/modules/foo

load("@rules_hashicorp_terraform//terraform:defs.bzl", "tf_module")

tf_module(
    name = "foo",
    srcs = glob([
        "**/*.tf",
        "**/*.tf.json",
    ]),
    data = glob(["**/*"]),
)
```
