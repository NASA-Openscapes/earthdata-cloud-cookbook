## _fetch_remote_notebook.R
## A script to fetch remote documents we want to include in the Cookbook.
## These remote resources can be included as a result of this intentional import operation.
## They will be converted to .qmd files so that they can be included as "child" documents.
## From J.J.: Quarto is designed so that remote resources aren't downloaded directly but instead a result of an intentional import operation. In the future we could have a single R, Python, or Bash script that just takes a list of URLs and where they go in your tree and performs the download there. You could also do this on CI just to make sure that the production site always gets the latest resources.* 

## load any libraries needed ----
suppressPackageStartupMessages({
  library(tidyverse)  # install.packages("tidyverse")  # wrangling
  library(here)       # install.packages("here")       # filepaths
  library(RCurl)      # install.packages("RCurl")      # checking urls 
})

## identify file remote urls to copy, as well as the local directory  ----
to_copy <- c(
  "https://raw.githubusercontent.com/nasa/zarr-eosdis-store/main/presentation/example.ipynb",
  "https://raw.githubusercontent.com/nasa/zarr-eosdis-store/main/presentation/requirements.txt"
  )

local_dir <- "examples/zarr-eosdis-store"

## loop through and copy files: .ipynb gets a "_" prefix so that it's not served by quarto ----
for (f in to_copy) { # f =  "https://raw.githubusercontent.com/nasa/zarr-eosdis-store/main/presentation/example.ipynb"
  
  ## if the url exists, tidy name, prefixing with "_" if .ipynb
  if (RCurl::url.exists(f)) {
    f_web   <- readr::read_lines(f)
    if (tools::file_ext(f) == 'ipynb') {
      f_local <- paste0('_', basename(f))
      f_local <- str_replace_all(f_local, "%20", "_")
    } else {
      f_local <- basename(f)
    }
    
    ## save local copy with f_local prefix
    f_local_dir <- paste(local_dir, f_local, sep="/")
    readr::write_lines(f_web, file = here(f_local_dir), append = FALSE)
    message(sprintf('Saving %s', f_local_dir))
    
    ## if .ipynb, convert to .qmd: use system() to call bash commands
    if (tools::file_ext(f) == 'ipynb') {
      f_local_dir <- paste0(tools::file_path_sans_ext(f_local_dir))
      system(sprintf(
        "quarto convert %s.ipynb --output %s.qmd", f_local_dir, f_local_dir))
      
      ## delete the local .ipynb (retain only local .qmd)
      file.remove(sprintf("%s.ipynb", f_local_dir))
      message(sprintf('Local copy deleted: %s', f_local_dir))
    }
    
  ## if RCurl::url.exists(f) returns FALSE  
  } else {
    message(sprintf('%s does not exist', f))
  }
}


# ## set up the conda environment ---
# ## use system() to run bash commands
# 
# ## create a new Python 3 virtual environment in the directory env
# system(sprintf("conda env create -f %s", here(local_dir, "environment.yml")))
# 
# # To use the environment you need to activate it.  
# system("conda activate papermill") #conda activate podaac-harmony
# 
# ## Try another way ---
# ##from https://quarto.org/docs/getting-started/quarto-projects.html?q=renv#virtual-environments
# 
# ## To create a new Python 3 virtual environment in the directory env:
# system(sprintf("conda create --prefix %s python", here(local_dir, "env")))
# 
# ##If this is the first time you’ve used conda in your shell, you may need to execute one of the following commands before using other conda tools:
# system("conda init bash")
# 
# ## To use the environment you need to activate it, which you do as follows:
# system("conda activate ./env")
# 
# ## To reproduce the environment on another machine you just pass the environment.yml file as an argument to conda create:
# system(sprintf("conda create --prefix env -f %s", here(local_dir, "environment.yml")))
# 
# ## conda bash commands
# ### https://quarto.org/docs/getting-started/quarto-projects.html?q=renv#virtual-environments
# # cd examples/zarr-eosdis-store
# # python3 -m venv env
# # source env/bin/activate
# # python3 -m pip install -r requirements.txt