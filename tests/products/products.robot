*** Settings ***
Documentation       Test suite for the Products module
...                 Covers viewing active/archived products and creating new products.

Resource            ../../resources/keywords/common.resource
Resource            ../../resources/keywords/products.resource

Suite Setup         Login To Teller App
Suite Teardown      Logout From Teller App


*** Variables ***
&{SAVINGS_PRODUCT}
...    type=savings
...    name=Regular Savings
...    interest_rate=2.5
...    description=Standard savings product with 2.5% interest rate

&{LOAN_PRODUCT}
...    type=loan
...    name=Personal Loan
...    interest_rate=5.0
...    description=Personal loan product with 5.0% interest rate


*** Test Cases ***
Teller Can View Active Products
    [Documentation]    Verify that the teller can view the list of active products
    [Tags]             products    smoke
    Navigate To Products
    View Active Products

Teller Can View Archived Products
    [Documentation]    Verify that the teller can view the list of archived products
    [Tags]             products    regression
    Navigate To Products
    View Archived Products

Teller Can Create A Savings Product
    [Documentation]    Verify that the teller can create a new savings product
    [Tags]             products    smoke
    Create New Product    &{SAVINGS_PRODUCT}

Teller Can Create A Loan Product
    [Documentation]    Verify that the teller can create a new loan product
    [Tags]             products    regression
    Create New Product    &{LOAN_PRODUCT}
