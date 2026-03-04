*** Settings ***
Documentation       Test suite for Forgot Password flow.
...                 Covers happy path reset, case-insensitive email, unregistered email,
...                 blank/invalid email format, and mismatched password validation.
...
...                 Tests tagged [password-reset] require a live OTP.
...                 Pass it at runtime: --variable OTP:123456

Resource            ../../resources/keywords/common.resource

Suite Teardown      Close Browser


*** Variables ***
${FP_MIXED_CASE_EMAIL}              Pvillados@Agsx.Net
${FP_INVALID_FORMAT_EMAIL}          notanemail
${FP_WRONG_CONFIRM_PASSWORD}        WrongPassword999!
${ERR_UNREGISTERED_EMAIL}           Email address is invalid, please try again.
${ERR_EMAIL_REQUIRED}               Email is required.
${ERR_INVALID_EMAIL_FORMAT}         Invalid email format.
${ERR_PASSWORD_MISMATCH}            Passwords do not match.
${OTP}                              ${EMPTY}    # Pass at runtime: --variable OTP:123456


*** Keywords ***
Navigate To Forgot Password Page
    [Documentation]    Opens the app and navigates to the Reset your password screen.
    Open Teller App
    Click                       ${FORGOT_PASSWORD_LINK}
    Wait For Elements State     ${FP_PAGE}    visible

Complete OTP Verification
    [Documentation]    Fills in email, requests OTP, enters OTP, and clicks CONTINUE.
    ...                Leaves the user on the Create new password screen.
    [Arguments]        ${email}=${TELLER_EMAIL}
    Fill Text                   ${FP_EMAIL_FIELD}    ${email}
    Click                       ${FP_SEND_CODE_BTN}
    Fill Text                   ${FP_OTP_INPUT}      ${OTP}
    Click                       ${FP_CONTINUE_BTN}
    Wait For Elements State     ${NEW_PASSWORD_FIELD}    visible


*** Test Cases ***

t1.3.1 Reset Password via Forgot Password
    [Documentation]    Verify that a registered teller can successfully reset their password
    ...                via the Forgot Password flow and see the success confirmation screen.
    [Tags]             forgot-password    smoke    password-reset

    Navigate To Forgot Password Page
    Complete OTP Verification

    # Create new password
    Fill Text                   ${NEW_PASSWORD_FIELD}           ${TELLER_PASSWORD}
    Fill Text                   ${CONFIRM_NEW_PASSWORD_FIELD}   ${TELLER_PASSWORD}
    Click                       ${RESET_PASSWORD_BTN}

    # Assert success screen
    Wait For Elements State     ${RESET_SUCCESS_HEADING}    visible
    Wait For Elements State     ${RESET_SUCCESS_MESSAGE}    visible
    Wait For Elements State     ${BACK_TO_LOGIN_BTN}        visible
    Click                       ${BACK_TO_LOGIN_BTN}
    Wait For Elements State     ${LOGIN_PAGE}               visible
    Close Browser

t1.3.2 Verify System Treats Email as Case-Insensitive During Forgot Password
    [Documentation]    Verify that the system recognises a mixed-case email address during the
    ...                Forgot Password flow and sends the OTP successfully.
    [Tags]             forgot-password    smoke    password-reset

    Navigate To Forgot Password Page
    Complete OTP Verification    email=${FP_MIXED_CASE_EMAIL}

    # Create new password
    Fill Text                   ${NEW_PASSWORD_FIELD}           ${TELLER_PASSWORD}
    Fill Text                   ${CONFIRM_NEW_PASSWORD_FIELD}   ${TELLER_PASSWORD}
    Click                       ${RESET_PASSWORD_BTN}

    # Assert success screen
    Wait For Elements State     ${RESET_SUCCESS_HEADING}    visible
    Wait For Elements State     ${RESET_SUCCESS_MESSAGE}    visible
    Wait For Elements State     ${BACK_TO_LOGIN_BTN}        visible
    Click                       ${BACK_TO_LOGIN_BTN}
    Wait For Elements State     ${LOGIN_PAGE}               visible
    Close Browser

t1.3.3 Forgot Password with Unregistered Email
    [Documentation]    Verify that entering an unregistered email on the Reset your password
    ...                screen shows an error and does not send an OTP.
    [Tags]             forgot-password    negative    mvp

    Navigate To Forgot Password Page
    Fill Text                   ${FP_EMAIL_FIELD}    ${INVALID_EMAIL}
    Click                       ${FP_SEND_CODE_BTN}
    Wait For Elements State     text=${ERR_UNREGISTERED_EMAIL}    visible
    # OTP screen must NOT appear
    Wait For Elements State     ${FP_OTP_INPUT}    hidden
    Close Browser

t1.3.4 Forgot Password – Blank Email Field
    [Documentation]    Verify that the Send Verification Code button remains disabled
    ...                when the email field is empty.
    [Tags]             forgot-password    negative    mvp

    Navigate To Forgot Password Page
    # Button should be disabled on initial load (empty email)
    Wait For Elements State     ${FP_SEND_CODE_BTN}    disabled
    # Type then clear to verify it stays disabled
    Fill Text                   ${FP_EMAIL_FIELD}    test@example.com
    Fill Text                   ${FP_EMAIL_FIELD}    ${EMPTY}
    Wait For Elements State     ${FP_SEND_CODE_BTN}    disabled
    Close Browser

t1.3.5 Forgot Password – Invalid Email Format
    [Documentation]    Verify that typing an email with an invalid format triggers the
    ...                "Invalid email format." inline validation error and disables the button.
    [Tags]             forgot-password    negative    mvp

    Navigate To Forgot Password Page
    Fill Text                   ${FP_EMAIL_FIELD}    ${FP_INVALID_FORMAT_EMAIL}
    # Button should be disabled when email format is invalid
    Wait For Elements State     ${FP_SEND_CODE_BTN}    disabled
    Wait For Elements State     text=${ERR_INVALID_EMAIL_FORMAT}    visible
    Close Browser

t1.3.6 Forgot Password – Mismatched Password and Confirm Password
    [Documentation]    Verify that entering non-matching values in the New password and
    ...                Confirm new password fields shows "Passwords do not match." and
    ...                keeps the RESET PASSWORD button disabled.
    [Tags]             forgot-password    negative    password-reset

    Navigate To Forgot Password Page
    Complete OTP Verification

    # Enter mismatched passwords
    Fill Text                   ${NEW_PASSWORD_FIELD}           ${TELLER_PASSWORD}
    Fill Text                   ${CONFIRM_NEW_PASSWORD_FIELD}   ${FP_WRONG_CONFIRM_PASSWORD}

    # Assert inline error and disabled submit button
    Wait For Elements State     text=${ERR_PASSWORD_MISMATCH}    visible
    Wait For Elements State     ${RESET_PASSWORD_BTN}            disabled
    Close Browser
