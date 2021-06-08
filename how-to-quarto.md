# How to Quarto

## Setup

Clone nasa-openscapes/quartobook-test

```{bash}
git clone https://github.com/NASA-Openscapes/quartobook-test
cd quartobook-test
```

Install `quarto` library

```{bash}
pip install quarto
```

Load environment

TODO venv

```{bash}

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

# I don't currently have a lot of packages in my code, which is where `renv` looks. Here are some packages:

# 

# `{r} # library(readr) # library(rmarkdown) #`

## Install Jupyterlab

In terminal, to get us all of jupyterlab:

```{bash}
pip install jupyterlab
```

Then to get what quarto needs:

```{bash}
pip install quarto
```

Python users can restore this session from the command line:

A pure Python user would just use "venv" (which is a standard part of Python3). This is a good article on using it:

<https://towardsdatascience.com/virtual-environments-104c62d48c54>

For R/Python users or RStudio users, renv with renv::use_python will end up using venv under the hood. But if they really don't have any interaction with R then plain venv is fine.
