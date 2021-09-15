---
title: Authentication 
---

This content combines several original NASA sources:

-   [PO.DAAC AGU 2020 search by shapefile](https://github.com/NASA-Openscapes/AGU-2020/blob/main/Part-II/01_sst_shpfile/AGU_tutorial1_shp_search.ipynb)
-   LP DAAC HLS R Tutorial (link coming soon)
-   [LP DAAC Data User Resources Earthdata Login Setup](https://git.earthdata.nasa.gov/projects/LPDUR/repos/daac_data_download_python/browse/EarthdataLoginSetup.py)

------------------------------------------------------------------------

## Authentication via `netrc` file

A netrc file (pronounced "Net RC") stores credentials (e.g., Earthdata username and password) used to login and authorize access to data archived within NASA Earthdata. To access data, both on-prep and in the cloud, the netrc file must contain the following three items:  

1. machine name (the remote server receiving the credentials)  
2. login (Earthdata login username)  
3. password (Earthdata login password)  

The netrc file used to access NASA Earthdata assets can take the following  
form:  

```{text}
machine machine urs.earthdata.nasa.gov  
login <Earthdata login username>  
password <Earthdata login password>  
```  

A netrc file does not have an extension, and is saved as a file named `.netrc` in the `home` directory on Mac, UNIX, or Linux systems. On Windows systems the file should be named `_netrc` in the `home` directory (i.e. \user\username).  

A netrc file can be create manually using a text editor and the information above. In the example above `<Earthdata login username>` and `<Earthdata login password>` should be replaced with the user's Earthdata login username and password respectively.  

Semi-automated scripting solutions for creating netrc files also exist in both Python and R. Below are ways to create a netrc file in your `home` directory.

## Create netrc file using R

Create a "netrc" file by running the following code in your R console (or after saving to an R script).

```{r}
#| eval: FALSE

# Required packages for this script
packages = c('sys', 'getPass')

# Identify missing (not installed) packages
new.packages = packages[!(packages %in% installed.packages()[,"Package"])]

# Install missing packages
if(length(new.packages)) install.packages(new.packages, repos='http://cran.rstudio.com/')

# Load packages into R
library(sys)
library(getPass)

# Determine OS and associated netrc file 
netrc_type <- if(.Platform$OS.type == "windows") "_netrc" else ".netrc"    # Windows OS uses _netrc file

# Specify path to user profile 
up <- file.path(Sys.getenv("USERPROFILE"))                            # Retrieve user directory (for netrc file)

# Below, HOME and Userprofile directories are set.  

if (up == "") {
    up <- Sys.getenv("HOME") 
    Sys.setenv("userprofile" = up)
    if (up == "") {
        cat('USERPROFILE/HOME directories need to be set up. Please type sys.setenv("HOME" = "YOURDIRECTORY") or  sys.setenv("USERPROFILE" = "YOURDIRECTORY") in your console and type your USERPROFILE/HOME direcory instead of "YOURDIRECTORY". Next, run the code chunk again.')
    }
} else {Sys.setenv("HOME" = up)}        

netrc_path <- file.path(up, netrc_type, fsep = .Platform$file.sep)    # Path to netrc file

# Create a netrc file if one does not exist already
if (file.exists(netrc_path) == FALSE || grepl("urs.earthdata.nasa.gov", readLines(netrc_path)) == FALSE) {
    netrc_conn <- file(netrc_path)
    
    # User will be prompted for NASA Earthdata Login Username and Password below
    writeLines(c("machine urs.earthdata.nasa.gov",
                 sprintf("login %s", getPass(msg = "Enter NASA Earthdata Login Username \n (An account can be Created at urs.earthdata.nasa.gov):")),
                 sprintf("password %s", getPass(msg = "Enter NASA Earthdata Login Password:"))), netrc_conn)
    close(netrc_conn)
}

```

## Create netrc file using Python

Create a "netrc" file by running the following code in your python console (or after saving to an .py script).

**LP DAAC Approach:**

```{python}
#| eval: FALSE

# Load necessary packages into Python
from netrc import netrc
from subprocess import Popen
from getpass import getpass
import os

# -----------------------------------AUTHENTICATION CONFIGURATION-------------------------------- #
urs = 'urs.earthdata.nasa.gov'    # Earthdata URL to call for authentication
prompts = ['Enter NASA Earthdata Login Username \n(or create an account at urs.earthdata.nasa.gov): ',
           'Enter NASA Earthdata Login Password: ']

# Determine if netrc file exists, and if so, if it includes NASA Earthdata Login Credentials
try:
    netrcDir = os.path.expanduser("~/.netrc")
    netrc(netrcDir).authenticators(urs)[0]

# Below, create a netrc file and prompt user for NASA Earthdata Login Username and Password
except FileNotFoundError:
    homeDir = os.path.expanduser("~")
    Popen('touch {0}.netrc | chmod og-rw {0}.netrc | echo machine {1} >> {0}.netrc'.format(homeDir + os.sep, urs), shell=True)
    Popen('echo login {} >> {}.netrc'.format(getpass(prompt=prompts[0]), homeDir + os.sep), shell=True)
    Popen('echo password {} >> {}.netrc'.format(getpass(prompt=prompts[1]), homeDir + os.sep), shell=True)

# Determine OS and edit netrc file if it exists but is not set up for NASA Earthdata Login
except TypeError:
    homeDir = os.path.expanduser("~")
    Popen('echo machine {1} >> {0}.netrc'.format(homeDir + os.sep, urs), shell=True)
    Popen('echo login {} >> {}.netrc'.format(getpass(prompt=prompts[0]), homeDir + os.sep), shell=True)
    Popen('echo password {} >> {}.netrc'.format(getpass(prompt=prompts[1]), homeDir + os.sep), shell=True)

```

**PO.DAAC Approach:**

    Julie note to Catalina/Jack: I wasn't sure if this would be best here or in the search-by-shapefile.qmd: 

    The setup_earthdata_login_auth function will allow Python scripts to log into any Earthdata Login application programmatically. To avoid being prompted for credentials every time you run and also allow clients such as curl to log in, you can add the following to a .netrc (_netrc on Windows) file in your home directory:

    machine urs.earthdata.nasa.gov
        login <your username>
        password <your password>
    Make sure that this file is only readable by the current user or you will receive an error stating "netrc access too permissive."

    $ chmod 0600 ~/.netrc

```{python}
#| eval: FALSE
from netrc import netrc
from platform import system
from getpass import getpass
from http.cookiejar import CookieJar
from os.path import join, expanduser

TOKEN_DATA = ("<token>"
              "<username>%s</username>"
              "<password>%s</password>"
              "<client_id>PODAAC CMR Client</client_id>"
              "<user_ip_address>%s</user_ip_address>"
              "</token>")


def setup_cmr_token_auth(endpoint: str='cmr.earthdata.nasa.gov'):
    ip = requests.get("https://ipinfo.io/ip").text.strip()
    return requests.post(
        url="https://%s/legacy-services/rest/tokens" % endpoint,
        data=TOKEN_DATA % (input("Username: "), getpass("Password: "), ip),
        headers={'Content-Type': 'application/xml', 'Accept': 'application/json'}
    ).json()['token']['id']


def setup_earthdata_login_auth(endpoint: str='urs.earthdata.nasa.gov'):
    netrc_name = "_netrc" if system()=="Windows" else ".netrc"
    try:
        username, _, password = netrc(file=join(expanduser('~'), netrc_name)).authenticators(endpoint)
    except (FileNotFoundError, TypeError):
        print('Please provide your Earthdata Login credentials for access.')
        print('Your info will only be passed to %s and will not be exposed in Jupyter.' % (endpoint))
        username = input('Username: ')
        password = getpass('Password: ')
    manager = request.HTTPPasswordMgrWithDefaultRealm()
    manager.add_password(None, endpoint, username, password)
    auth = request.HTTPBasicAuthHandler(manager)
    jar = CookieJar()
    processor = request.HTTPCookieProcessor(jar)
    opener = request.build_opener(auth, processor)
    request.install_opener(opener)


# Get your authentication token for searching restricted records in the CMR:
_token = setup_cmr_token_auth(endpoint="cmr.earthdata.nasa.gov")

# Start authenticated session with URS to allow restricted data downloads:
setup_earthdata_login_auth(endpoint="urs.earthdata.nasa.gov")
```

## Common questions

### How do I know if I already have a netrc file?

Your netrc file will likely be in your root directory. It is a hidden file that you will not be able to see from your Finder (Mac) or Windows Explorer (Windows), so you'll have to do this from the Command Line. Navigate to your root directory and list all:

#### On a Mac:

``` bash
cd ~
ls -la
```

If you see a `.netrc` file, view what's inside (perhaps with `nano`), and if you'd like to delete the current version to start afresh, type `rm .netrc`.

```{=html}
<!---
### Previous notes/ideas

TODO: develop as prose to set up for the following .ipynb examples

To access NASA data you have to authenticate.

Solutions that work - these are detailed in separate chapters as Jupyter notebooks (`.ipynb`).

1)  To access NASA data one must setup an Earthdata Login profile. This involves (prose here)

See/link to [Christine's post & conversation on the Jupyter discourse forum](https://discourse.jupyter.org/t/how-do-i-properly-protect-my-data-access-passwords-not-jupyter-tokens-passwords-on-3rd-party-jupyter-hub-services/9277)

-   Create a netrc file\
-   Submit EDL credentials within a script

Some talk about the redirects...

--->
```