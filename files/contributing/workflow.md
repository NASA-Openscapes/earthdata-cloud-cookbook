---
title: Workflow
execute:
  eval: false
---

## Workflow for contributing to our Cookbook

Your Quarto workflow can be from the Command Line (bash), Python, or R. Its book chapters can be many file types, including `.md` , `.ipynb`, `.Rmd`, and `.qmd`. In all cases narrative and prose can be written in markdown, and chapters without code to execute can be written in `.md`. This workflow can streamline collaboration for scientific & technical writing across programming languages. 

:::{.callout-note}
In progress!  
:::


## GitHub Workflow

First let's talk about the GitHub part of the workflow. The main steps of working with GitHub are to pull, (work), stage, commit, (pull), and push. A great resource on GitHub setup and collaboration: <https://happygitwithr.com/> (R-focused but fantastic philosophy and bash commands for setup, workflows, and collaboration).

We're going to use branches and follow a shared workflow: create a branch, work in your branch and commit regularly, and push to github often. When you're ready, create a pull request and we'll merge it into the main branch. 

### Branch setup and workflow

Create a new branch, then switch to that branch to work in. Then, connect it to github.com by pushing it "upstream" to the "origin repository". `git checkout -b branch-name` is a 1-step approach for `git branch branch-name` `git checkout branch-name` (read [more](https://git-scm.com/book/en/v2/Git-Branching-Basic-Branching-and-Merging)). 

```{bash}
## create and switch to new branch
git checkout -b branch-name
```

Check which branch you're on anytime by not specifying a branch name:

```{bash}
git branch
```

Time for your Quarto workflow -- see below. Then when you're ready after you render the whole book, push back to GitHub. First you have to connect your branch to github.com (the "upstream origin") (`-u` below is short for `--set-upstream`)

```{bash}
## commit regularly as you work
git add --all 
git commit -m "my commit message here" 

## connect your branch to github.com and push
git push -u origin branch-name
```

Now it's on github, in a separate branch from main. You can go to <https://github.com/nasa-openscapes/quartobook-test> and do a pull request, and tag someone to review (depending on what you've done and what we've talked about).

TODO: Let's discuss this:

-   When the pull request is merged, delete the branch on github.com

-   Then also delete the branch locally:

```{bash}
git checkout main # switch to the main branch
git branch -d branch-hame
```

## Quarto Workflow

OK now we are setup and ready to work! The thing to do first is to "serve" (build) the book to make sure everything's working. (It's called "serve" because it's really a website that looks like a book).

The overall workflow will be to serve the book at the beginning, make edits and render your `.Rmd`/`.qmd` pages to view your edits as you go (`.md` are automatic) and then when you're ready to publish, you render the book with an additional command. Learn more about rendering here: <https://quarto.org/docs/computations/running-code.html#rendering>. From J.J. at RStudio:

> For `.Rmd` and `.qmd` files you need to render them (`.md` updates show on save because there is no render step). The reason Quarto doesn't render `.Rmd` and `.qmd` on save is that render could (potentially) be very long running and that cost shouldn't be imposed on you whenever you save.
>
> Here we are talking about the age old debate of whether computational markdown should be rendered on save when running a development server. Quarto currently doesn't do this to give the user a choice between an expensive render and a cheap save. See: <https://quarto.org/docs/websites/website-basics.html#workflow>.

The structure of the book is written in `_quarto.yml.` More description on this upcoming.

### Command Line/Python

To serve the book, run the following:

```{bash}
quarto serve
```

Paste the url from the console into your browser to see your updates.

Continue working, the `.md` files will refresh live! To refresh files with executable code, type:

```{bash}
quarto render jupyter-document.ipynb
```

To render and the whole book before publishing:

```{bash}
quarto render
```

### R

To the serve the book from R:

```{r}
quarto::quarto_serve()
```

Continue working, the `.md` files will refresh live! To refresh files with executable code, type:

```{r}
quarto::quarto_render("filename.ipynb")
```

To render and the whole book before publishing:

```{r}
quarto::quarto_render()
```

## Updating the environment

TODO!

From R: As we develop and add more package dependencies, re-run `renv::snapshot()` to update the environment. 


## If you're testing code

The workflow there would be that a user decides that they will be the only one who runs the notebook. Adding `execute: false` basically means that Quarto never runs the code, but the user of course still can interactively in Jupyter.
