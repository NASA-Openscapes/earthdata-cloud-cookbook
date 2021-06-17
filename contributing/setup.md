---
title: Initial Setup
execute:
  eval: false
---

## Overview

This is the setup required to contribute to our Cookbook. You can always refer to [quarto.org](https://quarto.org) for the most up-to-date and more detailed information.

Setup for our Cookbook includes:

-   Installing the very latest version of Quarto
-   Cloning our Cookbook repo from GitHub
-   Building our Cookbook

Instructions here is to run Quarto from the command line; see [quarto.org](https://quarto.org){.uri} for equivalents in R.

::: {.callout-note}
Coming up we'll also outline other ways to contribute and review the Cookbook through GitHub on the browser.
:::

## Install Quarto

First, download the very latest version of the Quarto command line interface (CLI). To do this, go to:

<https://github.com/quarto-dev/quarto-cli/releases/latest>

Click on the file type to download for your operating system:

-   Linux: `amd64.deb`

-   Mac: `macos.pkg`

-   Windows: `win.msi`

After downloading, follow the installation prompts on your computer like you do for other software.

Check to make sure Quarto installed properly:

``` {.bash}
quarto check install 
```

::: {.callout-note collapse="true"}
## Additional checks

You can also run:

-   `quarto check knitr` to locate R, verify we have the rmarkdown package, and do a basic render
-   `quarto check jupyter` to locate Python, verify we have Jupyter, and do a basic render
-   `quarto check` to run all of these checks together
:::

If you need to install a version more recent than the latest release, see the documentation on installing the [Development Version](https://quarto.org/docs/getting-started/installation.html#development-version).

## Clone  from GitHub

Now clone our book and set it as your current directory.

``` {.bash}
git clone https://github.com/NASA-Openscapes/earthdata-cloud-cookbook 
cd earthdata-cloud-cookbook
```

If you need to set up GitHub see instructions [TODO]

## Build Cookbook!

You should now be able to serve and render the documents within the `earthdata-cloud-cookbook` directory.

``` {.bash}
quarto serve
```

This will open the Cookbook as a new tab in your browser. Now you're all set to contribute to the Cookbook! Read about how in the next chapter.
