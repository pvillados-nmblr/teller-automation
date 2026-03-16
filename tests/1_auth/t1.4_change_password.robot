*** Settings ***
Documentation       Test suite for Change Password flow.
...                 Covers happy path, password policy validation, OTP validation, cooldown, and session expiry.
...
...                 NOTE: Locators for this flow use name/text-based selectors as data-testid
...                 attributes have not yet been added. Update common_locators.resource once testids are available.
...
...                 Update OTP in the Variables section before running tests tagged [password-reset].

Resource            ../../resources/keywords/common.resource

Test Teardown       Close Browser


*** Variables ***
${CP_USER_EMAIL}                    pvillados+dfspop2@nmblr.ai
${CP_USER_PASSWORD}                 Password123!!
${CP_NEW_PASSWORD}                  Password123!
${CP_WRONG_CONFIRM_PASSWORD}        WrongPassword999!
${OTP}                              123456

# --- Change Password Form Errors ---
${ERR_PASSWORD_MISMATCH}            Passwords do not match.

# --- Password Policy Errors ---
${ERR_PWD_MIN_LENGTH}               Password must contain a minimum of 8 characters.
${ERR_PWD_UPPERCASE}                Password must include at least one uppercase letter.
${ERR_PWD_NUMBER}                   Password must include at least one number.
${ERR_PWD_SPECIAL}                  Password must include at least one special character.

# --- OTP Errors ---
${ERR_OTP_INVALID}                  OTP is either Invalid or has expired, Please try again.

# --- Max Attempts & Session Errors ---
${ERR_OTP_MAX_ATTEMPTS}             Verification Failed: You have reached the maximum number of attempts. For your security, we're redirecting you to the previous page.
${ERR_OTP_EXPIRED_SESSION}          Your one-time password has expired. Request a new code to continue.


*** Keywords ***
Navigate To Change Password Page
    [Documentation]    Logs in to the teller app, opens the profile dropdown, and navigates
    ...                to the Change Password page.
    Login To Teller App    email=${CP_USER_EMAIL}    password=${CP_USER_PASSWORD}
    Click                       ${CP_PROFILE_DROPDOWN}
    Wait For Elements State     ${CP_CHANGE_PASSWORD_LINK}    visible
    Click                       ${CP_CHANGE_PASSWORD_LINK}
    Wait For Elements State     ${CP_PAGE}    visible

Complete Change Password Form
    [Documentation]    Fills the current password, new password, and confirm password fields,
    ...                then clicks Continue. Leaves the user on the OTP entry screen.
    [Arguments]        ${current_password}=${CP_USER_PASSWORD}    ${new_password}=${CP_NEW_PASSWORD}
    Fill Text                   ${CP_CURRENT_PWD_FIELD}      ${current_password}
    Fill Text                   ${CP_NEW_PWD_FIELD}          ${new_password}
    Fill Text                   ${CP_CONFIRM_PWD_FIELD}      ${new_password}
    Click                       ${CP_CONTINUE_BTN}
    Wait For Elements State     ${CP_OTP_INPUT}    visible

Enter CP OTP And Continue
    [Documentation]    Clicks the OTP input, types the OTP code, and clicks CONTINUE.
    [Arguments]        ${otp}=${OTP}
    Click                       ${CP_OTP_INPUT}
    Keyboard Input              type    ${otp}
    Click                       ${CP_OTP_CONTINUE_BTN}


*** Test Cases ***

# ====================================================================
# HAPPY PATH
# ====================================================================

t1.4.1 Reset Password via Change Password
    [Documentation]    Verify a logged-in teller can successfully change their password via
    ...                the profile dropdown and see the success confirmation modal.
    [Tags]             change-password    smoke    password-reset    mvp

    Navigate To Change Password Page
    Complete Change Password Form
    Enter CP OTP And Continue

    Wait For Elements State     ${CP_SUCCESS_MESSAGE}    visible


# ====================================================================
# CHANGE PASSWORD FORM VALIDATION TESTS
# ====================================================================

t1.4.2 Change Password – Mismatched Password and Confirm Password
    [Documentation]    Verify that entering non-matching values in the New Password and
    ...                Confirm Password fields shows "Passwords do not match." and
    ...                keeps the CONTINUE button disabled.
    [Tags]             change-password    negative    mvp

    Navigate To Change Password Page
    Fill Text                   ${CP_CURRENT_PWD_FIELD}      ${TELLER_PASSWORD}
    Fill Text                   ${CP_NEW_PWD_FIELD}          ${CP_NEW_PASSWORD}
    Fill Text                   ${CP_CONFIRM_PWD_FIELD}      ${CP_WRONG_CONFIRM_PASSWORD}
    # Focus elsewhere to trigger validation
    Focus                       ${CP_CURRENT_PWD_FIELD}

    Wait For Elements State     text=${ERR_PASSWORD_MISMATCH}    visible
    Wait For Elements State     ${CP_CONTINUE_BTN}               disabled

t1.4.3 Change Password – Leave Password Fields Blank
    [Documentation]    Verify the CONTINUE button is disabled when required fields are blank
    ...                on initial page load.
    [Tags]             change-password    negative    mvp

    Navigate To Change Password Page
    # Fields are blank by default upon landing on the page
    Wait For Elements State     ${CP_CONTINUE_BTN}    disabled


# ====================================================================
# PASSWORD POLICY VALIDATION TESTS
# ====================================================================

t1.4.4 Change Password – Password Too Short
    [Documentation]    Verify validation for passwords under 8 characters.
    [Tags]             change-password    negative    mvp

    Navigate To Change Password Page
    Fill Text                   ${CP_NEW_PWD_FIELD}    Abc1!
    Wait For Elements State     text=${ERR_PWD_MIN_LENGTH}    visible
    Wait For Elements State     ${CP_CONTINUE_BTN}            disabled

t1.4.5 Change Password – Password Without Uppercase Letter
    [Documentation]    Verify validation for a password missing an uppercase letter.
    [Tags]             change-password    negative    mvp

    Navigate To Change Password Page
    Fill Text                   ${CP_NEW_PWD_FIELD}    abc12345!
    Wait For Elements State     text=${ERR_PWD_UPPERCASE}    visible
    Wait For Elements State     ${CP_CONTINUE_BTN}           disabled

t1.4.6 Change Password – Password Without Number
    [Documentation]    Verify validation for a password missing a number.
    [Tags]             change-password    negative    mvp

    Navigate To Change Password Page
    Fill Text                   ${CP_NEW_PWD_FIELD}    Abcdefgh!
    Wait For Elements State     text=${ERR_PWD_NUMBER}       visible
    Wait For Elements State     ${CP_CONTINUE_BTN}           disabled

t1.4.7 Change Password – Password Without Special Character
    [Documentation]    Verify validation for a password missing a special character.
    [Tags]             change-password    negative    mvp

    Navigate To Change Password Page
    Fill Text                   ${CP_NEW_PWD_FIELD}    Abcdef123
    Wait For Elements State     text=${ERR_PWD_SPECIAL}      visible
    Wait For Elements State     ${CP_CONTINUE_BTN}           disabled

t1.4.8 Change Password – Sequential Validation of Multiple Violations
    [Documentation]    Verify that only one validation error is shown at a time and errors
    ...                cascade correctly as the user fixes them one by one.
    [Tags]             change-password    negative    mvp

    Navigate To Change Password Page

    # 1. Too short
    Fill Text                   ${CP_NEW_PWD_FIELD}    abc
    Wait For Elements State     text=${ERR_PWD_MIN_LENGTH}    visible

    # 2. Fix length, still missing uppercase
    Fill Text                   ${CP_NEW_PWD_FIELD}    abcdefgh
    Wait For Elements State     text=${ERR_PWD_UPPERCASE}    visible

    # 3. Fix uppercase, still missing number
    Fill Text                   ${CP_NEW_PWD_FIELD}    Abcdefgh
    Wait For Elements State     text=${ERR_PWD_NUMBER}       visible

    # 4. Fix number, still missing special char
    Fill Text                   ${CP_NEW_PWD_FIELD}    Abcdefgh1
    Wait For Elements State     text=${ERR_PWD_SPECIAL}      visible

    # 5. Fix all rules — no error should remain
    Fill Text                   ${CP_NEW_PWD_FIELD}    Abcdefgh1!
    Wait For Elements State     text=${ERR_PWD_SPECIAL}      hidden


# ====================================================================
# OTP VALIDATION & COOLDOWN TESTS
# ====================================================================

t1.4.9 Change Password – Invalid OTP
    [Documentation]    Verify an error message is shown when an incorrect OTP is entered on
    ...                the OTP verification screen.
    [Tags]             change-password    negative    otp    mvp

    Navigate To Change Password Page
    Complete Change Password Form

    Click                       ${CP_OTP_INPUT}
    Keyboard Input              type    999999
    Click                       ${CP_OTP_CONTINUE_BTN}

    Wait For Elements State     text=${ERR_OTP_INVALID}    visible
    Wait For Elements State     ${CP_OTP_INPUT}            visible

t1.4.10 Change Password – Leave OTP Blank
    [Documentation]    Verify the CONTINUE button is disabled when the OTP field is blank.
    [Tags]             change-password    negative    otp    mvp

    Navigate To Change Password Page
    Complete Change Password Form

    # OTP input is blank by default
    Wait For Elements State     ${CP_OTP_CONTINUE_BTN}    disabled
    Wait For Elements State     ${CP_OTP_INPUT}           visible

t1.4.11 Change Password – User Cannot Request a New OTP Before the 1-Minute Cooldown
    [Documentation]    Verify the "Resend code" link is hidden during the 1-minute cooldown
    ...                immediately after the initial OTP is sent.
    [Tags]             change-password    negative    otp    mvp

    Navigate To Change Password Page
    Complete Change Password Form

    # Resend link must not be visible during the active cooldown
    Wait For Elements State     ${CP_OTP_RESEND_BTN}    hidden

t1.4.12 Change Password – User Can Request a New OTP After the Cooldown
    [Documentation]    Verify the user can request a new OTP after the 60-second cooldown
    ...                expires and complete the Change Password flow successfully.
    ...                Note: This test will take > 60 seconds to execute.
    [Tags]             change-password    positive    otp    slow    password-reset    mvp

    Navigate To Change Password Page
    Complete Change Password Form

    # Wait for the 60-second cooldown timer to finish
    Sleep                       61s
    Wait For Elements State     ${CP_OTP_RESEND_BTN}    enabled
    Click                       ${CP_OTP_RESEND_BTN}

    # Enter newly received OTP and complete the flow
    Enter CP OTP And Continue

    Wait For Elements State     ${CP_SUCCESS_MESSAGE}    visible

t1.4.13 Change Password – Previously Received OTP Is No Longer Valid After Requesting a New OTP
    [Documentation]    Verify that the original OTP is invalidated once a new OTP is requested.
    [Tags]             change-password    negative    otp    slow    password-reset    mvp

    Navigate To Change Password Page
    Complete Change Password Form

    # Wait out the cooldown to enable the resend button
    Sleep                       61s
    Wait For Elements State     ${CP_OTP_RESEND_BTN}    enabled
    Click                       ${CP_OTP_RESEND_BTN}

    # Attempt to use the FIRST (now-invalidated) OTP
    Click                       ${CP_OTP_INPUT}
    Keyboard Input              type    ${OTP}
    Click                       ${CP_OTP_CONTINUE_BTN}

    # The old OTP must be rejected
    Wait For Elements State     text=${ERR_OTP_INVALID}    visible

t1.4.14 Change Password – Validation on the 5th Failed OTP Attempt (Maximum Allowed Attempts)
    [Documentation]    Verify the system locks the OTP session and redirects the user after
    ...                5 consecutive failed OTP attempts.
    [Tags]             change-password    negative    otp    security    mvp

    Navigate To Change Password Page
    Complete Change Password Form

    # Execute 5 consecutive invalid OTP attempts
    Wait For Elements State     ${CP_OTP_INPUT}    visible
    FOR    ${i}    IN RANGE    1    6
        Click                   ${CP_OTP_INPUT}
        Keyboard Input          type    00000${i}
        Click                   ${CP_OTP_CONTINUE_BTN}

        IF    ${i} < 5
            Wait For Elements State    text=${ERR_OTP_INVALID}        visible
        ELSE
            Wait For Elements State    text=${ERR_OTP_MAX_ATTEMPTS}   visible
        END
    END

    # Confirm the modal and verify redirection to the Change Password page
    Click                       ${MODAL_CONFIRM_BTN}
    Wait For Elements State     ${CP_PAGE}    visible

t1.4.15 Change Password – Validation on 5th OTP Attempt Across Multiple Resend Requests
    [Documentation]    Verify the 5-attempt limit is strictly enforced across multiple OTP resends.
    [Tags]             change-password    negative    otp    security    slow    mvp

    Navigate To Change Password Page
    Complete Change Password Form

    # 1. First 2 invalid attempts (Attempts 1 & 2)
    Wait For Elements State     ${CP_OTP_INPUT}    visible
    FOR    ${i}    IN RANGE    2
        Click                   ${CP_OTP_INPUT}
        Keyboard Input          type    111111
        Click                   ${CP_OTP_CONTINUE_BTN}
        Wait For Elements State    text=${ERR_OTP_INVALID}    visible
    END

    # 2. First resend (wait for 1-minute cooldown)
    Sleep                       61s
    Wait For Elements State     ${CP_OTP_RESEND_BTN}    enabled
    Click                       ${CP_OTP_RESEND_BTN}

    # 3. Next 2 invalid attempts (Attempts 3 & 4)
    Wait For Elements State     ${CP_OTP_INPUT}    visible
    FOR    ${i}    IN RANGE    2
        Click                   ${CP_OTP_INPUT}
        Keyboard Input          type    222222
        Click                   ${CP_OTP_CONTINUE_BTN}
        Wait For Elements State    text=${ERR_OTP_INVALID}    visible
    END

    # 4. Second resend (wait for 1-minute cooldown)
    Sleep                       61s
    Wait For Elements State     ${CP_OTP_RESEND_BTN}    enabled
    Click                       ${CP_OTP_RESEND_BTN}

    # 5. Final (5th) invalid attempt
    Wait For Elements State     ${CP_OTP_INPUT}    visible
    Click                       ${CP_OTP_INPUT}
    Keyboard Input              type    333333
    Click                       ${CP_OTP_CONTINUE_BTN}

    # Assert failure modal and redirection
    Wait For Elements State     text=${ERR_OTP_MAX_ATTEMPTS}    visible
    Click                       ${MODAL_CONFIRM_BTN}
    Wait For Elements State     ${CP_PAGE}                      visible

t1.4.16 Change Password – Behavior When OTP Session Expires Before Reaching Max Attempts
    [Documentation]    Verify system behavior when a user's OTP session expires before they
    ...                reach the maximum number of failed attempts.
    [Tags]             change-password    negative    otp    security    slow    mvp

    Navigate To Change Password Page
    Complete Change Password Form

    # 1. Execute 3 invalid attempts within the active OTP session
    Wait For Elements State     ${CP_OTP_INPUT}    visible
    FOR    ${i}    IN RANGE    3
        Click                   ${CP_OTP_INPUT}
        Keyboard Input          type    444444
        Click                   ${CP_OTP_CONTINUE_BTN}
        Wait For Elements State    text=${ERR_OTP_INVALID}    visible
    END

    # 2. Wait for the OTP session to expire (5 minutes)
    Sleep                       300s

    # 3. Attempt a 4th input after session expiry
    Click                       ${CP_OTP_INPUT}
    Keyboard Input              type    555555
    Click                       ${CP_OTP_CONTINUE_BTN}
    Wait For Elements State     text=${ERR_OTP_INVALID}    visible

    # 4. Click "Resend code" — session has expired
    Click                       ${CP_OTP_RESEND_BTN}

    # 5. Assert the expired session modal appears
    Wait For Elements State     text=${ERR_OTP_EXPIRED_SESSION}    visible

    # 6. Click "Request New Code" — should redirect back to Change Password page
    Click                       text=Request New Code
    Wait For Elements State     ${CP_PAGE}    visible
