<a name="tf_test"></a>
# tf_test

A rule for setup a simple execution of the [terraform validate](https://www.terraform.io/docs/cli/commands/validate.html) command.

It is thus primarily useful for general verification of reusable modules, including correctness of attribute names and value types.

NOTE: No remote backend will be initialized.

<p>tf_test(<a href="#tf_test_name">name</a>, <a href="#tf_test_ignore_warning">ignore_warning</a>, <a href="#tf_test_main">main</a>)</p>

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
      <td style="text-align: left"><a id="tf_test_name"></a>name</td>
      <td style="text-align: left">A unique name for this target.</td>
      <td style="text-align: left"><a href="https://bazel.build/docs/build-ref.html#name">Name</a></td>
      <td style="text-align: left">required</td>
      <td style="text-align: left"> </td>
    </tr>
    <tr>
      <td style="text-align: left"><a id="tf_test_ignore_warning"></a>ignore_warning</td>
      <td style="text-align: left">Whether warnings should be discarded and considered errors only.</td>
      <td style="text-align: left">Boolean</td>
      <td style="text-align: left">optional</td>
      <td style="text-align: left">True</td>
    </tr>
    <tr>
      <td style="text-align: left"><a id="tf_test_main"></a>main</td>
      <td style="text-align: left"> The <code>tf_main</code> target that declares the base code used to execute terraform validate.
</td>
      <td style="text-align: left"><a href="https://bazel.build/docs/build-ref.html#labels">Label</a></td>
      <td style="text-align: left">required</td>
      <td style="text-align: left">None</td>
    </tr>
  </tbody>
</table>

## Examples

```python
# An example can be found under //example/main

load("@rules_hashicorp_terraform//terraform:defs.bzl", "tf_test")

tf_test(
    name = "test",
    main = "//:main",
    ignore_warning = False
)
```
