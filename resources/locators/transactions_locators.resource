*** Variables ***
# ============================================================
# Transactions Module Locators
# ============================================================
# Update these to match your actual teller app HTML

# Navigation
${TRANSACTIONS_MENU}            css=[data-menu="transactions"]

# Transaction List
${TRANSACTION_LIST}             css=.transaction-list

# Transaction Form
${ACCOUNT_NUMBER_FIELD}         id=account-number
${TRANSACTION_TYPE_DROPDOWN}    id=transaction-type
${AMOUNT_FIELD}                 id=amount
${NOTES_FIELD}                  id=notes
${SUBMIT_TRANSACTION_BUTTON}    id=submit-transaction-button

# Messages
${SUCCESS_MESSAGE}              css=.success-message
${ERROR_MESSAGE}                css=.error-message
${TRANSACTION_SUMMARY}          css=.transaction-summary
