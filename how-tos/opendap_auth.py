from jinja2 import Template
from pathlib import Path

HOME = str(Path.home())

def create_dodsrc():
    template = """# OPeNDAP client configuration file. See the OPeNDAP
    # users guide for information.
    USE_CACHE=0
    # Cache and object size are given in megabytes (20 ==> 20Mb).
    MAX_CACHE_SIZE=20
    MAX_CACHED_OBJ=5
    IGNORE_EXPIRES=0
    CACHE_ROOT={{ cache_path }}/.dods_cache/
    DEFAULT_EXPIRES=1
    ALWAYS_VALIDATE=1
    # Request servers compress responses if possible?
    # 1 (yes) or 0 (false).
    DEFLATE=0
    # Proxy configuration:
    # PROXY_SERVER=<protocol>,<[username:password@]host[:port]>
    # NO_PROXY_FOR=<protocol>,<host|domain>
    # AIS_DATABASE=<file or url>

    # Earth Data Login and LDAP login information
    HTTP.COOKIEJAR={{ cookies_path }}/.edl_cookies
    HTTP.NETRC={{ netrc_path }}/.netrc
    """

    data = {
        "cache_path": HOME,
        "cookies_path": HOME,
        "netrc_path": HOME,
    }

    j2_template = Template(template)

    #print(j2_template.render(data))

    with open(f"{HOME}/.dodsrc", "w") as f:
        f.write(j2_template.render(data))
        
    return f".dodsrc file created: {HOME}/.dodsrc"