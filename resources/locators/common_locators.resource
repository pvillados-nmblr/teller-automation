*** Variables ***

# ============================================================
# LOGIN PAGE
# data-testid attributes added by dev — AUTH_TEST_IDS.login
# ============================================================

${LOGIN_PAGE}                       css=[data-testid="page-login"]
${EMAIL_FIELD}                      css=[data-testid="input-login-email"]
${PASSWORD_FIELD}                   css=[data-testid="input-login-password"]
${LOGIN_BUTTON}                     css=[data-testid="btn-login-submit"]
${FORGOT_PASSWORD_LINK}             css=[data-testid="link-login-forgot-password"]
${LOGIN_ERROR_MODAL}                css=[data-testid="modal-login-error"]


# ============================================================
# FORGOT PASSWORD — Step 1: Request OTP
# data-testid attributes — AUTH_TEST_IDS.forgotPassword
# ============================================================

${FP_PAGE}                          css=[data-testid="page-forgot-password"]
${FP_EMAIL_FIELD}                   css=[data-testid="input-forgot-password-email"]
${FP_SEND_CODE_BTN}                 css=[data-testid="btn-forgot-password-send-code"]


# ============================================================
# FORGOT PASSWORD — Step 2: Verify OTP
# Note: OTP is a single input field (not 6 separate boxes)
# ============================================================

${FP_OTP_INPUT}                     css=input[aria-label="Please enter OTP character 1"]
${FP_CONTINUE_BTN}                  css=[data-testid="btn-forgot-password-otp-continue"]
${FP_RESEND_BTN}                    css=[data-testid="btn-forgot-password-otp-resend"]


# ============================================================
# FORGOT PASSWORD — Step 3: Change Password
# ============================================================

${NEW_PASSWORD_FIELD}               css=[data-testid="input-forgot-password-new-password"]
${CONFIRM_NEW_PASSWORD_FIELD}       css=[data-testid="input-forgot-password-confirm-password"]
${RESET_PASSWORD_BTN}               css=[data-testid="btn-forgot-password-reset"]
${RESET_SUCCESS_HEADING}            text=Success!
${RESET_SUCCESS_MESSAGE}            text=Password has been changed successfully.
${BACK_TO_LOGIN_BTN}                text=Back to Login


# ============================================================
# RESET TEMPORARY PASSWORD FLOW
# data-testid attributes — AUTH_TEST_IDS.resetTemporaryPassword
# ============================================================

${RTP_PAGE}                         css=[data-testid="page-reset-temporary-password"]
${RTP_TEMP_PASSWORD_FIELD}          css=[data-testid="input-reset-temp-password-current"]
${RTP_NEW_PASSWORD_FIELD}           css=[data-testid="input-reset-temp-password-new"]
${RTP_CONFIRM_PASSWORD_FIELD}       css=[data-testid="input-reset-temp-password-confirm"]
${RTP_SUBMIT_BTN}                   css=[data-testid="btn-reset-temp-password-submit"]
${RTP_OTP_INPUT}                    css=[data-testid="input-reset-temp-password-otp"] input[aria-label="Please enter OTP character 1"]
${RTP_OTP_CONTINUE_BTN}             css=[data-testid="btn-reset-temp-password-otp-continue"]
${RTP_OTP_RESEND_BTN}               css=[data-testid="btn-reset-temp-password-otp-resend"]


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

${CUSTOMERS_LIST_PAGE}              css=[data-testid="page-customers-list"]
${CUSTOMERS_PROFILE_PAGE}           css=[data-testid="page-customers-profile"]
${CUSTOMERS_ACCOUNTS_PAGE}          css=[data-testid="page-customers-accounts"]
${CUSTOMERS_TRANSACTIONS_PAGE}      css=[data-testid="page-customers-account-transactions"]
${AVAIL_PRODUCT_PAGE}               css=[data-testid="page-customers-avail-product"]
${AVAIL_PRODUCT_STEPS}              css=[data-testid="steps-avail-product"]

# Search — testid is on the Search component wrapper
# Use ${CUSTOMER_SEARCH} input for typing, button for submitting
${CUSTOMER_SEARCH}                  css=[data-testid="search-customers"]
${CUSTOMER_SEARCH_INPUT}            css=[data-testid="search-customers"] input
${CUSTOMER_SEARCH_BTN}              css=[data-testid="search-customers"] button

# Table
${CUSTOMERS_TABLE}                  css=[data-testid="table-customers"]
${TABLE_ROWS}                       css=[data-testid="table-customers"] tbody tr

# Row-level action buttons
${VIEW_PROFILE_LINK}                css=[data-testid="btn-customers-view-profile"]
${VIEW_ACCOUNTS_LINK}               css=[data-testid="btn-customers-view-accounts"]


# ============================================================
# CUSTOMERS MODULE — Enroll Customer
# data-testid attributes — CUSTOMER_TEST_IDS.enroll
# ============================================================

${ENROLL_MOBILE_INPUT}              css=[data-testid="input-enroll-customer-mobile"]
${ENROLL_CONTACT_CONTINUE_BTN}      css=[data-testid="btn-enroll-customer-contact-continue"]
${ENROLL_OTP_INPUT}                 css=[data-testid="input-enroll-customer-otp"]
${ENROLL_OTP_CONTINUE_BTN}          css=[data-testid="btn-enroll-customer-otp-continue"]
${ENROLL_OTP_RESEND_BTN}            css=[data-testid="btn-enroll-customer-otp-resend"]
${ENROLL_AGREE_BTN}                 css=[data-testid="btn-enroll-customer-agree"]


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
