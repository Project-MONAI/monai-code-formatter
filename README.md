# Python code formatter with Black
This action formats the repository's python code with Black.
The formatting changes are submitted back to the source branch (PR that triggered the action).

## Usage
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
