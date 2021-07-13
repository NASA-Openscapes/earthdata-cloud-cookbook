from typing import Dict
from os.path import expanduser

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
            auth_cred = HTTPBasicAuth(username, password)
            auth_resp = self.session.post(environment_url,
                                          auth=auth_cred,
                                          data=_TOKEN_DATA % (str(username), str(password), my_ip),
                                          headers={'Content-Type': 'application/xml', 'Accept': 'application/json'},
                                          timeout=10)
            if not (auth_resp.ok):  # type: ignore
                print(f'Authentication with Earthdata Login failed with:\n{auth_resp.text}')
                return None
            self._token = auth_resp.json()['token']['id']

    def get_token(self):
        """
        Returns a EDL token to use in private CMR collection searches
        """
        # home_dir = expanduser("~")
        # with open(f'{home_dir}/.cmr_token', 'w', encoding='utf8') as f:
        #     f.write(self._token)
        return self._token

    def get_auth_session(self):
        """
        Returns an authenticated Python Resquests session object
        """
        return self.session

    def get_s3_credentials(self, url: str='https://data.nsidc.earthdatacloud.nasa.gov/s3credentials'):
        """
        Returns AWS credentials to use with an S3 client i.e. boto3
        """
        credentials = self.session.get(url).json()
        return credentials

