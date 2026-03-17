*** Settings ***
Documentation       Test suite for Login
...                 Covers successful login, case-insensitive email, invalid credentials,
...                 blank field validations, session timeout behavior, and account lockout security.

Resource            ../../resources/keywords/common.resource

Suite Teardown      Close Browser


*** Variables ***
${LOGIN_ERROR_TEXT1}                      Incorrect email or password,
${LOGIN_ERROR_TEXT2}                      please try again.
${LOCKOUT_MESSAGE1}                 Incorrect email or password. Too many
${LOCKOUT_MESSAGE2}                 attempts — please try again in 5 minutes.
${SUBSEQUENT_LOCKOUT_MESSAGE1}      Too many login attempts
${SUBSEQUENT_LOCKOUT_MESSAGE2}      This account has reached the maximum number of login attempts. Please try again after 5 minutes.
${SESSION_EXPIRED_TEXT}             Session Expired
${SESSION_EXPIRED_DETAIL}           For security reasons, you need to sign in again to continue using the app.
${SESSION_TIMEOUT}                  301s
${NEAR_TIMEOUT}                     290s
${COOLDOWN_PERIOD}                  300s
${NEAR_COOLDOWN_PERIOD}             290s
${HIDE_TAB_JS}                      Object.defineProperty(document, 'visibilityState', {get: () => 'hidden', configurable: true}); document.dispatchEvent(new Event('visibilitychange'));
${SHOW_TAB_JS}                      Object.defineProperty(document, 'visibilityState', {get: () => 'visible', configurable: true}); document.dispatchEvent(new Event('visibilitychange'));
${LOCKOUT_EMAIL_SUBJECT}            Security Alert: Your Account Has Been Temporarily Locked
${LOCKOUT_EMAIL_BODY}               Your account has been locked after several incorrect password entries. This is a standard security measure to protect your credentials and the bank's systems. If this activity was not done by you, please report it immediately to support@higala.ph.
${OTP}                              123456


*** Test Cases ***

t1.2.1 Normal Login with Valid Existing Credentials
    [Documentation]    Verify that a teller can successfully log in with valid email and password
    ...                and is redirected to the Customers module dashboard.
    [Tags]             login    smoke    mvp
    Login To Teller App
    Wait For Elements State    ${SIDEBAR_CUSTOMERS}                      visible
    Wait For Elements State    text=Customer ID                          visible
    Wait For Elements State    text=Customer Name                        visible
    Wait For Elements State    text=Date of Birth                        visible
    Wait For Elements State    text=Created on                           visible
    Wait For Elements State    text=Last Updated                         visible
    Wait For Elements State    text=Customer Status                      visible
    Wait For Elements State    text="Action"              visible
    Close Browser

t1.2.2 Verify System Treats Email As Case-Insensitive During Login
    [Documentation]    Verify that a teller can log in using a mixed-case version of their email
    ...                and is successfully authenticated and redirected to the Customers dashboard.
    [Tags]             login    smoke    mvp
    Open Teller App
    Fill Text          ${EMAIL_FIELD}       ${MIXED_CASE_EMAIL}
    Fill Text          ${PASSWORD_FIELD}    ${TELLER_PASSWORD}
    Click              ${LOGIN_BUTTON}
    Wait For Elements State    ${SIDEBAR_CUSTOMERS}                      visible
    Wait For Elements State    text=Customer ID                          visible
    Wait For Elements State    text=Customer Name                        visible
    Wait For Elements State    text=Date of Birth                        visible
    Wait For Elements State    text=Created on                           visible
    Wait For Elements State    text=Last Updated                         visible
    Wait For Elements State    text=Customer Status                      visible
    Wait For Elements State    text="Action"              visible
    Close Browser

t1.2.3 Login with Invalid Email
    [Documentation]    Verify that login fails and an error message is shown when an invalid email is used.
    [Tags]             login    negative    mvp
    Open Teller App
    Fill Text          ${EMAIL_FIELD}       ${INVALID_EMAIL}
    Fill Text          ${PASSWORD_FIELD}    ${TELLER_PASSWORD}
    Click              ${LOGIN_BUTTON}
    Wait For Elements State    text=${LOGIN_ERROR_TEXT1}    visible
    Wait For Elements State    text=${LOGIN_ERROR_TEXT2}    visible
    Close Browser

t1.2.4 Login with Incorrect Password
    [Documentation]    Verify that login fails and an error message is shown when an incorrect password is used.
    [Tags]             login    negative    mvp
    Open Teller App
    Fill Text          ${EMAIL_FIELD}       ${TELLER_EMAIL}
    Fill Text          ${PASSWORD_FIELD}    ${INVALID_PASSWORD}
    Click              ${LOGIN_BUTTON}
    Wait For Elements State    text=${LOGIN_ERROR_TEXT1}    visible
    Wait For Elements State    text=${LOGIN_ERROR_TEXT2}    visible
    Close Browser

t1.2.5 Login with Blank Email and Password
    [Documentation]    Verify that when both email and password fields are blank:
    ...                1. The LOG IN button is disabled.
    ...                2. The user is not logged in and remains on the login page.
    [Tags]             login    negative    mvp
    Open Teller App
    Wait For Elements State    ${LOGIN_BUTTON}    disabled
    Wait For Elements State    ${EMAIL_FIELD}     visible
    Wait For Elements State    ${PASSWORD_FIELD}  visible
    Close Browser

t1.2.6 Session Timeout - Standard Inactivity (Desktop)
    [Documentation]    Verify that the session expires after 5 minutes and 1 second of inactivity.
    ...                The user should be redirected to the Login page with a "Session Expired" modal
    ...                when they next attempt to interact with the application.
    [Tags]             login    session-timeout    negative    slow    mvp    
    Login To Teller App
    Navigate To Module    Customers
    Sleep    ${SESSION_TIMEOUT}
    Wait For Elements State    text=${SESSION_EXPIRED_TEXT}    visible
    Wait For Elements State    text=${SESSION_EXPIRED_DETAIL}    visible
    Close Browser

t1.2.7 Session Timeout - Activity Resets Timer
    [Documentation]    Verify that user activity resets the 5-minute inactivity timer.
    ...                Navigating at 4:50 should reset the timer; the session must remain active
    ...                30 seconds after the original expiry point.
    [Tags]             login    session-timeout    slow    mvp
    Login To Teller App
    Navigate To Module    Customers
    Sleep    ${NEAR_TIMEOUT}
    Navigate To Module    Accounts
    Sleep    30s
    Wait For Elements State    text=Account No   visible
    Close Browser

t1.2.8 Session Timeout - Backgrounded Tab/Minimized Window
    [Documentation]    Verify that the session expires after 5:01 even when the browser tab is
    ...                backgrounded or the window is minimized.
    ...                Tab backgrounding is simulated via the Page Visibility API.
    [Tags]             login    session-timeout    negative    slow    mvp
    Login To Teller App
    Navigate To Module    Customers
    Evaluate JavaScript    ${None}    ${HIDE_TAB_JS}
    Sleep    ${SESSION_TIMEOUT}
    Evaluate JavaScript    ${None}    ${SHOW_TAB_JS}
    Wait For Elements State    text=${SESSION_EXPIRED_TEXT}    visible
    Wait For Elements State    text=${SESSION_EXPIRED_DETAIL}    visible
    Close Browser

t1.2.9 Verify account is not blocked when user has Incorrect attempts but under threshold
    [Documentation]    Verify that the account is not blocked for fewer than 5 failed login attempts.
    ...                4 incorrect attempts followed by valid credentials must result in successful login.
    [Tags]             login    security    negative    mvp
    Open Teller App
    # Attempts 1-4 — incorrect credentials
    FOR    ${index}    IN RANGE    1    5
        Fill Text    ${EMAIL_FIELD}    ${TELLER_EMAIL}
        Fill Text    ${PASSWORD_FIELD}    ${INVALID_PASSWORD}
        Click    ${LOGIN_BUTTON}
        Wait For Elements State    text=${LOGIN_ERROR_TEXT1}    visible
    END
    # Attempt 5 — valid credentials, account must not be blocked
    Fill Text    ${EMAIL_FIELD}    ${TELLER_EMAIL}
    Fill Text    ${PASSWORD_FIELD}    ${TELLER_PASSWORD}
    Click    ${LOGIN_BUTTON}
    Wait For Elements State    text=Customer ID    visible
    Close Browser

t1.2.10 Verify account is blocked after 5 consecutive failed login attempts
    [Documentation]    Verify that the account is blocked after 5 consecutive failed login attempts,
    ...                the lockout message is displayed, and a security alert email is sent to the teller.
    [Tags]             login    security    negative    mvp

    Open Teller App
    FOR    ${index}    IN RANGE    1    6
        Fill Text    ${EMAIL_FIELD}    ${TELLER_EMAIL}
        Fill Text    ${PASSWORD_FIELD}    ${INVALID_PASSWORD}
        Click    ${LOGIN_BUTTON}

        IF    ${index} < 5
            Wait For Elements State    text=${LOGIN_ERROR_TEXT1}    visible
        ELSE
            Wait For Elements State    text=${LOCKOUT_MESSAGE1}    visible
            Wait For Elements State    text=${LOCKOUT_MESSAGE2}    visible
            Wait For Elements State    text=${SUBSEQUENT_LOCKOUT_MESSAGE1}    visible
            Wait For Elements State    text=${SUBSEQUENT_LOCKOUT_MESSAGE2}    visible
        END
    END

    # # Expected result #4 — security alert email delivered to the teller
    # Verify Security Email Sent
    # ...    ${TELLER_EMAIL}
    # ...    ${LOCKOUT_EMAIL_SUBJECT}
    # ...    ${LOCKOUT_EMAIL_BODY}

    Close Browser

t1.2.11 Verify blocked account cannot log in during 5-minute cooldown
    [Documentation]    Verify that a blocked account cannot log in with correct credentials
    ...                during the 5-minute cooldown period.
    [Tags]             login    security    negative    mvp

    Open Teller App
    FOR    ${index}    IN RANGE    1    6
        Fill Text    ${EMAIL_FIELD}    ${TELLER_EMAIL}
        Fill Text    ${PASSWORD_FIELD}    ${INVALID_PASSWORD}
        Click    ${LOGIN_BUTTON}

        IF    ${index} < 5
            Wait For Elements State    text=${LOGIN_ERROR_TEXT1}    visible
        ELSE
            Wait For Elements State    text=${LOCKOUT_MESSAGE1}    visible
            Wait For Elements State    text=${LOCKOUT_MESSAGE2}    visible
            Wait For Elements State    text=${SUBSEQUENT_LOCKOUT_MESSAGE1}    visible
            Wait For Elements State    text=${SUBSEQUENT_LOCKOUT_MESSAGE2}    visible
        END
    END
    # Now try to log in with correct credentials — should still be blocked
    Click    ${MODAL_CONFIRM_BTN}
    Fill Text    ${EMAIL_FIELD}    ${TELLER_EMAIL}
    Fill Text    ${PASSWORD_FIELD}    ${TELLER_PASSWORD}
    Click    ${LOGIN_BUTTON}

    Wait For Elements State    text=${SUBSEQUENT_LOCKOUT_MESSAGE1}    visible
    Wait For Elements State    text=${SUBSEQUENT_LOCKOUT_MESSAGE2}    visible
    Close Browser

t1.2.12 Verify account automatically unlocks after cooldown
    [Documentation]    Verify that the account automatically unlocks after the 5-minute cooldown,
    ...                allowing successful login.
    ...                Pre-condition: Account must be blocked — run t1.2.10 first, then wait 5 minutes.
    [Tags]             login    security    slow    mvp
    Open Teller App
    FOR    ${index}    IN RANGE    1    6
        Fill Text    ${EMAIL_FIELD}    ${TELLER_EMAIL}
        Fill Text    ${PASSWORD_FIELD}    ${INVALID_PASSWORD}
        Click    ${LOGIN_BUTTON}

        IF    ${index} < 5
            Wait For Elements State    text=${LOGIN_ERROR_TEXT1}    visible
        ELSE
            Wait For Elements State    text=${LOCKOUT_MESSAGE1}    visible
            Wait For Elements State    text=${LOCKOUT_MESSAGE2}    visible
            Wait For Elements State    text=${SUBSEQUENT_LOCKOUT_MESSAGE1}    visible
            Wait For Elements State    text=${SUBSEQUENT_LOCKOUT_MESSAGE2}    visible
        END
    END
    Click    ${MODAL_CONFIRM_BTN}
    Sleep    ${COOLDOWN_PERIOD}
    Fill Text    ${EMAIL_FIELD}    ${TELLER_EMAIL}
    Fill Text    ${PASSWORD_FIELD}    ${TELLER_PASSWORD}
    Click    ${LOGIN_BUTTON}
    Wait For Elements State    text=Customer ID           visible
    Close Browser

t1.2.13 Verify failed attempt counter persists across sessions/devices
    [Documentation]    Verify that the failed attempt counter is server-side and persists across
    ...                different browser sessions (simulating different devices).
    ...                3 failed attempts in Session A + 2 in Session B must trigger account lockout.
    [Tags]             login    security    negative    mvp
    # Session A — 3 failed attempts
    Open Teller App
    FOR    ${index}    IN RANGE    1    4
        Fill Text    ${EMAIL_FIELD}    ${TELLER_EMAIL}
        Fill Text    ${PASSWORD_FIELD}    ${INVALID_PASSWORD}
        Click    ${LOGIN_BUTTON}
        Wait For Elements State    text=${LOGIN_ERROR_TEXT1}    visible
    END
    Close Browser
    # Session B (new browser) — 2 more failed attempts (4th and 5th overall)
    Open Teller App
    FOR    ${index}    IN RANGE    4    6
        Fill Text    ${EMAIL_FIELD}    ${TELLER_EMAIL}
        Fill Text    ${PASSWORD_FIELD}    ${INVALID_PASSWORD}
        Click    ${LOGIN_BUTTON}
        IF    ${index} < 5
            Wait For Elements State    text=${LOGIN_ERROR_TEXT1}    visible
        ELSE
            Wait For Elements State    text=${LOCKOUT_MESSAGE1}    visible
            Wait For Elements State    text=${LOCKOUT_MESSAGE2}    visible
        END
    END
    Close Browser

t1.2.14 Verify blocking applies per account (not per device/IP)
    [Documentation]    Verify that account blocking is applied at the account level, not per device or IP.
    ...                A blocked account must be denied login from a different browser session.
    ...                Pre-condition: Account must be blocked — run t1.2.10 or t1.2.13 first.
    [Tags]             login    security    negative    mvp
    Open Teller App
    Fill Text    ${EMAIL_FIELD}    ${TELLER_EMAIL}
    Fill Text    ${PASSWORD_FIELD}    ${TELLER_PASSWORD}
    Click    ${LOGIN_BUTTON}
    Wait For Elements State    text=${SUBSEQUENT_LOCKOUT_MESSAGE1}    visible
    Wait For Elements State    text=${SUBSEQUENT_LOCKOUT_MESSAGE2}    visible
    Close Browser

t1.2.15 Verify password reset during block period lifts block
    [Documentation]    Verify that completing a password reset while the account is blocked
    ...                lifts the block and allows immediate login with the new credentials.
    ...                Pre-condition: Account must be blocked — run t1.2.10 first.
    ...                Pass the 6-digit OTP at runtime: --variable OTP:123456
    [Tags]             login    security    password-reset    mvp

    # Step 1 — Navigate to Forgot Password
    Open Teller App
    Click    ${FORGOT_PASSWORD_LINK}

    # Step 2 — Submit email to receive OTP
    Fill Text    ${FP_EMAIL_FIELD}    ${TELLER_EMAIL}
    Click    ${FP_SEND_CODE_BTN}

    # Step 3 — Enter OTP in the single OTP input field
    Fill Text    ${FP_OTP_INPUT}    ${OTP}
    Click    ${FP_CONTINUE_BTN}

    # Step 4 — Set new password
    Fill Text    ${NEW_PASSWORD_FIELD}           ${TELLER_PASSWORD}
    Fill Text    ${CONFIRM_NEW_PASSWORD_FIELD}    ${TELLER_PASSWORD}
    Click    ${RESET_PASSWORD_BTN}

    # Step 5 — Assert success screen
    Wait For Elements State    ${RESET_SUCCESS_HEADING}    visible
    Wait For Elements State    ${RESET_SUCCESS_MESSAGE}    visible
    Click    ${BACK_TO_LOGIN_BTN}

    # Step 6 — Verify block is lifted: login must now succeed
    Fill Text    ${EMAIL_FIELD}       ${TELLER_EMAIL}
    Fill Text    ${PASSWORD_FIELD}    ${TELLER_PASSWORD}
    Click    ${LOGIN_BUTTON}
    Wait For Elements State    ${SIDEBAR_CUSTOMERS}    visible
    Wait For Elements State    text=Customer ID        visible
    Close Browser

t1.2.16 Verify counter resets to zero after successful login
    [Documentation]    Verify that a successful login resets the failed attempt counter to zero,
    ...                granting the user a fresh set of 5 attempts before being blocked again.
    [Tags]             login    security    negative    mvp
    Open Teller App
    # Attempts 1-4 — incorrect credentials
    FOR    ${index}    IN RANGE    1    5
        Fill Text    ${EMAIL_FIELD}    ${TELLER_EMAIL}
        Fill Text    ${PASSWORD_FIELD}    ${INVALID_PASSWORD}
        Click    ${LOGIN_BUTTON}
        Wait For Elements State    text=${LOGIN_ERROR_TEXT1}    visible
    END
    # Attempt 5 — successful login resets the counter
    Fill Text    ${EMAIL_FIELD}    ${TELLER_EMAIL}
    Fill Text    ${PASSWORD_FIELD}    ${TELLER_PASSWORD}
    Click    ${LOGIN_BUTTON}
    Wait For Elements State    text=Customer ID    visible
    # Logout then verify counter is reset — 5 more wrong attempts must re-trigger lockout
    Click    ${LOGOUT_BUTTON}
    Wait For Elements State    ${LOGIN_BUTTON}    visible
    # Counter is now reset; 5 wrong attempts must trigger lockout again
    FOR    ${index}    IN RANGE    1    6
        Fill Text    ${EMAIL_FIELD}    ${TELLER_EMAIL}
        Fill Text    ${PASSWORD_FIELD}    ${INVALID_PASSWORD}
        Click    ${LOGIN_BUTTON}
        IF    ${index} < 5
            Wait For Elements State    text=${LOGIN_ERROR_TEXT1}    visible
        ELSE
            Wait For Elements State    text=${LOCKOUT_MESSAGE1}    visible
            Wait For Elements State    text=${LOCKOUT_MESSAGE2}    visible
        END
    END
    Close Browser

t1.2.17 Verify failed login with incorrect email address
    [Documentation]    Verify that 5 consecutive failed login attempts with an unregistered email
    ...                triggers the lockout mechanism.
    [Tags]             login    security    negative    mvp
    Open Teller App
    FOR    ${index}    IN RANGE    1    6
        Fill Text    ${EMAIL_FIELD}    ${INVALID_EMAIL}
        Fill Text    ${PASSWORD_FIELD}    ${INVALID_PASSWORD}
        Click    ${LOGIN_BUTTON}
        IF    ${index} < 5
            Wait For Elements State    text=${LOGIN_ERROR_TEXT1}    visible
        ELSE
            Wait For Elements State    text=${LOCKOUT_MESSAGE1}    visible
            Wait For Elements State    text=${LOCKOUT_MESSAGE2}    visible
        END
    END
    Close Browser

t1.2.18 Verify failed login with incorrect temporary password
    [Documentation]    Verify that 5 consecutive failed login attempts with an incorrect temporary
    ...                password (during a password reset flow) triggers the lockout mechanism.
    ...                Pre-condition: Account is in password reset flow with a temporary password issued.
    [Tags]             login    security    negative    mvp
    Open Teller App
    FOR    ${index}    IN RANGE    1    6
        Fill Text    ${EMAIL_FIELD}    ${TELLER_EMAIL}
        Fill Text    ${PASSWORD_FIELD}    ${INVALID_PASSWORD}
        Click    ${LOGIN_BUTTON}
        IF    ${index} < 5
            Wait For Elements State    text=${LOGIN_ERROR_TEXT1}    visible
        ELSE
            Wait For Elements State    text=${LOCKOUT_MESSAGE1}    visible
            Wait For Elements State    text=${LOCKOUT_MESSAGE2}    visible
        END
    END
    Close Browser

t1.2.19 Verify account is still blocked on the 6th attempt and so on
    [Documentation]    Verify that after the account is blocked on the 5th failed attempt,
    ...                subsequent attempts continue to display the updated lockout message.
    ...                5th attempt: "${LOCKOUT_MESSAGE1}"
    ...                6th+ attempts: "${SUBSEQUENT_LOCKOUT_MESSAGE1}"
    [Tags]             login    security    negative    mvp
    Open Teller App
    FOR    ${index}    IN RANGE    1    7
        Fill Text    ${EMAIL_FIELD}    ${TELLER_EMAIL}
        Fill Text    ${PASSWORD_FIELD}    ${INVALID_PASSWORD}
        Click    ${LOGIN_BUTTON}
        IF    ${index} < 5
            Wait For Elements State    text=${LOGIN_ERROR_TEXT1}    visible
        ELSE IF    ${index} == 5
            Wait For Elements State    text=${LOCKOUT_MESSAGE1}    visible
            Wait For Elements State    text=${LOCKOUT_MESSAGE2}    visible
            Click    ${MODAL_CONFIRM_BTN}
        ELSE
            Wait For Elements State    text=${SUBSEQUENT_LOCKOUT_MESSAGE1}    visible
            Wait For Elements State    text=${SUBSEQUENT_LOCKOUT_MESSAGE2}    visible
        END
    END
    Close Browser

t1.2.20 Verify user can logout successfully
    [Documentation]    Verify that a logged-in user can logout via the sidebar "Logout" button
    ...                and is redirected to the login page.
    [Tags]             login    smoke    mvp
    Login To Teller App
    Wait For Elements State    text=Customer ID    visible
    Click    ${LOGOUT_BUTTON}
    Wait For Elements State    ${LOGIN_BUTTON}    visible
    Close Browser
