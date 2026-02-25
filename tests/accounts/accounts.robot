*** Settings ***
Documentation       Test suite for the Accounts module
...                 Covers viewing all accounts, viewing account transactions,
...                 and creating new bank accounts.

Resource            ../../resources/keywords/common.resource
Resource            ../../resources/keywords/accounts.resource

Suite Setup         Login To Teller App
Suite Teardown      Logout From Teller App


*** Variables ***
&{SAVINGS_ACCOUNT}
...    customer_id=CUST-0001
...    account_type=savings
...    initial_deposit=1000.00

&{CHECKING_ACCOUNT}
...    customer_id=CUST-0001
...    account_type=checking
...    initial_deposit=500.00


*** Test Cases ***
Teller Can View Account List
    [Documentation]    Verify that the teller can view the list of all bank accounts
    [Tags]             accounts    smoke
    Navigate To Accounts
    View Account List

Teller Can View Transactions Of An Account
    [Documentation]    Verify that the teller can view the transactions of a bank account
    [Tags]             accounts    regression
    Navigate To Accounts
    View Account Transactions    ACC-100001

Teller Can Create A Savings Account
    [Documentation]    Verify that the teller can create a savings account for an existing customer
    [Tags]             accounts    smoke
    Create New Bank Account    &{SAVINGS_ACCOUNT}

Teller Can Create A Checking Account
    [Documentation]    Verify that the teller can create a checking account for an existing customer
    [Tags]             accounts    regression
    Create New Bank Account    &{CHECKING_ACCOUNT}
