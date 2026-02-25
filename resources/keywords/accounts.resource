*** Settings ***
Library     Browser
Resource    common.resource


*** Keywords ***
Navigate To Accounts
    [Documentation]    Navigates to the Accounts module
    Navigate To Module    accounts

View Account List
    [Documentation]    Verifies the full account list is visible
    Wait For Elements State    css=.account-list    visible

View Account Transactions
    [Documentation]    Opens an account and views its transaction list
    [Arguments]        ${account_number}
    Click              css=.account-list tr:has-text("${account_number}")
    Wait For Elements State    css=.transaction-list    visible

Fill New Account Form
    [Documentation]    Fills in the new bank account creation form
    [Arguments]        &{account}
    Fill Text          id=customer-id        ${account.customer_id}
    Select Options By  id=account-type       value    ${account.account_type}
    Fill Text          id=initial-deposit    ${account.initial_deposit}

Submit New Account Form
    [Documentation]    Submits the new account creation form
    Click              id=create-account-button
    Wait For Elements State    css=.success-message    visible

Verify Account Is Created
    [Documentation]    Verifies that the account was successfully created
    [Arguments]        ${customer_id}
    Get Text           css=.success-message    contains    ${customer_id}

Create New Bank Account
    [Documentation]    End-to-end keyword to create a new bank account
    [Arguments]        &{account}
    Navigate To Accounts
    Fill New Account Form    &{account}
    Submit New Account Form
    Verify Account Is Created    ${account.customer_id}
