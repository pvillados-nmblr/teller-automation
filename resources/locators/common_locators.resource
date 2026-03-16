*** Variables ***

# ============================================================
# LOGIN PAGE
# data-testid attributes added by dev — AUTH_TEST_IDS.login
# ============================================================

# ${LOGIN_PAGE}                       css=[data-testid="page-login"]                          # TODO: restore when data-testid is available
${LOGIN_PAGE}                       css=input[name="email"]
# ${EMAIL_FIELD}                      css=[data-testid="input-login-email"]                   # TODO: restore when data-testid is available
${EMAIL_FIELD}                      css=input[name="email"]
# ${PASSWORD_FIELD}                   css=[data-testid="input-login-password"]                # TODO: restore when data-testid is available
${PASSWORD_FIELD}                   css=input[name="password"]
# ${LOGIN_BUTTON}                     css=[data-testid="btn-login-submit"]                    # TODO: restore when data-testid is available
${LOGIN_BUTTON}                     css=#btn:has-text("LOG IN")
# ${FORGOT_PASSWORD_LINK}             css=[data-testid="link-login-forgot-password"]          # TODO: restore when data-testid is available
${FORGOT_PASSWORD_LINK}             css=h2:has-text("Forgot password?")
# ${LOGIN_ERROR_MODAL}                css=[data-testid="modal-login-error"]                   # TODO: restore when data-testid is available
${LOGIN_ERROR_MODAL}                css=.ant-modal-content


# ============================================================
# FORGOT PASSWORD — Step 1: Request OTP
# data-testid attributes — AUTH_TEST_IDS.forgotPassword
# ============================================================

# ${FP_PAGE}                          css=[data-testid="page-forgot-password"]                # TODO: restore when data-testid is available
${FP_PAGE}                          css=h2:has-text("Reset your password")
# ${FP_EMAIL_FIELD}                   css=[data-testid="input-forgot-password-email"]         # TODO: restore when data-testid is available
${FP_EMAIL_FIELD}                   css=input[name="email"]
# ${FP_SEND_CODE_BTN}                 css=[data-testid="btn-forgot-password-send-code"]       # TODO: restore when data-testid is available
${FP_SEND_CODE_BTN}                 css=button:has-text("Send Verification Code")


# ============================================================
# FORGOT PASSWORD — Step 2: Verify OTP
# Note: OTP is a single input field (not 6 separate boxes)
# ============================================================

${FP_OTP_INPUT}                     css=input[aria-label="Please enter OTP character 1"]
# ${FP_CONTINUE_BTN}                  css=[data-testid="btn-forgot-password-otp-continue"]    # TODO: restore when data-testid is available
${FP_CONTINUE_BTN}                  text=CONTINUE
# ${FP_RESEND_BTN}                    css=[data-testid="btn-forgot-password-otp-resend"]      # TODO: restore when data-testid is available
${FP_RESEND_BTN}                    text=Resend code


# ============================================================
# FORGOT PASSWORD — Step 3: Change Password
# ============================================================

# ${NEW_PASSWORD_FIELD}               css=[data-testid="input-forgot-password-new-password"]       # TODO: restore when data-testid is available
${NEW_PASSWORD_FIELD}               css=input[name="newPassword"]
# ${CONFIRM_NEW_PASSWORD_FIELD}       css=[data-testid="input-forgot-password-confirm-password"]   # TODO: restore when data-testid is available
${CONFIRM_NEW_PASSWORD_FIELD}       css=input[name="confirmNewPassword"]
# ${RESET_PASSWORD_BTN}               css=[data-testid="btn-forgot-password-reset"]                # TODO: restore when data-testid is available
${RESET_PASSWORD_BTN}               css=button[type="submit"]
${RESET_SUCCESS_HEADING}            text=Success!
${RESET_SUCCESS_MESSAGE}            text=Password has been changed successfully.
${BACK_TO_LOGIN_BTN}                text=Back to Login


# ============================================================
# RESET TEMPORARY PASSWORD FLOW
# data-testid attributes — AUTH_TEST_IDS.resetTemporaryPassword
# ============================================================

# ${RTP_PAGE}                         css=[data-testid="page-reset-temporary-password"]               # TODO: restore when data-testid is available
${RTP_PAGE}                         css=h3.text-2xl:has-text("Reset")
# ${RTP_TEMP_PASSWORD_FIELD}          css=[data-testid="input-reset-temp-password-current"]           # TODO: restore when data-testid is available
${RTP_TEMP_PASSWORD_FIELD}          css=input[name="currentPassword"]
# ${RTP_NEW_PASSWORD_FIELD}           css=[data-testid="input-reset-temp-password-new"]               # TODO: restore when data-testid is available
${RTP_NEW_PASSWORD_FIELD}           css=input[name="newPassword"]
# ${RTP_CONFIRM_PASSWORD_FIELD}       css=[data-testid="input-reset-temp-password-confirm"]           # TODO: restore when data-testid is available
${RTP_CONFIRM_PASSWORD_FIELD}       css=input[name="confirmNewPassword"]
# ${RTP_SUBMIT_BTN}                   css=[data-testid="btn-reset-temp-password-submit"]              # TODO: restore when data-testid is available
${RTP_SUBMIT_BTN}                   css=button[type="submit"]
# ${RTP_OTP_INPUT}                    css=[data-testid="input-reset-temp-password-otp"] input[aria-label="Please enter OTP character 1"]    # TODO: restore when data-testid is available
${RTP_OTP_INPUT}                    css=input[aria-label="Please enter OTP character 1"]
# ${RTP_OTP_CONTINUE_BTN}             css=[data-testid="btn-reset-temp-password-otp-continue"]       # TODO: restore when data-testid is available
${RTP_OTP_CONTINUE_BTN}             text=CONTINUE
# ${RTP_OTP_RESEND_BTN}               css=[data-testid="btn-reset-temp-password-otp-resend"]         # TODO: restore when data-testid is available
${RTP_OTP_RESEND_BTN}               text=Resend code


# ============================================================
# CHANGE PASSWORD FLOW
# No data-testid attributes yet — selectors will be updated once added by dev.
# ============================================================

${CP_PROFILE_DROPDOWN}              css=svg[data-icon="chevron-down"]
# ${CP_CHANGE_PASSWORD_LINK}          css=[data-testid="menu-item-user-change-password"]      # TODO: restore when data-testid is available
${CP_CHANGE_PASSWORD_LINK}          css=.ant-dropdown-menu li:has-text("Change Password")
${CP_PAGE}                          css=h3.text-2xl:has-text("Change Password")
${CP_CURRENT_PWD_FIELD}             css=input[name="currentPassword"]
${CP_NEW_PWD_FIELD}                 css=input[name="newPassword"]
${CP_CONFIRM_PWD_FIELD}             css=input[name="confirmNewPassword"]
${CP_CONTINUE_BTN}                  css=button[type="submit"]
${CP_OTP_INPUT}                     css=input[aria-label="Please enter OTP character 1"]
${CP_OTP_CONTINUE_BTN}              text=CONTINUE
${CP_OTP_RESEND_BTN}                text=Resend code
${CP_SUCCESS_MESSAGE}               text=Password has been changed succesfully.


# ============================================================
# NAVIGATION / SIDEBAR
# No testids provided — AntD class selectors remain.
# ============================================================

${SIDEBAR_MENU_ITEM}                css=.ant-menu-title-content
${SIDEBAR_CUSTOMERS}                css=.ant-menu-title-content >> text=Customers
${SIDEBAR_ACCOUNTS}                 css=.ant-menu-title-content >> text=Accounts
${SIDEBAR_TRANSACTIONS}             css=.ant-menu-title-content >> text=Transactions
${SIDEBAR_PRODUCTS}                 css=.ant-menu-title-content >> text=Products
${SIDEBAR_LOANS}                    css=.ant-menu-title-content >> text=Loans
${SIDEBAR_REPORTS}                  css=.ant-menu-title-content >> text=Reports
${LOGOUT_BUTTON}                    text=Log out


# ============================================================
# ANT DESIGN MODAL
# No testids provided — AntD class selectors remain.
# ============================================================

${MODAL}                            css=.ant-modal-content
${MODAL_TITLE}                      css=.ant-modal-title
${MODAL_CONFIRM_BTN}                xpath=//button[.//span[text()='CONFIRM'] or text()='CONFIRM']
${MODAL_CANCEL_BTN}                 xpath=//button[.//span[text()='CANCEL'] or text()='CANCEL']
${MODAL_OK_BTN}                     css=.ant-modal-footer button.ant-btn-primary
${MODAL_CLOSE_BTN}                  css=.ant-modal-close


# ============================================================
# ANT DESIGN TOAST MESSAGES
# No testids provided — AntD class selectors remain.
# ============================================================

${SUCCESS_TOAST}                    css=.ant-message-success
${ERROR_TOAST}                      css=.ant-message-error
${WARNING_TOAST}                    css=.ant-message-warning


# ============================================================
# CUSTOMERS MODULE
# data-testid attributes — CUSTOMER_TEST_IDS
# ============================================================

# ${CUSTOMERS_LIST_PAGE}              css=[data-testid="page-customers-list"]                  # TODO: restore when data-testid is available
${CUSTOMERS_LIST_PAGE}              css=.ant-table-body table
# ${CUSTOMERS_PROFILE_PAGE}           css=[data-testid="page-customers-profile"]               # TODO: restore when data-testid is available
${CUSTOMERS_PROFILE_PAGE}           text=Banking Details
# ${CUSTOMERS_ACCOUNTS_PAGE}          css=[data-testid="page-customers-accounts"]              # TODO: restore when data-testid is available
${CUSTOMERS_ACCOUNTS_PAGE}          css=input[placeholder="Search accounts..."]
# ${CUSTOMERS_TRANSACTIONS_PAGE}      css=[data-testid="page-customers-account-transactions"]  # TODO: restore when data-testid is available
${CUSTOMERS_TRANSACTIONS_PAGE}      css=input[placeholder="Search transactions..."]
# ${AVAIL_PRODUCT_PAGE}               css=[data-testid="page-customers-avail-product"]         # TODO: restore when data-testid is available
${AVAIL_PRODUCT_PAGE}               css=h3.text-2xl:has-text("Avail")
# ${AVAIL_PRODUCT_STEPS}              css=[data-testid="steps-avail-product"]                  # TODO: restore when data-testid is available
${AVAIL_PRODUCT_STEPS}              css=.ant-steps

# Search — testid is on the Search component wrapper
# Use ${CUSTOMER_SEARCH} input for typing, button for submitting
# ${CUSTOMER_SEARCH}                  css=[data-testid="search-customers"]                     # TODO: restore when data-testid is available
${CUSTOMER_SEARCH}                  css=.ant-input-search
# ${CUSTOMER_SEARCH_INPUT}            css=[data-testid="search-customers"] input               # TODO: restore when data-testid is available
${CUSTOMER_SEARCH_INPUT}            css=input[placeholder="Search customers..."]
# ${CUSTOMER_SEARCH_BTN}              css=[data-testid="search-customers"] button              # TODO: restore when data-testid is available
${CUSTOMER_SEARCH_BTN}              css=.ant-input-search-button

# Table
# ${CUSTOMERS_TABLE}                  css=[data-testid="table-customers"]                      # TODO: restore when data-testid is available
${CUSTOMERS_TABLE}                  css=.ant-table-body table
# ${TABLE_ROWS}                       css=[data-testid="table-customers"] tbody tr             # TODO: restore when data-testid is available
${TABLE_ROWS}                       css=.ant-table-body table tbody tr

# Row-level action buttons
# ${VIEW_PROFILE_LINK}                css=[data-testid="btn-customers-view-profile"]           # TODO: restore when data-testid is available
${VIEW_PROFILE_LINK}                css=a.table-link:has-text("View Profile")
# ${VIEW_ACCOUNTS_LINK}               css=[data-testid="btn-customers-view-accounts"]          # TODO: restore when data-testid is available
${VIEW_ACCOUNTS_LINK}               css=a.table-link:has-text("View Accounts")




# ============================================================
# CUSTOMERS MODULE — Enroll Customer
# data-testid attributes — CUSTOMER_TEST_IDS.enroll
# ============================================================

# ${ENROLL_MOBILE_INPUT}              css=[data-testid="input-enroll-customer-mobile"]         # TODO: restore when data-testid is available
${ENROLL_MOBILE_INPUT}              css=input[type="tel"]
# ${ENROLL_CONTACT_CONTINUE_BTN}      css=[data-testid="btn-enroll-customer-contact-continue"] # TODO: restore when data-testid is available
${ENROLL_CONTACT_CONTINUE_BTN}      css=button[type="submit"]
# ${ENROLL_OTP_INPUT}                 css=[data-testid="input-enroll-customer-otp"]            # TODO: restore when data-testid is available
${ENROLL_OTP_INPUT}                 css=input[aria-label="Please enter OTP character 1"]
# ${ENROLL_OTP_CONTINUE_BTN}          css=[data-testid="btn-enroll-customer-otp-continue"]     # TODO: restore when data-testid is available
${ENROLL_OTP_CONTINUE_BTN}          text=CONTINUE
# ${ENROLL_OTP_RESEND_BTN}            css=[data-testid="btn-enroll-customer-otp-resend"]       # TODO: restore when data-testid is available
${ENROLL_OTP_RESEND_BTN}            text=Resend code
# ${ENROLL_AGREE_BTN}                 css=[data-testid="btn-enroll-customer-agree"]            # TODO: restore when data-testid is available
${ENROLL_AGREE_BTN}                 css=button:has-text("Agree")


# ============================================================
# ANT DESIGN TABLE (generic — for non-testid modules)
# ============================================================

${TABLE}                            css=table
${TABLE_BODY}                       css=table tbody
${NO_DATA}                          css=.ant-empty-description


# ============================================================
# ANT DESIGN PAGINATION (shared across all modules)
# ============================================================

${PAGINATION}                       css=.ant-pagination
${PAGINATION_NEXT}                  css=.ant-pagination-next button
${PAGINATION_PREV}                  css=.ant-pagination-prev button


# ============================================================
# ANT DESIGN MISC
# ============================================================

${LOADING_SPINNER}                  css=.ant-spin-spinning
${DROPDOWN_OPTIONS}                 css=.ant-select-dropdown .ant-select-item-option-content
${SEARCH_CLEAR_BTN}                 css=span.anticon-close-circle
