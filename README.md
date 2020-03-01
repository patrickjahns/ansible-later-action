# 🚀 Ansible Later for Github Action
[![License: MIT](https://img.shields.io/github/license/patrickjahns/ansible-later-action)](LICENSE)
![Test & Build & Release](https://github.com/patrickjahns/ansible-later-action/workflows/Test%20&%20Build%20&%20Release/badge.svg?event=release)
[![GitHub tag](https://img.shields.io/github/tag/patrickjahns/ansible-later-action.svg)](https://github.com/patrickjahns/ansible-later-action/tags)

[GitHub Action](https://github.com/features/actions) for linting ansible roles/playbooks with [ansible-later](https://github.com/xoxys/ansible-later)

## Usage

To use the action, create

```yaml
name: Ansible Later  # feel free to pick your own name
on: [push, pull_request]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    - name: run ansible-later action
      uses: patrickjahns/ansible-later-action@master
      with:
        config: .later.yml
        path: **/*.yml

```
### Variables

The following optional variables can be defined
- **config** (optional)

  Path to the [ansible-later configuration](https://ansible-later.geekdocs.de/configuration/defaults/) file to use.  If omitted, ansible-later will look for the default .later.yml file, or if not found, fallback to the inbuilt default configuration

- **path** (optional)

  The path of the files/folders to be inspected by ansible-later

  **examples:** 
    - lint all files in the folder `tasks`
    ```yaml
      path: tasks
    ```
    - lint all files ending with .yml in all subfolders 
    ```yaml
      path: **/*.yml 
    ```

  If omitted, ansible-later will try to lint all file in the working directory
## License
The Dockerfile and associated scripts and documentation in this project are released under the [MIT](LICENSE).
