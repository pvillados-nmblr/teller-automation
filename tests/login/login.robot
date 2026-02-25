*** Settings ***
Documentation       Test suite for Login
...                 Covers successful login, case-insensitive email, invalid credentials,
...                 and blank field validations.

Resource            ../../resources/keywords/common.resource

Suite Teardown      Close Browser


*** Variables ***
${MIXED_CASE_EMAIL}       Pvillados@Agsx.Net
${ERROR_TEXT1}             Incorrect email or password,
${ERROR_TEXT2}             please try again.


*** Test Cases ***

t1.2.1 Normal Login with Valid Existing Credentials
    [Documentation]    Verify that a teller can successfully log in with valid email and password
    ...                and is redirected to the Customers module dashboard.
    [Tags]             login    smoke
    Login To Teller App
    Wait For Elements State    text=Customers    visible
    Close Browser

t1.2.2 Verify System Treats Email As Case-Insensitive During Login
    [Documentation]    Verify that a teller can log in using a mixed-case version of their email
    ...                and is successfully authenticated and redirected to the Customers dashboard.
    [Tags]             login    smoke
    Open Teller App
    Fill Text          ${EMAIL_FIELD}       ${MIXED_CASE_EMAIL}
    Fill Text          ${PASSWORD_FIELD}    ${TELLER_PASSWORD}
    Click              ${LOGIN_BUTTON}
    Wait For Elements State    text=Customers    visible
    Close Browser

t1.2.3 Login with Invalid Email
    [Documentation]    Verify that login fails and an error message is shown when an invalid email is used.
    [Tags]             login    negative
    Open Teller App
    Fill Text          ${EMAIL_FIELD}       ${INVALID_EMAIL}
    Fill Text          ${PASSWORD_FIELD}    ${TELLER_PASSWORD}
    Click              ${LOGIN_BUTTON}
    Wait For Elements State    text=${ERROR_TEXT1}    visible
    Wait For Elements State    text=${ERROR_TEXT2}    visible
    Close Browser

t1.2.4 Login with Incorrect Password
    [Documentation]    Verify that login fails and an error message is shown when an incorrect password is used.
    [Tags]             login    negative
    Open Teller App
    Fill Text          ${EMAIL_FIELD}       ${TELLER_EMAIL}
    Fill Text          ${PASSWORD_FIELD}    ${INVALID_PASSWORD}
    Click              ${LOGIN_BUTTON}
    Wait For Elements State    text=${ERROR_TEXT1}    visible
    Wait For Elements State    text=${ERROR_TEXT2}    visible
    Close Browser

t1.2.5 Login with Blank Email and Password
    [Documentation]    Verify that when both email and password fields are blank:
    ...                1. The LOG IN button is disabled.
    ...                2. The user is not logged in and remains on the login page.
    [Tags]             login    negative
    Open Teller App
    Wait For Elements State    ${LOGIN_BUTTON}    disabled
    Wait For Elements State    ${EMAIL_FIELD}     visible
    Wait For Elements State    ${PASSWORD_FIELD}  visible
    Close Browser
