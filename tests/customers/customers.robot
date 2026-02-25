*** Settings ***
Documentation       Test suite for the Customers module
...                 Covers viewing customer list, searching, viewing customer profile,
...                 viewing customer accounts, and viewing account transactions.
...                 Note: Customer creation is done via mobile app only.

Resource            ../../resources/keywords/common.resource
Resource            ../../resources/keywords/customers.resource

Suite Setup         Login To Teller App
Suite Teardown      Close Browser


*** Variables ***
${EXISTING_CUSTOMER_NAME}       Ndn Nznz Nzkz
${EXISTING_ACCOUNT_NUMBER}      7710363080958538


*** Test Cases ***
Teller Can View Customer List
    [Documentation]    Verify that the teller can view the list of customers after navigating to the Customers module
    [Tags]             customers    smoke
    Navigate To Customers
    View Customer List

Teller Can Search For An Existing Customer
    [Documentation]    Verify that the teller can search for an existing customer by name
    [Tags]             customers    smoke
    Navigate To Customers
    Search For Customer    ${EXISTING_CUSTOMER_NAME}

Teller Can View Profile Of A Customer
    [Documentation]    Verify that the teller can view the profile of a customer
    [Tags]             customers    smoke
    Navigate To Customers
    View Customer Profile    ${EXISTING_CUSTOMER_NAME}

Teller Can View Accounts Of A Customer
    [Documentation]    Verify that the teller can view the list of bank accounts under a customer
    [Tags]             customers    smoke
    Navigate To Customers
    View Customer Accounts    ${EXISTING_CUSTOMER_NAME}

Teller Can View Transactions Of A Customer Account
    [Documentation]    Verify that the teller can view transactions of a specific account under a customer
    [Tags]             customers    regression
    Navigate To Customers
    View Customer Accounts         ${EXISTING_CUSTOMER_NAME}
    View Customer Account Transactions    ${EXISTING_ACCOUNT_NUMBER}
