*** Settings ***
Library     Browser
Library     ImapLibrary2
Resource    ../locators/common_locators.resource


*** Keywords ***
Open Teller App
    [Documentation]    Opens the teller web app in the browser
    New Browser         ${BROWSER}    headless=${HEADLESS}
    New Context         viewport={'width': 1643, 'height': 830}
    Set Browser Timeout    ${TIMEOUT}
    New Page            ${BASE_URL}
    Evaluate JavaScript    ${None}    document.body.style.zoom = '80%'


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
    Click              css=.ant-menu-title-content >> text=${module_name}
    Wait For Elements State    css=table >> nth=0    visible

Verify Security Email Sent
    [Documentation]    Connects to Gmail via IMAP and verifies a security alert email was delivered.
    ...                Waits up to 60 s for the email to arrive, then asserts subject and optional body.
    ...                IMAP_USERNAME must be the primary Google Workspace address (not the +alias).
    [Arguments]        ${recipient}    ${expected_subject}    ${expected_body}=${EMPTY}
    Open Mailbox    host=${IMAP_HOST}    user=${IMAP_USERNAME}    password=${IMAP_PASSWORD}
    ...             port=${IMAP_PORT}    is_secure=True
    ${uids}         Wait For Email
    ...             sender=noreply@higala.ph
    ...             subject=${expected_subject}
    ...             timeout=60
    IF    '${expected_body}' != '${EMPTY}'
        ${body}    Get Email Body    ${uids}[0]
        Should Contain    ${body}    ${expected_body}
        ...    msg=Email body does not contain expected text: "${expected_body}"
    END
    Close Mailbox
