*** Variables ***
# ============================================================
# Accounts Module Locators
# ============================================================
# Update these to match your actual teller app HTML

# Navigation
${ACCOUNTS_MENU}               css=li[role="menuitem"] >> text=Accounts

# Account List
${ACCOUNT_LIST}                css=.account-list
${TRANSACTION_LIST}            css=.transaction-list

# New Account Form
${CUSTOMER_ID_FIELD}           id=customer-id
${ACCOUNT_TYPE_DROPDOWN}       id=account-type
${INITIAL_DEPOSIT_FIELD}       id=initial-deposit
${CREATE_ACCOUNT_BUTTON}       id=create-account-button

# Messages
${SUCCESS_MESSAGE}             css=.success-message
