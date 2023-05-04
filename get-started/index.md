---
title: “Get Started”
subtitle: “Get Started Working with Data in the Cloud”
date: last-modified
author: “NASA Openscapes Team”
citation_url: <https://nasa-openscapes.github.io/earthdata-cloud-cookbook/get-started>
slug: index
---

So, you wanna get started working with NASA Earthdata in the cloud? You've come to the right place. This page provides resources that can be considered precursors to the how to's, tutorials, and other guidance you will find across our cookbook.

## About the Cloud

Maybe you've heard that NASA Earthdata is "moving to the cloud" but you want to know why. You can read the details of the [Earthdata Cloud Evolution](https://www.earthdata.nasa.gov/eosdis/cloud-evolution), but here we summarize the benefits of the cloud and additional resources on its use and history. In short, the cloud will make the download of data unnecessary, allow for data processing and manipulation without new software purchases or installation, and, ultimately, reduce the amount of time it takes to get the data needed to do science.

### Amazon Web Services

NASA’s Office of the Chief Information Officer chose Amazon Web Services (AWS) as the source of general-purpose cloud services (but some areas within NASA are working with Google Earth Engine (GEE) to make NASA data accessible in the GEE cloud-based analysis platform). The following resources provide a background on AWS, but much of the information is relevant to folks who want to develop in the cloud rather than simply access data. Remember, all [NASA's science information](https://science.nasa.gov/researchers/science-data/science-information-policy) (including the algorithms, metadata, and documentation associated with science mission data) must be freely available to the public. This means that anyone, anywhere in the world, can access NASA Earth science data without restriction. However, advanced cloud operations could require a user to set-up their own cloud account through AWS or another cloud provider.

* [**Cloud Primer for Amazon Web Services**](https://earthdata.nasa.gov/learn/user-resources/webinars-and-tutorials/cloud-primer) This primer provides step-by-step tutorials on how to get started in the AWS cloud.  

* [**What is AWS**](https://aws.amazon.com/what-is-aws/) Amazon Web Services is the world’s most comprehensive and broadly adopted cloud, offering over 200 fully featured services from data centers globally.  

<!-- ### Cloud Optimized Data Formats

Traditional file formats can easily be migrated to the cloud, but serving or processing the data from the cloud is inefficient and often requires that the data be downloaded and then translated to another format and stored in memory. Cloud optimized formats are being developed to better serve analysis-in-place workflows that make the cloud so beneficial to science users.  

* [**Cloud-Optimized Format Study**](https://ntrs.nasa.gov/citations/20200001178) The cloud infrastructure provides a number of capabilities that can dramatically improve access and use of Earth Observation data. However, in many cases, data may need to be reorganized and/or reformatted in order to make them tractable to support cloud-native analysis and access patterns. The purpose of this study is to examine different formats for storing data on the cloud.  

* [**Cloud Optimized GeoTIFF**](https://www.cogeo.org/) A Cloud Optimized GeoTIFF is a regular GeoTIFF file with an internal organization that enables more efficient workflows on the cloud. It does this by leveraging the ability of clients issuing ​HTTP GET range requests to ask for just the parts of a file they need.   -->

## Coding Languages & Environments

To access the cloud programmatically you must have a basic understanding of how to code using common, cloud-relevant languages. Most Earth data scientists use either Python or R already, so we focus on those languages. If you are new to coding, we recommend you participate in a workshop or use open-source resources to teach yourself.  

* [Carpentries Workshop](https://carpentries.org/workshops/) These workshops on the foundations of data and code take place remotely and in-person around the world.

* [CU EarthLab's Earth Data Science](https://www.earthdatascience.org/) This site offers free online courses, tutorials, and tools for earth science using R and Python.  

### Bash & Git

Bash is a command-line interface and language you’ll see called the terminal, the command line, or the shell that allows us to work with our computers more efficiently than using a GUI (graphical user interface). Cloud services often are connected to and operated through Bash, so we must learn the basics of scripting. Git is the most commonly used version control system and it can be accessed through Bash. Git makes cloud collaboration easier, allowing changes by multiple people to all be merged into one source.  

* [**The Unix Shell**](https://swcarpentry.github.io/shell-novice/) Use of the shell is fundamental to a wide range of advanced computing tasks, including high-performance computing. These lessons will introduce you to this powerful tool.  

* [**Version Control with Git**](https://swcarpentry.github.io/git-novice/) Version control is a tool for managing changes to a set of files. Each set of changes creates a new commit of the files; the version control system allows users to recover old commits reliably, and helps manage conflicting changes made by different users. This tutorial will introduce you to Git, a popular open source distributed version control system.  

### Python

Python is a programming language that is widely used in web applications, software development, data science, and machine learning. Developers use Python because it is efficient and easy to learn and can run on many different platforms. Python and its libraries are also free, making it one of the most important languages for coding cloud-based services.  

* [**The Python Tutorial**](https://docs.python.org/3/tutorial/) This tutorial introduces the reader informally to the basic concepts and features of the Python language and system.

### R

R is an open-source, platform-independent programming language used for data analysis, statistics, and visualization. You can use R to create an instance (a virtual machine that you access remotely) on Amazon Cloud, Microsoft Azure, or Google Cloud.

* [**R for Excel Users**](https://rstudio-conf-2020.github.io/r-for-excel/) This course is for Excel users who want to add or integrate R and RStudio into their existing data analysis toolkit. It is a friendly intro to becoming a modern R user, full of tidyverse, RMarkdown, GitHub, collaboration & reproducibility.

* [**Getting started with R on Amazon Web Services**](https://aws.amazon.com/blogs/opensource/getting-started-with-r-on-amazon-web-services/) This guide demonstrates how to use AWS in R with the Paws AWS software development kit.

* [**R for Cloud Computing**](https://doi.org/10.1007/978-1-4939-1702-0) This book will help you kick-start analytics on the cloud including chapters on both cloud computing, R, common tasks performed in analytics including the current focus and scrutiny of Big Data Analytics, setting up and navigating cloud providers.

## Authentication

To access NASA Earthdata, you must ...

### Earthdata Login

### earthaccess

### .netrc File

<!-- 
!!!!! EXPLAIN ENVIRONMENTS

* [Reproducible and upgradable Conda environments with conda-lock](https://pythonspeed.com/articles/conda-dependency-management/)
* [Managing virtual environments with pyenv](https://towardsdatascience.com/managing-virtual-environment-with-pyenv-ae6f3fb835f8)
* [Understanding and Improving Conda's performance](https://www.anaconda.com/blog/understanding-and-improving-condas-performance)
* [The definitive guide to Python virtual environments with conda](https://whiteboxml.com/blog/the-definitive-guide-to-python-virtual-environments-with-conda)
* [Making conda fast again](https://wolfv.medium.com/making-conda-fast-again-4da4debfb3b7)

Additional Resources

Python 
* [**Pythia Foundations**](https://foundations.projectpythia.org/landing-page.html) This book is intended to educate the reader on the essentials for using the Scientific Python Ecosystem (SPE): a collection of open source Python packages that support analysis, manipulation, and visualization of scientific data.

* [**Python on AWS**](https://aws.amazon.com/developer/language/python/) Tools, docs, and sample code to develop applications on the AWS cloud.

* [**Managing Python Environments**](https://earth-env-data-science.github.io/lectures/environment/python_environments.html) This book is intended to introduce students to modern computing software, programming tools, and best practices that are broadly applicable to the analysis and visualization of Earth and Environmental data. This section describes basic programming in the open-source Python language.  

* [**Intro to Geospatial Raster and Vector Data with Python**](https://carpentries-incubator.github.io/geospatial-python/) This tutorial provides an introduction to raster data, and describes how to plot, program, and access satellite imagery using Python.

R

* [**R for Data Science**](https://r4ds.hadley.nz/) This book will teach you how to do data science with R: You’ll learn how to get your data into R, get it into the most useful structure, transform it and visualize. 

* [**R for Data Science Online Learning Community**](https://www.rfordatasci.com/) The R4DS Online Learning Community is a community of R learners at all skill levels working together to improve their skills.

Earth Data Science

* [**The Environmental Data Science Book**](https://the-environmental-ds-book.netlify.app/welcome.html) This book is a living, open and community-driven online resource to showcase and support the publication of data, research and open-source tools for collaborative, reproducible and transparent Environmental Data Science.

Other

* [**Cloud Optimized Formats: NetCDF-as-Zarr Optimizations and Next Steps**](https://www.element84.com/blog/cloud-optimized-formats-netcdf-as-zarr-optimizations-and-next-steps) Building on the [work by USGS/HDF to access netCDF as Zarr]((<https://medium.com/pangeo/cloud-performant-reading-of-netcdf4-hdf5-data-using-the-zarr-library-1a95c5c92314>)), the authors found that a sidecar metadata record that includes byte offsets provides users "access HDF5 format data as efficiently as Zarr format data using the Zarr library." In other words, users can gain the cloud-optimized performance of Zarr while retaining the archival benefits of NetCDF4.  

-->