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
