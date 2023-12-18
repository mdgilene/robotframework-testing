*** Settings ***
Documentation
...                 Configures variables and keywords for making requests requiring credentials obtained via OAuth2

Library             RPA.HTTP
Library             OAuth2


*** Keywords ***
Create Authenticated Session
    [Documentation]
    ...    Creates an authenticated HTTP session
    [Arguments]
    ...    ${tokenUrl}
    ...    ${clientId}
    ...    ${clientSecret}
    ...    ${alias}
    ...    ${url}
    ...    ${cert}=${None}
    ...    ${key}=${None}

    ${certs}=    Create List    ${cert} ${key}
    ${auth}=    Create Bearer Auth    ${tokenUrl}    ${clientId}    ${clientSecret}    certs=${certs}
    Create Custom Session    ${alias}    ${url}    ${auth}
