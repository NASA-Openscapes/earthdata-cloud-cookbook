from copy import deepcopy
from typing import Dict, Any

from requests import session, exceptions
from requests.auth import HTTPBasicAuth


class CMRAuth(object):
    """
    base class to perform authentication operations for NASA CMR
    """
    CMR_OPS = "https://cmr.earthdata.nasa.gov/legacy-services/rest/tokens"
    CMR_UAT = "https://cmr.uat.earthdata.nasa.gov/legacy-services/rest/tokens"
    CMR_SIT = "https://cmr.sit.earthdata.nasa.gov/legacy-services/rest/tokens"

    def __init__(self, username: str, password: str, environment_url: str=CMR_OPS):
        self.session = session()
        if username is not None and password is not None:
            _TOKEN_DATA = ('<token>'
                             '<username>%s</username>'
                             '<password>%s</password>'
                             '<client_id>CMR Client</client_id>'
                             '<user_ip_address>%s</user_ip_address>'
                           '</token>'
                           )
            my_ip = self.session.get('https://ipinfo.io/ip').text.strip()
            self.auth = HTTPBasicAuth(username, password)
            # This token is valid for up to 3 months after is issued.
            # It's used to make authenticated calls to CMR to get back private collections
            auth_resp = self.session.post(environment_url,
                                          auth=self.auth,
                                          data=_TOKEN_DATA % (str(username), str(password), my_ip),
                                          headers={'Content-Type': 'application/xml', 'Accept': 'application/json'},
                                          timeout=10)
            if not (auth_resp.ok):  # type: ignore
                print(f'Authentication with Earthdata Login failed with:\n{auth_resp.text}')
                return None
            self._token = auth_resp.json()['token']['id']

    def get_token(self) -> str:
        """
        Returns a EDL token to use in private CMR collection searches
        """
        return self._token

    def get_auth_session(self) -> session:
        """
        Returns an authenticated Python Resquests session object
        """
        return deepcopy(self.session)

    def get_s3_credentials(self, auth_url: str='https://data.nsidc.earthdatacloud.nasa.gov/s3credentials') -> Any:
        """
        Returns AWS credentials to use with an S3 client i.e. boto3 or s3fs
        Each NASA DAAC can have a different endpoint to get credentials
        """
        # This credentials are temporary, usually hours.
        cumulus_resp = self.session.get(auth_url, timeout=10, allow_redirects=True)
        auth_resp = self.session.get(cumulus_resp.url,
                          auth=self.auth,
                          allow_redirects=True,
                          timeout=10)
        if not (auth_resp.ok):  # type: ignore
            print(f'Authentication with Earthdata Login failed with:\n{auth_resp.text}')
            return None
        return auth_resp.json()

