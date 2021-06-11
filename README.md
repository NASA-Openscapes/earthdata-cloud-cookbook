## Hello!

This Earthdata Cloud Cookbook is being developed by the [NASA-Openscapes team](https://nasa-openscapes.github.io/). 

### How to contribute to our book
Information for our team to [contributes to the Cookbook](https://nasa-openscapes.github.io/earthdata-cloud-cookbook/files/community-handbook/contributing.html)

### Initial repo setup notes

#### Create and clone a repo

Create repo at github.com. 

Clone `nasa-openscapes/earthdata-cloud-cookbook` using your method of preference. Here is how to do this in bash:

```{bash}
git clone https://github.com/NASA-Openscapes/earthdata-cloud-cookbook
cd earthdata-cloud-cookbook
```
#### Install quarto and create environment

Install the `quarto` library so you can interact with it via the command line or R. I've set mine up with both. 

In bash, type:

```{bash}
## required
pip install quarto

## probably going to want this
pip install jupyterlab
pip install matplotlib 
pip install scikit-image
pip install requests
```

In the R Console, type:

```{r, eval=FALSE}
## required
install.packages("quarto")
install.packages("reticulate")
```

To have our quarto project nicely portable, we used `renv` to manage python and R libraries/versions.

About python environments: `environment.yml` and `requirements.txt` are doing the same thing but are built based on the python installation. `pip` will create `environment.yml`, and `conda` will create `requirements.txt`. 

First set it up in R:

```{r, eval=FALSE}
remotes::install_github("rstudio/renv") # will move these into the cache
library(renv)
renv::init()
renv::use_python()
```

Now I have private library for R and python that's just for this project. (Read more: <https://rstudio.github.io/renv/>).

The basic workflow: is to use `renv::snapshot()` of all the libraries we want, and then can always call `renv::restore()` to load them. Makes your environment portable between other people and other machines.

```{r, eval=FALSE}
renv::snapshot()
renv::restore()
```

As we develop and add more package dependencies, re-run `renv::snapshot()` to update the environment

## Notes about Quarto

See much more detailed information in <https://quarto.org>. This is just a few notes.

In migrating from a book to a website you need to change some of the pages to have a YAML title rather than H1 header. For example change:

```
# Background 
```

to

```
---
title: Background
---
```

Books use the alternate no YAML form because in the case of PDF, ePUB, or MS Word books all of the .md files are pasted together into a single file (which can't have multiple title entries).


-   

### June 9 J.J.'s fix for Aaron

#### What Julie did:

```
git clone https://github.com/quarto-dev/quarto-cli
cd quarto-cli
./configure-macos.sh
quarto convert help # to check 
```

#### For Aaron:

```
cd quarto-cli
git pull
configure_windows.cmd
```

After the install works, make sure it's on his PATH.

If not, then how to change: <https://stackoverflow.com/questions/61799309/where-can-i-see-deno-downloaded-packages>

Quarto is under the quarto-cli directory: there's a `package/disc/bin` -- could get this on his $PATH
