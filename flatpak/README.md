# Flatpak Action

This action automates the manual steps needed to generate and publish a flatpak.
For more information on the overall flow of this ci image, take a look at the [elementary release process documentation](https://github.com/elementary/os/wiki/Release-Process).

## Requirements

This image is intended for use with elementary projects. There is one requirement before getting started:

  1. The project needs to have a directory called `flatpak` with a flatpak manifest inside. Docs: [flatpak docs](https://docs.flatpak.org/en/latest/first-build.html#add-a-manifest)

### Environment Variables

In order to create tags and push changes to various branches, the script needs a github token. Keep in mind, when using github workflows, the virtual environment [automatically comes with a generated github token secret](https://help.github.com/en/articles/virtual-environments-for-github-actions#github_token-secret).

### Specifying a label

By default, the examples check for a label called `Release` on the related pull request. This can be set in the workflow action by changing the following:

```yaml
# check for "Release" label:
true == contains(join(github.event.pull_request.labels.*.name), 'Release')
# check for "Example" label:
true == contains(join(github.event.pull_request.labels.*.name), 'Example')
```

### Git User

Instead of using the default github token (`GITHUB_TOKEN`), you can use a custom git user token with the `GIT_USER_TOKEN` environment variable. You can also use the following environment variables to set the git user & email:

```yaml
env:
  GIT_USER_TOKEN: "${{ secrets.GIT_USER_TOKEN }}"
  GIT_USER_NAME: "example-user"
  GIT_USER_EMAIL: "exampleuser@example.com"
```

## Example

```yaml
name: Release
on:
  pull_request:
    branches: master
    types: closed
jobs:
  release:
    runs-on: ubuntu-latest
    if: github.event.pull_request.merged == true && true == contains(join(github.event.pull_request.labels.*.name), 'Release')
    steps:
    - uses: actions/checkout@v1
    - uses: elementary/actions/flatpak@master
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```
