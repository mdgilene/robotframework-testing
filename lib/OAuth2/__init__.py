from robot.api.deco import keyword
from authlib.integrations.requests_client import OAuth2Session
from requests.auth import AuthBase


class BearerAuth(AuthBase):
    def __init__(self, token_endpoint, client_id, client_secret, certs=()):
        self.token_endpoint = token_endpoint
        self.session = OAuth2Session(
            client_id,
            client_secret,
            scope="openid",
            token_endpoint=self.token_endpoint,
            certs=certs,
        )

    def __call__(self, request):
        token = self.session.token

        if token is None:
            token = self.session.fetch_token(self.token_endpoint)
        elif token.is_expired():
            token = self.session.refresh_token(self.token_endpoint)

        request.headers["Authorization"] = f"Bearer {token.get('access_token')}"
        return request


class OAuth2:
    ROBOT_LIBRARY_SCOPE = "SUITE"

    @keyword
    def create_bearer_auth(
        self,
        token_endpoint: str = "",
        client_id: str = "",
        client_secret: str = "",
        certs: tuple = (),
    ):
        return BearerAuth(token_endpoint, client_id, client_secret, certs=certs)
