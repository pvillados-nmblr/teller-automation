*** Settings ***
Library     Browser
Variables   ../variables/env.yaml
Resource    ../locators/common_locators.resource


*** Keywords ***
Open Teller App
    [Documentation]    Opens the teller web app in the browser
    New Browser         ${BROWSER}    headless=${HEADLESS}
    New Context         viewport={'width': 1643, 'height': 830}
    New Page            ${BASE_URL}
    Evaluate JavaScript    ${None}    document.body.style.zoom = '80%'
    Set Browser Timeout    ${TIMEOUT}


Login To Teller App
    [Documentation]    Logs in to the teller app using valid credentials from env.yaml
    [Arguments]        ${email}=${TELLER_EMAIL}    ${password}=${TELLER_PASSWORD}
    Open Teller App
    Fill Text          ${EMAIL_FIELD}       ${email}
    Fill Text          ${PASSWORD_FIELD}    ${password}
    Click              ${LOGIN_BUTTON}
    Wait For Elements State    css=h3.text-2xl    visible

Login With Invalid Credentials
    [Documentation]    Attempts to log in using invalid credentials
    [Arguments]        ${email}=${INVALID_EMAIL}    ${password}=${INVALID_PASSWORD}
    Open Teller App
    Fill Text          ${EMAIL_FIELD}       ${email}
    Fill Text          ${PASSWORD_FIELD}    ${password}
    Click              ${LOGIN_BUTTON}

Logout From Teller App
    [Documentation]    Logs out from the teller app and closes the browser
    Click              text=Log out
    Wait For Elements State    ${LOGIN_BUTTON}    visible
    Close Browser

Navigate To Module
    [Documentation]    Navigates to a specific module via the sidebar menu
    [Arguments]        ${module_name}
    Click              text=${module_name}
    Wait For Elements State    css=table    visible
