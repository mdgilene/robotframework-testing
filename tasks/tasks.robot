*** Settings ***
Documentation
...                 Main Test Suite

Resource            resources/oauth2.resource

Suite Setup         Setup


*** Variables ***
${TOKEN_URL}=           http://localhost:8080/realms/master/protocol/openid-connect/token
${CLIENT_ID}=           test
${CLIENT_SECRET}=       bZxR7Z5a191BQ78nMwceVKhguJnqkct8
${OAUTH2_SESSION}=      oauth2
${BASIC_SESSION}=       basic
${URL}=                 http://localhost:8080


*** Test Cases ***
Get Authenticated:
    GET On Session    ${OAUTH2_SESSION}    /admin/realms/master/users
    Status Should Be    200

Repeated Authenticated Request:
    GET On Session    ${OAUTH2_SESSION}    /admin/realms/master/users
    Status Should Be    200
    Sleep    6s
    GET On Session    ${OAUTH2_SESSION}    /admin/realms/master/users
    Status Should Be    200

Get Unauthenticated:
    GET On Session    ${BASIC_SESSION}    /admin/realms/master/users    expected_status=401
    Status Should Be    401


*** Keywords ***
Setup
    Create Authenticated Session    ${TOKEN_URL}    ${CLIENT_ID}    ${CLIENT_SECRET}    ${OAUTH2_SESSION}    ${URL}
    Create Session    ${BASIC_SESSION}    ${URL}
