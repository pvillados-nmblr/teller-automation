*** Settings ***
Library     Browser
Resource    common.resource


*** Keywords ***
Navigate To Transactions
    [Documentation]    Navigates to the Transactions module
    Navigate To Module    transactions

View Transaction List
    [Documentation]    Verifies the transaction list is visible
    Wait For Elements State    css=.transaction-list    visible

Fill Transaction Form
    [Documentation]    Fills in the transaction form for deposit or withdrawal
    [Arguments]        &{transaction}
    Fill Text          id=account-number       ${transaction.account_number}
    Select Options By  id=transaction-type     value    ${transaction.type}
    Fill Text          id=amount               ${transaction.amount}
    Run Keyword If     '${transaction.notes}' != ''
    ...                Fill Text    id=notes    ${transaction.notes}

Submit Transaction Form
    [Documentation]    Submits the transaction form
    Click              id=submit-transaction-button
    Wait For Elements State    css=.success-message    visible

Verify Transaction Is Successful
    [Documentation]    Verifies the transaction was completed successfully
    [Arguments]        ${amount}    ${type}
    Get Text           css=.transaction-summary    contains    ${amount}
    Get Text           css=.transaction-summary    contains    ${type}

Process Deposit
    [Documentation]    End-to-end keyword to process a deposit transaction
    [Arguments]        &{transaction}
    Navigate To Transactions
    Fill Transaction Form      &{transaction}
    Submit Transaction Form
    Verify Transaction Is Successful    ${transaction.amount}    Deposit

Process Withdrawal
    [Documentation]    End-to-end keyword to process a withdrawal transaction
    [Arguments]        &{transaction}
    Navigate To Transactions
    Fill Transaction Form      &{transaction}
    Submit Transaction Form
    Verify Transaction Is Successful    ${transaction.amount}    Withdrawal
