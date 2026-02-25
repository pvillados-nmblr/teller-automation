*** Variables ***
# ============================================================
# Loans Module Locators
# ============================================================
# Update these to match your actual teller app HTML

# Navigation
${LOANS_MENU}                  css=[data-menu="loans"]

# Loan List
${LOAN_LIST}                   css=.loan-list

# New Loan Form
${CUSTOMER_ID_FIELD}           id=customer-id
${LOAN_PRODUCT_DROPDOWN}       id=loan-product
${LOAN_AMOUNT_FIELD}           id=loan-amount
${LOAN_TERM_FIELD}             id=loan-term
${LOAN_PURPOSE_FIELD}          id=loan-purpose
${CREATE_LOAN_BUTTON}          id=create-loan-button

# Loan Actions
${APPROVE_BUTTON}              data-action=approve
${REJECT_BUTTON}               data-action=reject
${DISBURSE_BUTTON}             data-action=disburse
${REJECTION_REASON_FIELD}      id=rejection-reason
${CONFIRM_REJECT_BUTTON}       id=confirm-reject-button
${CONFIRM_DISBURSE_BUTTON}     id=confirm-disburse-button

# Messages
${SUCCESS_MESSAGE}             css=.success-message
