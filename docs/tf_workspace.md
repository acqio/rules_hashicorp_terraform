<a name="tf_workspace"></a>
# tf_workspace

This rule is responsible for creating a wrapper shell script needed to execute terraform commands.

The wrapper shell script [initializes a working directory](https://www.terraform.io/docs/cli/commands/init.html) containing the defining Terraform configuration files with a `tf_main` rule.

### Workspace

Each Terraform configuration has an associated [backend](https://www.terraform.io/docs/language/settings/backends/index.html) that defines how operations are executed and where persistent data such as the [Terraform state](https://www.terraform.io/docs/language/state/purpose.html) are stored.

When declaring a target of this type, a terraform workspace is created with the same name as the target.

By default the initialization of the backend is of the [local](https://www.terraform.io/docs/language/settings/backends/configuration.html#default-backend) type.
Therefore, this rule considers that the backend will be written in the same directory as `BUILD.bazel` that contains the target of type tf_workspace.

E.g.:

```python
# BUILD.bazel in ./example/ directory

tf_main(
    name = "main",
    srcs = glob([
        "main/**/*.tf",
        "main/**/*.tf.json",
    ]),
    data = glob(["**/*"]),
    modules = [
        "//examples/modules/foo",
    ],
)

tf_workspace(
    name = "dev",
    main = ":main",
    preserve_state = True
    var_file = "main/var.tfvars",
    vars = {
        "foo": "{STABLE_DATETIME}",
    },
)
```
The result after initialization will be something like:

```bash
examples/
├── BUILD.bazel
├── main
│   ├── main.tf
│   └── submodule
│       ├── file
│       └── main.tf
└── terraform.state.d
    └── dev
        ├── BUILD.bazel
        └── main.tf
```

### Using

The wrapper created by this rule, supports the following terraform commands:

* [apply](https://www.terraform.io/docs/cli/commands/apply.html)
* [destroy](https://www.terraform.io/docs/cli/commands/destroy.html)
* [import](https://www.terraform.io/docs/cli/commands/import.html)
* [output](https://www.terraform.io/docs/cli/commands/output.html)
* [plan](https://www.terraform.io/docs/cli/commands/plan.html)
* [refresh](https://www.terraform.io/docs/cli/commands/refresh.html)
* [graph](https://www.terraform.io/docs/cli/commands/graph.html) (default)

E.g.:
```bash
bazel run //path/to/target:target -- plan
```

It is also possible to specify arguments for a given command.
```bash
bazel run //path/to/target:target -- plan -parallelism=5 ...
```

<p>tf_workspace(<a href="#tf_workspace_name">name</a>, <a href="#tf_workspace_main">main</a>, <a href="#tf_workspace_preserve_state">preserve_state</a>, <a href="#tf_workspace_var_file">var_file</a>, <a href="#tf_workspace_vars">vars</a>)</p>

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
      <td style="text-align: left"><a id="tf_workspace_name"></a>name</td>
      <td style="text-align: left">A unique name for this target.</td>
      <td style="text-align: left"><a href="https://bazel.build/docs/build-ref.html#name">Name</a></td>
      <td style="text-align: left">required</td>
      <td style="text-align: left"> </td>
    </tr>
    <tr>
      <td style="text-align: left"><a id="tf_workspace_main"></a>main</td>
      <td style="text-align: left"> The <code>tf_main</code> target that declares the base code used to execute terraform commands.</td>
      <td style="text-align: left"><a href="https://bazel.build/docs/build-ref.html#labels">Label</a></td>
      <td style="text-align: left">required</td>
      <td style="text-align: left">None</td>
    </tr>
    <tr>
      <td style="text-align: left"><a id="tf_workspace_preserve_state"></a>preserve_state</td>
      <td style="text-align: left">Whether the desired status should be stored in the workspace of the bazel project.
      </br>The underlying files, such as terraform.state.backup, remain in the bazel cache only.</br>
      </td>
      <td style="text-align: left">Boolean</td>
      <td style="text-align: left">optional</td>
      <td style="text-align: left">True</td>
    </tr>
    <tr>
      <td style="text-align: left"><a id="tf_workspace_var_file"></a>var_file</td>
      <td style="text-align: left"><a href="https://www.terraform.io/docs/language/values/variables.html#variable-definitions-tfvars-files">A file with the values ​​for variables.</a> Its use is recommended for sensitive and/or different information by provisioning environment.</td>
      <td style="text-align: left"><a href="https://bazel.build/docs/build-ref.html#labels">Label</a></td>
      <td style="text-align: left">optional</td>
      <td style="text-align: left">None</td>
    </tr>
    <tr>
      <td style="text-align: left"><a id="tf_workspace_vars"></a>vars</td>
      <td style="text-align: left">Variables that will be passed directly to the <a href="https://www.terraform.io/docs/language/values/variables.html#variables-on-the-command-line">terraform command by command line</a>.
      <br>Subject to <a href="https://docs.bazel.build/versions/master/be/make-variables.html">make variable</a> and support to <a href="https://docs.bazel.build/versions/master/user-manual.html#workspace_status">stamp variables</a>.
      </br>
      </td>
      <td style="text-align: left">String dict</a></td>
      <td style="text-align: left">optional</td>
      <td style="text-align: left">{}</td>
    </tr>
  </tbody>
</table>
