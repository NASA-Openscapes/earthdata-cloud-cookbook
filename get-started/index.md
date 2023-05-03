---
title: “Get Started”
subtitle: “Get Started Working with Data in the Cloud”
date: last-modified
author: “NASA Openscapes Team”
citation_url: <https://nasa-openscapes.github.io/earthdata-cloud-cookbook/get-started>
slug: index
---

<!-- **Proposed Sources of Information**

* Understanding the Cloud
  * Selected content from “Cheatsheets, Guides, & Slides” page
  * API primer
* Authentication
  * Earthdata Login
  * earthaccess EDL programmatic login
  * .netrc creation? (what contexts will this be necessary?)
* How to Code
  * Selected content from “Our Cookbook” page
  * Python installation/environment setup
  * R installation/environment setup -->

---

So, you wanna get started working with NASA Earthdata in the cloud? You've come to the right place. This page provides resources that can be considered precursors to the how to's, tutorials, and other guidance you will find across our cookbook.

## About the Cloud

Maybe you've heard that NASA Earthdata is "moving to the cloud" but you want to know why. You can read the details of the [Earthdata Cloud Evolution](https://www.earthdata.nasa.gov/eosdis/cloud-evolution), but here we summarize the benefits of the cloud and additional resources on its use and history. In short, the cloud will make the download of data unnecessary, allow for data processing and manipulation without new software purchases or installation, and, ultimately, reduce the amount of time it takes to get the data needed to do science.

### Amazon Web Services

NASA’s Office of the Chief Information Officer chose Amazon Web Services (AWS) as the source of general-purpose cloud services (but some areas within NASA are working with Google Earth Engine (GEE) to make NASA data accessible in the GEE cloud-based analysis platform). The following resources provide a background on AWS, but much of the information is relevant to folks who want to develop in the cloud rather than simply access data. Remember, all [NASA's science information](https://science.nasa.gov/researchers/science-data/science-information-policy) (including the algorithms, metadata, and documentation associated with science mission data) must be freely available to the public. This means that anyone, anywhere in the world, can access NASA Earth science data without restriction. However, advanced cloud operations could require a user to set-up their own cloud account through AWS or another cloud provider.

* [NASA AWS Cloud Primer](https://earthdata.nasa.gov/learn/user-resources/webinars-and-tutorials/cloud-primer)
* [What is AWS](https://aws.amazon.com/what-is-aws/)

### Cloud Optimized Data Formats

Some nice info here from Pangeo about Cloud Optimized Data Formats.

* [**Cloud-Performant NetCDF4/HDF5 Reading with the Zarr Library**](https://medium.com/pangeo/cloud-performant-reading-of-netcdf4-hdf5-data-using-the-zarr-library-1a95c5c92314)

## Coding Languages & Environments

To access the cloud programmatically you must have a basic understanding of how to code using a common platform like Python or R. If you are new to coding, we recommend you participate in a [Carpentries Workshop](https://carpentries.org/workshops/), which are hosted both remotely and in-person globally. Alternatively, you can teach yourself using their curriculum because it is available for free!

### Bash
<!-- RESOURCES -->
### Python

* [Duke STA-663 - Colin Rundel](https://sta663-sp22.github.io/). Lecture slides & recordings, code & notebooks. Features Jupyter, git, numpy, scipy, pandas, scikit-learn...
* [Intro to Geospatial Raster and Vector Data with Python - Carpentries](https://carpentries-incubator.github.io/geospatial-python/). Follow-along tutorials & code. Features NEON data, intro to rasters & geostats rioxarray, geopandas...
* [Intro to Earth and Environmental Data Science- Ryan Abernathy](https://earth-env-data-science.github.io/intro.html). Intro to Python, JupyterLab, Unix, Git, some packages & workflows
* [Scalable and Computationally Reproducible Approaches to Arctic Research - NCEAS](https://learning.nceas.ucsb.edu/2023-03-arctic/). Advanced topics in computationally reproducible research in python, including environments, docker containers, and parallel processing using tools like parsl and dask, responsible research and data management practices including data sovereignty and the CARE principles, and ethical concerns with data-intensive modeling and analysis.

#### Scientific Python Ecosystem, Earth science and Cloud Computing together

* [Project Pythia Foundations Book](https://foundations.projectpythia.org/landing-page.html)
* [Jupyter meets Earth](https://jupytearth.org/)
* [The Environmental Data Science Book](https://the-environmental-ds-book.netlify.app/welcome.html)
* [CU EarthLab's Earth Data Science](https://www.earthdatascience.org/)
* [Pangeo](https://pangeo.io/)

#### Python environments with Conda useful for scientific Python (recommended by Luis Lopez)

* [Reproducible and upgradable Conda environments with conda-lock](https://pythonspeed.com/articles/conda-dependency-management/)
* [Managing virtual environments with pyenv](https://towardsdatascience.com/managing-virtual-environment-with-pyenv-ae6f3fb835f8)
* [Understanding and Improving Conda's performance](https://www.anaconda.com/blog/understanding-and-improving-condas-performance)
* [The definitive guide to Python virtual environments with conda](https://whiteboxml.com/blog/the-definitive-guide-to-python-virtual-environments-with-conda)
* [Making conda fast again](https://wolfv.medium.com/making-conda-fast-again-4da4debfb3b7)
<!---TODO https://fabienmaussion.info/scientific_programming/welcome.html
review Tiffany Timbers eg https://ubc-mds.github.io/DSCI_524_collab-sw-dev/README.html
https://gridsst-hackathon.github.io/gridsst/jupyter.html
--->
### R

* [Intro to Open Data Science with R - Lowndes & Horst](https://rstudio-conf-2020.github.io/r-for-excel/). Follow-along tutorials & code. Features workflows with RMarkdown, tidyverse, RStudio, GitHub...
* [What they forgot to teach you about R - Bryan & Hester](https://rstats.wtf/). Reinforcing lessons for moderately experienced R users
* [R for Data Science - Wickham & Grolemund.](https://r4ds.had.co.nz/) - All things tidyverse, including dates, plots, modeling, programming, RMarkdown
* Online learning community/book club: [rfordatasci.com](https://www.rfordatasci.com/)

## Authentication

### Earthdata Login

### earthaccess

### .netrc File
