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

* [**NASA AWS Cloud Primer**](https://earthdata.nasa.gov/learn/user-resources/webinars-and-tutorials/cloud-primer) This primer provides step-by-step tutorials on how to get started in the AWS cloud.  
* [**What is AWS**](https://aws.amazon.com/what-is-aws/) Amazon Web Services (AWS) is the world’s most comprehensive and broadly adopted cloud, offering over 200 fully featured services from data centers globally.  

### Cloud Optimized Data Formats

NASA’s commitment to the Open-Source Science Initiative (OSSI) requires data facilities to consider optimizing file formats and file structures that are suited to analysis ready cloud optimized (ARCO) strategies. Traditional file formats can easily be migrated to the cloud, but serving or processing the data from the cloud is inefficient and often requires that the data be downloaded and then translated to another format and stored in memory. Cloud optimized formats are being developed to better serve analysis-in-place workflows that make the cloud so beneficial to science users.  

* [**Task 51 - Cloud-Optimized Format Study**](https://ntrs.nasa.gov/citations/20200001178) The cloud infrastructure provides a number of capabilities that can dramatically improve access and use of Earth Observation data. However, in many cases, data may need to be reorganized and/or reformatted in order to make them tractable to support cloud-native analysis/access patterns. The purpose of this study is to examine the pros and cons of different formats for storing data on the cloud. The evaluation will focus on both enabling high-performance data access and usage as well as to meet the existing scientific data stewardship needs of EOSDIS.

* [**Cloud Optimized GeoTIFF**](https://www.cogeo.org/) A Cloud Optimized GeoTIFF (COG) is a regular GeoTIFF file, aimed at being hosted on a HTTP file server, with an internal organization that enables more efficient workflows on the cloud. It does this by leveraging the ability of clients issuing ​HTTP GET range requests to ask for just the parts of a file they need.

* [**Cloud Optimized Formats: NetCDF-as-Zarr Optimizations and Next Steps**](https://www.element84.com/blog/cloud-optimized-formats-netcdf-as-zarr-optimizations-and-next-steps) Building on the [work by USGS/HDF to access netCDF as Zarr]((<https://medium.com/pangeo/cloud-performant-reading-of-netcdf4-hdf5-data-using-the-zarr-library-1a95c5c92314>)), the authors found that a sidecar metadata record that includes byte offsets provides users "access HDF5 format data as efficiently as Zarr format data using the Zarr library." In other words, users can gain the cloud-optimized performance of Zarr while retaining the archival benefits of NetCDF4.

## Coding Languages & Environments

To access the cloud programmatically you must have a basic understanding of how to code using a common platform like Python or R. If you are new to coding, we recommend you participate in a [Carpentries Workshop](https://carpentries.org/workshops/), which are hosted both remotely and in-person globally. Alternatively, you can teach yourself using their curriculum because it is available for free!

### Bash & Git

Bash is a command-line interface and language you’ll see called the terminal, the command line, or the shell that allows us to work with files on our computers more efficient and powerful than using a GUI (graphical user interface). Cloud services often are connected to and operated through Bash, so we must learn the basics of Bash scripting. Git is the most commonly used version control system and it can be accessed through Bash. Git makes cloud collaboration easier, allowing changes by multiple people to all be merged into one source.  

* [**The Unix Shell | Software Carpentry**](https://swcarpentry.github.io/shell-novice/) Use of the shell is fundamental to a wide range of advanced computing tasks, including high-performance computing. These lessons will introduce you to this powerful tool.  

* [**Version Control with Git | Software Carpentry**](https://swcarpentry.github.io/git-novice/) Version control is a tool for managing changes to a set of files. Each set of changes creates a new commit of the files; the version control system allows users to recover old commits reliably, and helps manage conflicting changes made by different users. Git is a free and open source distributed version control system.  

### Python

Python is ...

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

R is ...

* [Intro to Open Data Science with R - Lowndes & Horst](https://rstudio-conf-2020.github.io/r-for-excel/). Follow-along tutorials & code. Features workflows with RMarkdown, tidyverse, RStudio, GitHub...
* [What they forgot to teach you about R - Bryan & Hester](https://rstats.wtf/). Reinforcing lessons for moderately experienced R users
* [R for Data Science - Wickham & Grolemund.](https://r4ds.had.co.nz/) - All things tidyverse, including dates, plots, modeling, programming, RMarkdown
* Online learning community/book club: [rfordatasci.com](https://www.rfordatasci.com/)

## Authentication

### Earthdata Login

### earthaccess

### .netrc File
