# GitHub Action to build and deploy a Hugo site to a remote repository 🚀

If you've ever wanted to keep your Hugo site source repository private, but deploy the site to your public GitHub Pages repository, you're in the right place.

This action cleans and rebuilds your [Hugo site](https://gohugo.io/), and pushes the new build to a remote repository you define.

It always uses the latest extended version from [Hugo releases](https://github.com/gohugoio/hugo/releases). The extended version [enables the processing](https://gohugo.io/troubleshooting/faq/#i-get-tocss--this-feature-is-not-available-in-your-current-hugo-version) of SCSS and Sass files to CSS.

Your site will build in the `DEST` directory you specify (Hugo's usual default is `public`). The contents of this directory will then be pushed to `master` of your remote public repository.

## Use this in your workflow

Here's how to use this action in your workflow file.

### 1. Add a Personal Access Token as a Secret called `TOKEN` in your repository

See [Creating a token](https://help.github.com/en/github/authenticating-to-github/creating-a-personal-access-token-for-the-command-line#creating-a-token) to set up a Personal Access Token. See [Creating and storing encrypted secrets](https://help.github.com/en/actions/configuring-and-managing-workflows/creating-and-storing-encrypted-secrets) for instructions to add this to your repository.

When you're finished, your repository's Secrets tab will look like this:

![Secrets tab showing saved TOKEN encrypted variable](secret.png)

### 2. Set your environment variables and add this action in a workflow

Here is an example workflow file that uses this action on any `push` event to the `master` branch:

```yml
name: hugo-remote

on:
  push:
    branches:
      - master

env:
  REMOTE: username/username.github.io.git
  DEST: public

jobs:
  build:

    runs-on: ubuntu-latest

    steps:
      - name: 🛎 Check out master
        uses: actions/checkout@master
        with:
          fetch-depth: 1
      - name: 🚀 Build and deploy
        uses: victoriadrake/hugo-remote@master
```

See full instructions for [Configuring and managing workflows](https://help.github.com/en/actions/configuring-and-managing-workflows).

## Use the workflow YAML file directly

If you prefer to place this action's YAML file in your repository directly, simply copy the included `hugo-remote.yml` into your repository's `.github/workflows/` directory.

For help editing the YAML file, see [Workflow syntax for GitHub Actions](https://help.github.com/en/actions/automating-your-workflow-with-github-actions/workflow-syntax-for-github-actions).
