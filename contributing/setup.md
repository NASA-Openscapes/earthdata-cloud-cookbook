---
title: Initial Setup
execute:
  eval: false
---

## Overview

This is the setup required to contribute to our Cookbook. Instructions are for the command line; see [quarto.org](https://quarto.org) for equivalents in R and for the most up-to-date and more detailed information.

## Install Quarto

First, in your internet browser, go to the very latest version of the Quarto command line interface (CLI):

<https://github.com/quarto-dev/quarto-cli/releases/latest>

Download Quarto by clicking on the file appropriate for your operating system:

-   **Linux**: amd64.deb

-   **Mac**: macos.pkg

-   **Windows**: win.msi

Once download is complete, follow the installation prompts on your computer like you do for other software.

### Check install

Finally, check to make sure Quarto installed properly. Open a command line terminal and type:

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

From quarto.org: If you need to install a version more recent than the latest release, see the documentation on installing the [Development Version](https://quarto.org/docs/getting-started/installation.html#development-version).

## Clone Cookbook from GitHub

Now clone our Cookbook and make it your current directory.

``` {.bash}
git clone https://github.com/NASA-Openscapes/earthdata-cloud-cookbook 
cd earthdata-cloud-cookbook
```

<!---TODO: Offer GitHub setup instructions: writeup GitHub Clinic ---> 

## Build Cookbook!

You should now be able to serve our Cookbook from the `earthdata-cloud-cookbook` directory.

``` {.bash}
quarto serve
```

This will open the Cookbook as a new tab in your browser. Now you're all set to contribute to the Cookbook! Read about how in the next chapter.
