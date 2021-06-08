# How to contribute to our book

We'll make our e-book using Quarto ([https://quarto.org](https://quarto.org/docs/getting-started/installation.html)). Your Quarto workflow can be from the Command Line (bash), Python, or R. Its book chapters can be many file types, including `.md` , `.ipynb`, and `.Rmd`. Chapters without code to execute can be written in `.md`.

(Note: with Quarto, e-books and websites are very similarly structured, with e-books being set up for numbered chapters and references and websites set up for higher number of pages and organization. We can talk about our book as a book even as we explore whether book/website better suits our needs. This is defined in `_quarto.yml`.)

## Setup

### Clone our repository locally

Clone `nasa-openscapes/quartobook-test` using your method of preference. Here is how to do this in bash:

```{bash}
git clone https://github.com/NASA-Openscapes/quartobook-test
cd quartobook-test
```

### Install Quarto

Install the `quarto` library so you can interact with it via the command line or R. I've set mine up with both.

#### Command Line/Python:

In the command line, type:

```{bash}
pip install quarto
```

#### R

In the R Console, type:

```{r, eval=FALSE}
install.packages("quarto")
```

### Load environment

Our repo is set up with an environment of the R and Python libraries that's just for this project (we created it using the [`renv`](https://rstudio.github.io/renv/) R package, notes below). Loading this environment will give you what you need to contribute to the book, as well as build and publish it. But it will stay contained just here in this project so it won't interact with your other projects.

More details about environments, from [A Guide to Python's Virtual Environments](https://towardsdatascience.com/virtual-environments-104c62d48c54) (Sarmiento 2019):

> A virtual environment is a Python tool for **dependency management** and **project** **isolation**. They allow Python **site packages** (third party libraries) to be installed locally in an isolateddirectory for a particular project, as opposed to being installed globally (i.e. as part of a system-wide Python).

#### Command Line/Python

TODO venv:

```{bash}
python3 -m venv renv/
```

#### R

In R, we'll first need the `remotes` package to install the `renv` package from GitHub. Then we can restore the environment using `renv::restore()`.

```{r}
if (!requireNamespace("remotes"))
  install.packages("remotes")

remotes::install_github("rstudio/renv")
renv::restore()

```

## Workflow - GitHub

Return to the project: navigate to it in the command line/Terminal, or open it in RStudio/Visual Studio, etc.

Pull most recent updates:

```{bash}
git pull 
```

Create a new branch, then switch to that branch to work in

```{bash}
git branch branch-name
git checkout branch-name
git push --set-upstream origin branch-name

# Julie's example
git branch jsl-dev
git checkout jsl-dev
git push --set-upstream origin jsl-dev
```

Check which branch you're on anytime by not specifying a branch name:

```{bash}
git branch
```

Make edits and build (see this workflow below)... Then when you're ready, push back to GitHub

```{bash}
git add --all
git commit -m "my commit message here"
git pull # just to be safe
git push 


```

## Workflow - Quarto

To build the book, run the following from Terminal

```{bash}
quarto serve
```

Paste the url from the console into your browser to see your updates.

Continue working, the book will refresh live!

Publish

Run this before pushing to GitHub to publish:

```{bash}
quarto render
```

    quarto::quarto_render()

## Julie set up the environment on June 7

To have our quarto project nicely portable, we used `renv` to manage python and R libraries/versions.

First set it up in R:

```{r, eval=FALSE}
remotes::install_github("rstudio/renv") # will move these into the cache
library(renv)
renv::init()
use_python()
```

Now I have private library for R and python that's just for this project. (Read more: <https://rstudio.github.io/renv/>).

The basic workflow: is to use `renv::snapshot()` of all the libraries we want, and then can always call `renv::restore()` to load them. Makes your environment portable between other people and other machines.

```{r, eval=FALSE}
renv::snapshot()
renv::restore()
```

```{bash}
pip install jupyterlab
```

Then to get what quarto needs:

```{bash}
pip install quarto
```
