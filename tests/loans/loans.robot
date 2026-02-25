*** Settings ***
Documentation       Test suite for the Loans module
...                 Covers viewing loans, creating loans, approving/rejecting,
...                 and disbursing loans.

Resource            ../../resources/keywords/common.resource
Resource            ../../resources/keywords/loans.resource

Suite Setup         Login To Teller App
Suite Teardown      Logout From Teller App


*** Variables ***
&{VALID_LOAN}
...    customer_id=CUST-0001
...    product=Personal Loan
...    amount=50000.00
...    term=12
...    purpose=Home improvement

${LOAN_ID_TO_APPROVE}     LOAN-0001
${LOAN_ID_TO_REJECT}      LOAN-0002
${LOAN_ID_TO_DISBURSE}    LOAN-0003
${REJECTION_REASON}       Insufficient income based on submitted documents


*** Test Cases ***
Teller Can View Loan List
    [Documentation]    Verify that the teller can view the list of all loans
    [Tags]             loans    smoke
    Navigate To Loans
    View Loan List

Teller Can Create A Loan
    [Documentation]    Verify that the teller can create a loan application for a customer
    [Tags]             loans    smoke
    Navigate To Loans
    Fill New Loan Form    &{VALID_LOAN}
    Submit New Loan Form
    Verify Loan Is Created    ${VALID_LOAN.customer_id}

Teller Can Approve A Loan
    [Documentation]    Verify that the teller can approve a pending loan application
    [Tags]             loans    regression
    Navigate To Loans
    Approve Loan    ${LOAN_ID_TO_APPROVE}

Teller Can Reject A Loan
    [Documentation]    Verify that the teller can reject a loan application with a reason
    [Tags]             loans    regression
    Navigate To Loans
    Reject Loan    ${LOAN_ID_TO_REJECT}    ${REJECTION_REASON}

Teller Can Disburse An Approved Loan
    [Documentation]    Verify that the teller can disburse an approved loan
    [Tags]             loans    regression
    Navigate To Loans
    Disburse Loan    ${LOAN_ID_TO_DISBURSE}
