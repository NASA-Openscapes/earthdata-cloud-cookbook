---
title: Workflow
execute: false
---

## Workflow for contributing to our Cookbook

Your Quarto workflow can be from the Command Line, Python, or R. You are able to work on Cookbook chapters that can be different file types, including `.md` , `.ipynb`, `.Rmd`, and `.qmd`. In all cases narrative and prose can be written in markdown, and chapters without code to execute can be written in `.md`. This workflow can streamline collaboration for scientific & technical writing across programming languages.

## GitHub Workflow

First let's talk about the GitHub part of the workflow.

We will work in branches so as to not overwrite each other's work, and let GitHub do what it does best.

The `main` branch will be the current approved version of the book. The main branch is what displays at <https://nasa-openscapes.github.io/earthdata-cloud-cookbook>.

A nice clean workflow with branches is to consider them temporary. You pull the most recent from `main`, you create a branch locally, you make your edits, you commit regularly, then you push back to github.com, create a pull request for it to be merged into `main`, and once approved, you delete the branch on github.com and also locally. That's the workflow we'll walk through here. A great resource on GitHub setup and collaboration is [Happy Git with R](https://happygitwithr.com/), which includes fantastic background philosophy as well as bash commands for setup, workflows, and collaboration.

The following assumes you're all [setup](files/contributing/setup) from the previous chapter.

### Branch setup

First off, check what branch you're on and pull the most recent edits from the main branch. If you need to switch branches, use `git checkout`.

``` {.bash}
git branch          # returns all local branches
git checkout main   # switch branch to main
git pull            # pull most recent edits from the main branch
```

If you are already on the `main` branch, Git will tell you.

(If you have any residual branches from before, you'll likely want to start off by deleting them --- assuming they were temporary and have been merged into github.com. You can delete a branch with `git branch -d branch-name`).

Next, create a new branch, then switch to that branch to work in. Below is a one-step approach for the two-step process of `git branch branch-name` then `git checkout branch-name` (read [more](https://git-scm.com/book/en/v2/Git-Branching-Basic-Branching-and-Merging)).

``` {.bash}
git checkout -b branch-name  # create and switch to new branch
```

Time for your Quarto workflow -- see below. After you've made edits and served with Quarto, you'll commit your changes.

### Commit changes

You'll commit your work regularly as you go, writing commit messages:

``` {.bash}
git add --all 
git commit -m "my commit message here" 
```

### Push changes

When you're ready to push changes you've made in your branch, you'll first need to connect it to github.com by pushing it "upstream" to the "origin repository" (`-u` below is short for `--set-upstream`):

``` {.bash}
git push -u origin branch-name  # connect your branch to github.com and push
```

### Pull Request

Now that you've synced your work to github.com. It is currently online, in a separate branch from the `main` branch. Go to [<https://github.com/nasa-openscapes/earthdata-cloud-cookbook>](https://github.com/nasa-openscapes/earthdata-cloud-cookbook){.uri}, find your branch, and do a pull request, and tag someone to review (depending on what you've done and what we've talked about).

TODO: Let's discuss this:

-   When the pull request is merged, delete the branch on github.com

Once your pull request is merged, you can delete the branch from github.com (it suggests this as a button).

Then also come back to your local setup and delete the branch locally:

``` {.bash}
git checkout main # switch to the main branch
git branch -d branch-hame
```

## Quarto Workflow

Now the fun part! The thing to do first is to "serve" the Cookbook so that we can see what it looks like as we develop the chapters (it's called "serve" because it's really a website that looks like a book).

Our overall workflow will be to serve the book at the beginning, develop/edit chapters as simple text files (`.md`/`.qmd`/`.Rmd`), which will make it easier for us to collaborate. We can convert files between formats as we wish; for example converting an existing `.ipynb` to text files for development or from text files to `.ipynb` files for workshops. (See `quarto convert help` for details.)

As you save your work, `.md`s will automatically refresh with your updates. Other file types will need to be rendered first; see more below.

As you work, you'll follow our GitHub workflow above, committing regularly. And you can optionally use quarto to render the whole Cookbook before pushing to github.com.

The following is how to run Quarto from the command line; see [https://quarto.org](https://quarto.org/docs/getting-started/quarto-basics.html) to see equivalents in R.

### Quarto serve

Run the following from your branch in your `earthdata-cloud-cookbook` directory.

To serve the book from the command line:

``` {.bash}
quarto serve
```

And after it's is served, you can paste the url into your browser or click from the console to see the built Cookbook.

This command line instance is now being used to serve Quarto. You can open another instance to continue working from the command line, including developing content and rendering (see next).

### Develop Cookbook Content

You can develop Cookbook chapters as text files (`.md`/`.qmd`/`.Rmd`) in the text editor of your choice. You can also develop chapters as `.ipynb` from JupyterLab (see more about [JupyterLab with Quarto](https://quarto.org/docs/computations/using-jupyter-lab.html)).

#### RStudio IDE & Visual Editor

You can also use the RStudio IDE. It can be used as a simple text editor, but it can also interactively execute code in `.qmd` and `.Rmd` files, which streamlines testing as we develop content. The RStudio IDE Visual Editor makes this experience feel like a cross between an interactive notebook and a Google Doc.

![The RStudio IDE Visual Editor with an interactive .qmd file](/files/contributing/images/rstudio-visual-editor-qmd.png)

Another benefit of the RStudio IDE is that it has a docked command line (Terminal, bottom left), file navigation (bottom right) and GitHub interface (top right). This helps keep things organized as you work. The image shows the second Terminal; the first is being used to serve Quarto.

### Quarto render

As you develop book chapters and edit files, any `.md` files will automatically refresh in the browser (so long as quarto serve is running)!

To refresh files with executable code, you'll need to render them individually. You can do the following to render `.ipynb`/`.qmd`/`.Rmd` files so that they show up refreshed in the served Cookbook.

``` {.bash}
quarto render my-document.ipynb      ## render a notebook
quarto render my-work.qmd            ## render a Quarto file
quarto render my-contribution.Rmd    ## render a RMarkdown file
```

You can also render the whole book:

``` {.bash}
quarto render
```

Learn more about [rendering with Quarto](https://quarto.org/docs/computations/running-code.html#rendering). From J.J. Allaire:

> The reason Quarto doesn't render `.Rmd` and `.qmd` on save is that render could (potentially) be very long running and that cost shouldn't be imposed on you whenever you save. Here we are talking about the age old debate of whether computational markdown should be rendered on save when running a development server. Quarto currently doesn't do this to give the user a choice between an expensive render and a cheap save.

## Updating the Environment

To make your work reproducible as you load any Python or R packages, you'll need to update the `environments.txt` file. Do this use the `pip freeze` command:

``` {.bash}
pip freeze > requirements.txt
```

This will overwrite/update the `requirements.txt` file, which you will then commit and push along with your other edits back to github.com.

## Cookbook Structure

Each chapter in our Cookbook is a separate file (`.md`/ `.ipynb`/`.qmd`/`.Rmd`). These are stored in our `files` directory, organized by sub-directory.

The Cookbook structure (i.e. the order of sections and chapters) is determined in the `_quarto.yml` file in the root directory. We can shuffle chapter order by editing the `_quarto.yml` file, and and add new chapters by adding to the `_quarto.yml` and creating a new file in the appropriate sub-directory that is indicated in `_quarto.yml`.

We can change chapter order and subsections as we continue to develop the Cookbook, nothing is set in stone.

## Cookbook Practices

These are shared practices that we have for co-developing the Cookbook:

### Executing notebooks

As you develop files with executable code ( `.qmd`, `.Rmd`, and `.ipynb`), you can decide if you don't want the notebook to execute. By adding YAML as a raw text cell at the top of an `.ipynb` file, you can control whether it is executed or not. Adding `execute: false` to the YAML at the top of the file basically means that Quarto never runs the code, but the user of course still can interactively in Jupyter.

Using `.qmd` there are also ways to control execution cell-by-cell via `# |` syntax within a code chunk; see <https://quarto.org/docs/computations/execution-options.html>

## Troubleshooting

### Error: AddrInUse

`ERROR: AddrInUse: Address already in use (os error 48)`

This error is because you had more than one instance of `quarto serve` going in your session. So close other command line instances that are running and try again. (If you use the R package and do `quarto_serve()` it will automatically make sure you only ever have 1 instance.)
