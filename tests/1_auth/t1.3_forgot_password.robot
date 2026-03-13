*** Settings ***
Documentation       Test suite for Forgot Password flow.
...                 Covers happy path reset, case-insensitive email, unregistered email,
...                 blank/invalid email format, and mismatched password validation.
...
...                 Tests tagged [password-reset] require a live OTP.
...                 Pass it at runtime: --variable OTP:123456

Resource            ../../resources/keywords/common.resource

Test Teardown       Close Browser


*** Variables ***
${NEW_PASSWORD}              Password123!
${FP_MIXED_CASE_EMAIL}              Pvillados+U1@Agsx.Net
${FP_INVALID_FORMAT_EMAIL}          notanemail
${FP_WRONG_CONFIRM_PASSWORD}        WrongPassword999!
${ERR_UNREGISTERED_EMAIL}           Email address is invalid, please try again.
${ERR_EMAIL_REQUIRED}               Email is required.
${ERR_INVALID_EMAIL_FORMAT}         Invalid email format.
${ERR_PASSWORD_MISMATCH}            Passwords do not match
${OTP}                              123456
# --- Password Validation Errors ---
${ERR_PWD_MIN_LENGTH}               Password must contain a minimum of 8 characters.
${ERR_PWD_UPPERCASE}                Password must include at least one uppercase letter.
${ERR_PWD_NUMBER}                   Password must include at least one number.
${ERR_PWD_SPECIAL}                  Password must include at least one special character.

# --- OTP Errors ---
${ERR_OTP_INVALID}                  OTP is either invalid or has expired, Please try again.

# --- Max Attempts & Session Errors ---
${ERR_OTP_MAX_ATTEMPTS}             Verification Failed: You have reached the maximum number of attempts. For your security, we’re redirecting you to the previous page.
${ERR_OTP_EXPIRED_SESSION}          Your one-time password has expired. Request a new code to continue.


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
    Wait For Elements State     ${FP_OTP_INPUT}      visible
    Click                       ${FP_OTP_INPUT}
    Keyboard Input              type    ${OTP}
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
    Fill Text                   ${NEW_PASSWORD_FIELD}           ${NEW_PASSWORD}
    Fill Text                   ${CONFIRM_NEW_PASSWORD_FIELD}   ${NEW_PASSWORD}
    Click                       ${RESET_PASSWORD_BTN}

    # Assert success screen
    Wait For Elements State     ${RESET_SUCCESS_HEADING}    visible
    Wait For Elements State     ${RESET_SUCCESS_MESSAGE}    visible
    Wait For Elements State     ${BACK_TO_LOGIN_BTN}        visible
    Click                       ${BACK_TO_LOGIN_BTN}
    Wait For Elements State     ${LOGIN_PAGE}               visible

t1.3.2 Verify System Treats Email as Case-Insensitive During Forgot Password
    [Documentation]    Verify that the system recognises a mixed-case email address during the
    ...                Forgot Password flow and sends the OTP successfully.
    [Tags]             forgot-password    smoke    password-reset

    Navigate To Forgot Password Page
    Complete OTP Verification    email=${FP_MIXED_CASE_EMAIL}

    # Create new password
    Fill Text                   ${NEW_PASSWORD_FIELD}           ${NEW_PASSWORD}
    Fill Text                   ${CONFIRM_NEW_PASSWORD_FIELD}   ${NEW_PASSWORD}
    Click                       ${RESET_PASSWORD_BTN}

    # Assert success screen
    Wait For Elements State     ${RESET_SUCCESS_HEADING}    visible
    Wait For Elements State     ${RESET_SUCCESS_MESSAGE}    visible
    Wait For Elements State     ${BACK_TO_LOGIN_BTN}        visible
    Click                       ${BACK_TO_LOGIN_BTN}
    Wait For Elements State     ${LOGIN_PAGE}               visible

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

t1.3.5 Forgot Password – Invalid Email Format
    [Documentation]    Verify that typing an email with an invalid format triggers the
    ...                "Invalid email format." inline validation error and disables the button.
    [Tags]             forgot-password    negative    mvp

    Navigate To Forgot Password Page
    Fill Text                   ${FP_EMAIL_FIELD}    ${FP_INVALID_FORMAT_EMAIL}
    # Button should be disabled when email format is invalid
    Wait For Elements State     ${FP_SEND_CODE_BTN}    disabled
    Wait For Elements State     text=${ERR_INVALID_EMAIL_FORMAT}    visible

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
    # Focus elsewhere to trigger validation
    Focus                       ${NEW_PASSWORD_FIELD}

    # Assert inline error and disabled submit button
    Wait For Elements State     text=${ERR_PASSWORD_MISMATCH}    visible
    Wait For Elements State     ${RESET_PASSWORD_BTN}            disabled

# ====================================================================
# PASSWORD POLICY VALIDATION TESTS (Mapped from t1.1.7 - t1.1.12)
# ====================================================================

t1.3.7 Reset Password – Leave Required Fields Blank
    [Documentation]    Verify the RESET PASSWORD button is disabled when fields are blank.
    [Tags]             forgot-password    negative    password-reset

    Navigate To Forgot Password Page
    Complete OTP Verification
    
    # Fields are blank by default upon reaching this page
    Wait For Elements State     ${RESET_PASSWORD_BTN}    disabled

t1.3.8 Reset Password – Password Too Short
    [Documentation]    Verify validation for passwords under 8 characters.
    [Tags]             forgot-password    negative    password-reset

    Navigate To Forgot Password Page
    Complete OTP Verification
    
    Fill Text                   ${NEW_PASSWORD_FIELD}    Abc1!
    Wait For Elements State     text=${ERR_PWD_MIN_LENGTH}    visible
    Wait For Elements State     ${RESET_PASSWORD_BTN}         disabled

t1.3.9 Reset Password – Password Without Uppercase Letter
    [Documentation]    Verify validation for missing uppercase letter.
    [Tags]             forgot-password    negative    password-reset

    Navigate To Forgot Password Page
    Complete OTP Verification
    
    Fill Text                   ${NEW_PASSWORD_FIELD}    abc12345!
    Wait For Elements State     text=${ERR_PWD_UPPERCASE}     visible
    Wait For Elements State     ${RESET_PASSWORD_BTN}         disabled

t1.3.10 Reset Password – Password Without Number
    [Documentation]    Verify validation for missing number.
    [Tags]             forgot-password    negative    password-reset

    Navigate To Forgot Password Page
    Complete OTP Verification
    
    Fill Text                   ${NEW_PASSWORD_FIELD}    Abcdefgh!
    Wait For Elements State     text=${ERR_PWD_NUMBER}        visible
    Wait For Elements State     ${RESET_PASSWORD_BTN}         disabled

t1.3.11 Reset Password – Password Without Special Character
    [Documentation]    Verify validation for missing special character.
    [Tags]             forgot-password    negative    password-reset

    Navigate To Forgot Password Page
    Complete OTP Verification
    
    Fill Text                   ${NEW_PASSWORD_FIELD}    Abcdef123
    Wait For Elements State     text=${ERR_PWD_SPECIAL}       visible
    Wait For Elements State     ${RESET_PASSWORD_BTN}         disabled

t1.3.12 Reset Password – Sequential Validation of Multiple Violations
    [Documentation]    Verify errors cascade correctly as the user fixes them one by one.
    [Tags]             forgot-password    negative    password-reset

    Navigate To Forgot Password Page
    Complete OTP Verification
    
    # 1. Too short
    Fill Text                   ${NEW_PASSWORD_FIELD}    abc
    Wait For Elements State     text=${ERR_PWD_MIN_LENGTH}    visible
    
    # 2. Fix length, missing uppercase
    Fill Text                   ${NEW_PASSWORD_FIELD}    abcdefgh
    Wait For Elements State     text=${ERR_PWD_UPPERCASE}     visible
    
    # 3. Fix uppercase, missing number
    Fill Text                   ${NEW_PASSWORD_FIELD}    Abcdefgh
    Wait For Elements State     text=${ERR_PWD_NUMBER}        visible
    
    # 4. Fix number, missing special char
    Fill Text                   ${NEW_PASSWORD_FIELD}    Abcdefgh1
    Wait For Elements State     text=${ERR_PWD_SPECIAL}       visible
    
    # 5. Fix all rules
    Fill Text                   ${NEW_PASSWORD_FIELD}    Abcdefgh1!
    Wait For Elements State     text=${ERR_PWD_SPECIAL}       hidden


# ====================================================================
# OTP VALIDATION & COOLDOWN TESTS (Mapped from t1.1.13 - t1.1.17)
# ====================================================================

t1.3.13 Reset Password – Invalid OTP
    [Documentation]    Verify error message when an incorrect OTP is entered.
    [Tags]             forgot-password    negative    otp    requires-otp-validation

    Navigate To Forgot Password Page
    Fill Text                   ${FP_EMAIL_FIELD}    ${TELLER_EMAIL}
    Click                       ${FP_SEND_CODE_BTN}

    Wait For Elements State     ${FP_OTP_INPUT}      visible
    Click                       ${FP_OTP_INPUT}
    Keyboard Input              type    999999
    Click                       ${FP_CONTINUE_BTN}

    Wait For Elements State     text=${ERR_OTP_INVALID}       visible
    Wait For Elements State     ${FP_OTP_INPUT}               visible

t1.3.14 Reset Password – Leave OTP Blank
    [Documentation]    Verify CONTINUE button is disabled if OTP is blank.
    [Tags]             forgot-password    negative    otp

    Navigate To Forgot Password Page
    Fill Text                   ${FP_EMAIL_FIELD}    ${TELLER_EMAIL}
    Click                       ${FP_SEND_CODE_BTN}
    
    # OTP input is blank by default
    Wait For Elements State     ${FP_CONTINUE_BTN}            disabled
    Wait For Elements State     ${FP_OTP_INPUT}               visible

t1.3.15 Reset Password – Cooldown Prevents Immediate Resend
    [Documentation]    Verify the "Request a new OTP" link is hidden/disabled during the 1-minute cooldown.
    [Tags]             forgot-password    negative    otp

    Navigate To Forgot Password Page
    Fill Text                   ${FP_EMAIL_FIELD}    ${TELLER_EMAIL}
    Click                       ${FP_SEND_CODE_BTN}
    
    Wait For Elements State     ${FP_RESEND_BTN}              hidden

t1.3.16 Reset Password – Request New OTP After Cooldown
    [Documentation]    Verify the user can request a new OTP after the 60-second cooldown expires.
    ...                Note: This test will take > 60 seconds to execute.
    [Tags]             forgot-password    positive    otp    slow

    Navigate To Forgot Password Page
    Fill Text                   ${FP_EMAIL_FIELD}    ${TELLER_EMAIL}
    Click                       ${FP_SEND_CODE_BTN}
    
    # Wait for the 60-second cooldown timer to finish
    Sleep                       61s
    Wait For Elements State     ${FP_RESEND_BTN}              enabled
    Click                       ${FP_RESEND_BTN}
    
    # Verify system confirms a new code was sent
    # Note: Replace this assertion if a specific Toast/Message appears
    Wait For Elements State     ${FP_CONTINUE_BTN}            disabled 

t1.3.17 Reset Password – Old OTP Invalidated After Resend
    [Documentation]    Verify the first OTP becomes invalid if a second one is requested.
    [Tags]             forgot-password    negative    otp    slow    requires-otp-validation

    Navigate To Forgot Password Page
    Fill Text                   ${FP_EMAIL_FIELD}    ${TELLER_EMAIL}
    Click                       ${FP_SEND_CODE_BTN}

    # Wait out the timer to request a second OTP
    Sleep                       61s
    Wait For Elements State     ${FP_RESEND_BTN}              enabled
    Click                       ${FP_RESEND_BTN}

    # Attempt to use the FIRST OTP
    Wait For Elements State     ${FP_OTP_INPUT}      visible
    Click                       ${FP_OTP_INPUT}
    Keyboard Input              type    ${OTP}
    Click                       ${FP_CONTINUE_BTN}

    # Expect failure because the first OTP was invalidated
    Wait For Elements State     text=${ERR_OTP_INVALID}       visible


t1.3.18 Reset Password – Validation on the 5th failed OTP attempt (maximum allowed attempts)
    [Documentation]    Verify session lock and redirection after 5 consecutive wrong OTPs.
    [Tags]             forgot-password    negative    otp    security    requires-otp-validation

    Navigate To Forgot Password Page
    Fill Text                   ${FP_EMAIL_FIELD}    ${TELLER_EMAIL}
    Click                       ${FP_SEND_CODE_BTN}

    # Execute 5 invalid attempts
    Wait For Elements State     ${FP_OTP_INPUT}      visible
    FOR    ${i}    IN RANGE    1    6
        Click                       ${FP_OTP_INPUT}
        Keyboard Input              type    00000${i}
        Click                       ${FP_CONTINUE_BTN}

        IF    ${i} < 5
            Wait For Elements State    text=${ERR_OTP_INVALID}         visible
        ELSE
            # On the 5th attempt, verify the maximum attempts error message
            Wait For Elements State    text=${ERR_OTP_MAX_ATTEMPTS}    visible
        END
    END

    # Click CONFIRM on the modal and verify redirection to the Reset Password (FP) page
    Click                       ${MODAL_CONFIRM_BTN}
    Wait For Elements State     ${FP_PAGE}                             visible

t1.3.19 Reset Password – Validation on 5th OTP attempt across multiple resend requests
    [Documentation]    Verify the 5-attempt limit is strictly enforced across multiple OTP resends.
    [Tags]             forgot-password    negative    otp    security    slow    requires-otp-validation

    Navigate To Forgot Password Page
    Fill Text                   ${FP_EMAIL_FIELD}    ${TELLER_EMAIL}
    Click                       ${FP_SEND_CODE_BTN}

    # 1. First 2 invalid attempts
    Wait For Elements State     ${FP_OTP_INPUT}      visible
    FOR    ${i}    IN RANGE    2
        Click                       ${FP_OTP_INPUT}
        Keyboard Input              type    111111
        Click                       ${FP_CONTINUE_BTN}
        Wait For Elements State    text=${ERR_OTP_INVALID}    visible
    END

    # 2. First Resend (Wait for 1-minute cooldown)
    Sleep                       61s
    Click                       ${FP_RESEND_BTN}

    # 3. Next 2 invalid attempts (Attempts 3 & 4)
    Wait For Elements State     ${FP_OTP_INPUT}      visible
    FOR    ${i}    IN RANGE    2
        Click                       ${FP_OTP_INPUT}
        Keyboard Input              type    222222
        Click                       ${FP_CONTINUE_BTN}
        Wait For Elements State    text=${ERR_OTP_INVALID}    visible
    END

    # 4. Second Resend (Wait for 1-minute cooldown)
    Sleep                       61s
    Click                       ${FP_RESEND_BTN}

    # 5. Final (5th) invalid attempt
    Wait For Elements State     ${FP_OTP_INPUT}      visible
    Click                       ${FP_OTP_INPUT}
    Keyboard Input              type    333333
    Click                       ${FP_CONTINUE_BTN}

    # Assert failure modal and redirection
    Wait For Elements State     text=${ERR_OTP_MAX_ATTEMPTS}    visible
    Click                       ${MODAL_CONFIRM_BTN}
    Wait For Elements State     ${FP_PAGE}                      visible

t1.3.20 Reset Password – Behavior when OTP session expires before reaching max attempts
    [Documentation]    Verify system behavior when a user attempts to input an OTP after the 5-minute session expires.
    [Tags]             forgot-password    negative    otp    security    slow    requires-otp-validation

    Navigate To Forgot Password Page
    Fill Text                   ${FP_EMAIL_FIELD}    ${TELLER_EMAIL}
    Click                       ${FP_SEND_CODE_BTN}

    # 1. Execute 3 invalid attempts within active session
    Wait For Elements State     ${FP_OTP_INPUT}      visible
    FOR    ${i}    IN RANGE    3
        Click                       ${FP_OTP_INPUT}
        Keyboard Input              type    444444
        Click                       ${FP_CONTINUE_BTN}
        Wait For Elements State    text=${ERR_OTP_INVALID}    visible
    END

    # 2. Wait for OTP session to expire (5 minutes)
    Sleep                       240s

    # 3. Attempt 4th input after session expiry
    Click                       ${FP_OTP_INPUT}
    Keyboard Input              type    555555
    Click                       ${FP_CONTINUE_BTN}
    Wait For Elements State     text=${ERR_OTP_INVALID}    visible

    # 4. Click Resend after session has expired
    Click                       ${FP_RESEND_BTN}

    # 5. Assert expired session modal appears
    Wait For Elements State     text=${ERR_OTP_EXPIRED_SESSION}    visible

    # 6. Click "Request New Code" (Using text locator as specified in manual step 3)
    Click                       text=Request New Code

    # Assert redirection to Login screen
    Wait For Elements State     ${LOGIN_PAGE}                      visible
    Close Browser