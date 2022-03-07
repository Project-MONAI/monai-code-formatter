# Python code formatter
This repo implements two options to format python code with Black using GitHub action.
The formatting changes are submitted back to the source branch (PR that triggered the action).

#### option 1 using a formatter workflow
It does not work for pull requests from forks due to a limitation of Github token's write permission.
##### Usage
```yaml
- uses: project-monai/monai-code-formatter@master
  with:
    # options to the auto formatter (Black)
    format_args:
    # email address used to write git commit
    email:
    # username used to write git commit
    username:
    # commit message
    message:
    # access token used to read and write the source branch
    token:
```

#### option 2 using the `repository_dispath` event
It is implemented by triggering the formatting process using the [slach command dispatch](https://github.com/marketplace/actions/slash-command-dispatch).
The workflow file is located at [`.github/workflows/format.yml`](https://github.com/Project-MONAI/monai-code-formatter/blob/master/.github/workflows/format.yml).

MONAI currently adopts this option as it supports both internal and external pull requests,
given that the contributors use the default PR setting -- 'Allow edits and access to secrets by maintainers'.

repo stats: https://monai.io/monai-code-formatter/Project-MONAI/MONAI/latest-report/report.html
