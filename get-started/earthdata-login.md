---
title: EarthData Login
---

To access NASA data, you need EarthData Login...

### Previous notes/ideas

TODO: develop as prose to set up for the following .ipynb examples

To access NASA data you have to authenticate.

Solutions that work - these are detailed in separate chapters as Jupyter notebooks (`.ipynb`).

1)  To access NASA data one must setup an Earthdata Login profile. This involves (prose here)

See/link to [Christine's post & conversation on the Jupyter discourse forum](https://discourse.jupyter.org/t/how-do-i-properly-protect-my-data-access-passwords-not-jupyter-tokens-passwords-on-3rd-party-jupyter-hub-services/9277)

-   Create a netrc file\
-   Submit EDL credentials within a script

Some talk about the redirects...

## Earth Data Login Notes

*Modified From [PODAAC AGU 2020](https://github.com/NASA-Openscapes/AGU-2020/blob/main/Part-II/01_sst_shpfile/AGU_tutorial1_shp_search.ipynb)*

An Earthdata Login account is required to access data, as well as discover restricted data, from the NASA Earthdata system. Please visit <https://urs.earthdata.nasa.gov> to register and manage your Earthdata Login account. This account is free to create and only takes a moment to set up.

To avoid being prompted for credentials every time you run and also allow clients such as curl to log in, you can create and/or add the following to a "netrc" file (pronounced "Net RC"). On a Mac, this is a file called `.netrc`, and on Windows it is `_netrc`. (There are no extensions on either file). Create this file in your home directory:


< TODO: code for setting up a netrc file from the command line? or Python? >


## Common questions

### How do I know if I already have a netrc file? 

Your netrc file will likely be in your root directory. It is a hidden file that you will not be able to see from your Finder (Mac) or Windows Explorer (Windows), so you'll have to do this from the Command Line. Navigate to your root directory and list all: 

#### On a Mac: 

```{.bash}
cd ~
ls -la
```

If you see a `.netrc` file, view what's inside (perhaps with `nano`), and if you'd like to delete the current version to start afresh, type `rm .netrc`. 