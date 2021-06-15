---
title: Initial Setup
execute:
  eval: false
---

## Overview

This will walk you through the setup required to run Quarto to contribute to our book. You can always refer to [quarto.org](https://quarto.org) for the most up-to-date and more detailed information. 

Setup for our Cookbook includes;

- Installing the very latest version of Quarto
- Installing Python from python.org
- Restoring the virtual environment and building our Cookbook

:::{.callout-note}
The following is written for the command line, and we can update with other scenarios as we go.
:::

:::{.callout-note}
The current set-up is for our book that has only Python, not R code. We'll add R setup instructions after we have everyone working with our current setup.
:::

:::{.callout-note}
Coming up we'll also outline other ways to contribute and review the Cookbook through GitHub on the browser. 
:::

## Install Quarto

First, download the very latest version of the Quarto command line interface (CLI) (at least v0.1.261) for your operating system (Linux, MacOS, Windows). After downloading, install following the prompts. 

<https://github.com/quarto-dev/quarto-cli/releases/latest>

Check to make sure Quarto installed properly with the following. It will return information about Quarto's functions.

```{.bash}
quarto help
```

## Install Python

Then, install Python from [python.org/downloads](https://www.python.org/downloads/). Windows users: be sure to download from [python.org/downloads/windows](https://www.python.org/downloads/windows/)


## Clone our Cookbook from GitHub

Now clone our book and set it as your current directory.

```{.bash}
git clone https://github.com/NASA-Openscapes/earthdata-cloud-cookbook 
cd earthdata-cloud-cookbook
```

If you need to set up GitHub see instructions [TODO]

## Set up virtual environment

Now you will create and activate the virtual environment that has all the Python (and soon, R) libraries that are required for our Cookbook. You can also read more about [virtual environments with Quarto](https://quarto.org/docs/getting-started/installation.html#virtual-environments).


<!---
Sidenote: More details about environments, from [A Guide to Python's Virtual Environments](https://towardsdatascience.com/virtual-environments-104c62d48c54) (Sarmiento 2019):

> A virtual environment is a Python tool for **dependency management** and **project** **isolation**. They allow Python **site packages** (third party libraries) to be installed locally in an isolateddirectory for a particular project, as opposed to being installed globally (i.e. as part of a system-wide Python).
--->


### Create `.venv`

To create a new Python 3 virtual environment in the directory `.venv`:

::: {.panel-tabset}
#### Mac/Linux

``` {.bash}
python3 -m venv .venv
```

#### Windows

``` {.bash}
py -3 -m venv .venv
```

Note that using `py -3` ensures that you are invoking the most recent version of Python 3 for Windows installed on your system. If this command fails, you should run the [Python for Windows](https://www.python.org/downloads/windows/) installer and then re-execute it.
:::

### Activate `.venv`

To use the environment you need to activate it. This differs slightly depending on which platform / shell you are using:

::: {.panel-tabset}
#### Mac/Linux {.panel-tabset}

``` {.bash}
source .venv/bin/activate
```

#### Windows (Cmd) {.panel-tabset}

``` {.bash}
.venv\Scripts\activate.bat
```

#### Windows (PowerShell) {.panel-tabset}

``` {.bash}
.venv\Scripts\Activate.ps1
```

Note that you may receive an error about running scripts being disabled when activating within PowerShell. If you get this error then execute the following command:

``` {.bash}
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser
```
:::


### Install dependencies

Our `requirements.txt` file contains the Python (and soon R) libraries needed in our Cookbook. To install, run: 

```{.bash}
pip install -r requirements.txt
```

## Build Cookbook!

You should now be able to serve and render the documents within the `earthdata-cloud-cookbook` directory.

```{.bash}
quarto serve
```

This will open the Cookbook as a new tab in your browser. Now you're all set to contribute to the Cookbook. Read about how in the next chapter. 





