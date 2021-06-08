# How to Quarto

## Julie set up the environment on June 7

To have our quarto project nicely portable, we used `renv` to manage python and R libraries/versions. 

First set it up in R: 

```{r, eval=FALSE}
remotes::install_github("rstudio/renv") # will move these into the cache
library(renv)
renv::init()
use_python()
```

Now I have private library for R and python that's just for this project. (Read more: https://rstudio.github.io/renv/). 

The basic workflow: is to use `renv::snapshot()` of all the libraries we want, and then can always call `renv::restore()` to load them. Makes your environment portable between other people and other machines.

```{r, eval=FALSE}
renv::snapshot()
renv::restore()
```

# I don't currently have a lot of packages in my code, which is where `renv` looks. Here are some packages: 
# 
# ```{r}
# library(readr)
# library(rmarkdown)
# ```

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

https://towardsdatascience.com/virtual-environments-104c62d48c54

For R/Python users or RStudio users, renv with renv::use_python will end up using venv under the hood. But if they really don't have any interaction with R then plain venv is fine.



