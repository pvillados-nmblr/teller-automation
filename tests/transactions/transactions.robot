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

