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

