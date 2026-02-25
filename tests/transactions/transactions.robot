*** Settings ***
Documentation       Test suite for the Transactions module
...                 Covers viewing transactions, processing deposits and withdrawals.

Resource            ../../resources/keywords/common.resource
Resource            ../../resources/keywords/transactions.resource

Suite Setup         Login To Teller App
Suite Teardown      Logout From Teller App


*** Variables ***
&{VALID_DEPOSIT}
...    account_number=ACC-100001
...    type=deposit
...    amount=5000.00
...    notes=Cash deposit

&{VALID_WITHDRAWAL}
...    account_number=ACC-100001
...    type=withdrawal
...    amount=1000.00
...    notes=Cash withdrawal


*** Test Cases ***
Teller Can View Transaction List
    [Documentation]    Verify that the teller can view the list of all transactions
    [Tags]             transactions    smoke
    Navigate To Transactions
    View Transaction List

Teller Can Process A Deposit
    [Documentation]    Verify that the teller can process a deposit transaction
    [Tags]             transactions    deposit    smoke
    Process Deposit    &{VALID_DEPOSIT}

Teller Can Process A Withdrawal
    [Documentation]    Verify that the teller can process a withdrawal transaction
    [Tags]             transactions    withdrawal    smoke
    Process Withdrawal    &{VALID_WITHDRAWAL}

Teller Cannot Withdraw More Than Account Balance
    [Documentation]    Verify that a withdrawal exceeding the account balance is rejected
    [Tags]             transactions    withdrawal    negative
    &{EXCESS_WITHDRAWAL}=    Create Dictionary
    ...    account_number=ACC-100001
    ...    type=withdrawal
    ...    amount=9999999.00
    ...    notes=Excess withdrawal test
    Navigate To Transactions
    Fill Transaction Form    &{EXCESS_WITHDRAWAL}
    Submit Transaction Form
    Get Text    css=.error-message    contains    Insufficient Balance
