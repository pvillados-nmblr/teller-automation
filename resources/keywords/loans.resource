*** Settings ***
Library     Browser
Resource    common.resource


*** Keywords ***
Navigate To Loans
    [Documentation]    Navigates to the Loans module
    Navigate To Module    loans

View Loan List
    [Documentation]    Verifies the loan list is visible
    Wait For Elements State    css=.loan-list    visible

Fill New Loan Form
    [Documentation]    Fills in the new loan creation form
    [Arguments]        &{loan}
    Fill Text          id=customer-id       ${loan.customer_id}
    Select Options By  id=loan-product      value    ${loan.product}
    Fill Text          id=loan-amount       ${loan.amount}
    Fill Text          id=loan-term         ${loan.term}
    Fill Text          id=loan-purpose      ${loan.purpose}

Submit New Loan Form
    [Documentation]    Submits the new loan creation form
    Click              id=create-loan-button
    Wait For Elements State    css=.success-message    visible

Verify Loan Is Created
    [Documentation]    Verifies the loan was successfully created
    [Arguments]        ${customer_id}
    Get Text           css=.success-message    contains    ${customer_id}

Approve Loan
    [Documentation]    Approves a loan application
    [Arguments]        ${loan_id}
    Click              css=.loan-list tr:has-text("${loan_id}") [data-action="approve"]
    Wait For Elements State    css=.success-message    visible
    Get Text           css=.success-message    contains    approved

Reject Loan
    [Documentation]    Rejects a loan application with a reason
    [Arguments]        ${loan_id}    ${reason}
    Click              css=.loan-list tr:has-text("${loan_id}") [data-action="reject"]
    Fill Text          id=rejection-reason    ${reason}
    Click              id=confirm-reject-button
    Wait For Elements State    css=.success-message    visible
    Get Text           css=.success-message    contains    rejected

Disburse Loan
    [Documentation]    Disburses an approved loan
    [Arguments]        ${loan_id}
    Click              css=.loan-list tr:has-text("${loan_id}") [data-action="disburse"]
    Click              id=confirm-disburse-button
    Wait For Elements State    css=.success-message    visible
    Get Text           css=.success-message    contains    disbursed
