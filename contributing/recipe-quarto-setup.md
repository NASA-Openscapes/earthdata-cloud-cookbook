---
title: "Create & Publish with Quarto (without R or Python)"
---

This is an intro workflow to set up and contribute to a Quarto book, originally from the GitHub browser. Originally created to help a colleague who is Deputy Director of an academic center to create open onboarding docs.

We'll create a copy of this book that you can edit yourself: <https://openscapes.github.io/quarto-site-template>

## Setup

### Download tempate site

1. Download <https://github.com/Openscapes/quarto-site-template> 
  1. Green button > Download ZIP
  1. On your computer: unzip files

### Create a GitHub repo 

### Add template site files

1. Add file > Upload files > Select all the files in unzipped folder > drag to GitHub
1. Commit

### Set up GitHub publishing

1. Add file > create new file > name it exactly `.github/workflows/quarto-render.yml`
1. Paste inside: 

``` yaml
name: Render and deploy quarto files
on: 
  push:
  pull_request:

jobs:
  quarto-render-and-deploy:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2

    - name: "Install Quarto and render project"
      uses: nasa-openscapes/quarto-render@v0.3.79 

    - name: "Deploy to gh-pages"
      uses: peaceiris/actions-gh-pages@v3
      if: github.ref == 'refs/heads/main'
      with:
        github_token: ${{ secrets.GITHUB_TOKEN }}
        publish_dir: ./_site
```

1. Create a branch called `gh-pages` - all lowercase, with a hyphen
1. (Don't need to 1. Settings > Pages > Source) bc it's automatic
1. Wait until orange dot turns green
1. Inspect: https://your-username/your-repo-name.github.io. For example: <https://openscapes.github.io/quarto-site-template>

## Edit

Now you can start editing. Start off from the browser, using Markdown. 

Then also, download RStudio IDE and set up to work locally.
