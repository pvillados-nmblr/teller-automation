*** Settings ***
Documentation       t4.2 Create a Withdrawal Transaction via Teller
...                 Covers the complete withdrawal flow via the New Transaction modal:
...                 opening the modal, searching for an account by number and by name,
...                 selecting an account and verifying customer information,
...                 navigating to the Withdrawal form, filling form fields, verifying
...                 real-time summary updates, processing the withdrawal, and verifying
...                 the new transaction in the Transactions list.

Resource            ../../resources/keywords/common.resource
Resource            ../../resources/keywords/transactions.resource

Suite Setup         Login To Teller App
Suite Teardown      Close Browser
Test Setup          Setup Transactions Page
Test Teardown       Close Modal If Open


*** Test Cases ***
t4.2.1 Open New Transaction Modal
    [Documentation]    Verify that clicking the New Transaction button opens the Create Transaction
    ...                modal with the Customer Information step visible, and the account search
    ...                field and Search button are present and enabled.
    [Tags]             transactions    create    withdrawal    smoke    mvp
    Wait For Elements State    ${NEW_TXN_BTN}                    visible
    Click                      ${NEW_TXN_BTN}
    Wait For Elements State    ${CREATE_TXN_MODAL}               visible
    Wait For Elements State    text=Search Customer               visible
    Wait For Elements State    ${CREATE_TXN_SEARCH_INPUT}        visible
    Wait For Elements State    ${CREATE_TXN_SEARCH_BTN}          enabled

t4.2.2 Search by Account Number
    [Documentation]    Verify that entering a valid account number and clicking Search returns
    ...                a result list where each entry displays:
    ...                Account Name, Account Number, account type (e.g. Savings),
    ...                Balance, and Account Status.
    [Tags]             transactions    create    withdrawal    smoke    mvp
    Open New Transaction Modal
    Search Account In Create Transaction Modal    ${T42_ACCOUNT_NUMBER}
    # Verify the matching result card is visible
    Wait For Elements State
    ...    css=.ant-modal-content [role="button"]:has-text("${T42_ACCOUNT_NUMBER}")
    ...    visible
    # Verify all expected fields are displayed per result entry
    Wait For Elements State
    ...    css=.ant-modal-content [role="button"]:has-text("${T42_ACCOUNT_NUMBER}"):has-text("${T42_ACCOUNT_NAME}")
    ...    visible
    Wait For Elements State
    ...    css=.ant-modal-content [role="button"]:has-text("${T42_ACCOUNT_NUMBER}"):has-text("${T42_ACCOUNT_TYPE}")
    ...    visible
    Wait For Elements State
    ...    css=.ant-modal-content [role="button"]:has-text("${T42_ACCOUNT_NUMBER}"):has-text("${T42_ACCOUNT_STATUS}")
    ...    visible

t4.2.3 Search by Account Name
    [Documentation]    Verify that entering a valid account holder name returns one or more
    ...                matching results. Each result entry displays Account Name, Account Number,
    ...                account type (e.g. Savings), Balance, and Account Status.
    [Tags]             transactions    create    withdrawal    smoke    mvp
    Open New Transaction Modal
    Search Account In Create Transaction Modal    ${T42_CUSTOMER_NAME}
    # Verify at least one result card containing the searched name is visible
    Wait For Elements State
    ...    css=.ant-modal-content [role="button"]:has-text("${T42_CUSTOMER_NAME}") >> nth=0
    ...    visible
    # Verify common fields are shown per result entry
    Wait For Elements State
    ...    css=.ant-modal-content [role="button"]:has-text("${T42_CUSTOMER_NAME}"):has-text("${T42_ACCOUNT_TYPE}") >> nth=0
    ...    visible
    Wait For Elements State
    ...    css=.ant-modal-content [role="button"]:has-text("${T42_CUSTOMER_NAME}"):has-text("${T42_ACCOUNT_STATUS}") >> nth=0
    ...    visible

t4.2.4 Select Account and Verify Customer Information
    [Documentation]    Verify that selecting an account from search results navigates to the
    ...                Customer Information step, which displays: Customer Name, Account Number,
    ...                Account Type, Status, Current Balance, Daily Limit Remaining,
    ...                and Contact Information (Mobile Number and Email).
    [Tags]             transactions    create    withdrawal    smoke    mvp
    Open New Transaction Modal
    Search Account In Create Transaction Modal    ${T42_ACCOUNT_NUMBER}
    Select Account From Create Transaction Results    ${T42_ACCOUNT_NUMBER}
    # Verify all fields — continue on failure so ALL mismatches are reported
    # Verify account and customer identity details
    Run Keyword And Continue On Failure
    ...    Wait For Elements State    text=Account Name           visible
    Run Keyword And Continue On Failure
    ...    Wait For Elements State    text=${T42_CUSTOMER_NAME} >> nth=0       visible
    Run Keyword And Continue On Failure
    ...    Wait For Elements State    text=Account Number           visible
    Run Keyword And Continue On Failure
    ...    Wait For Elements State    text=${T42_ACCOUNT_NUMBER} >> nth=0      visible
    Run Keyword And Continue On Failure
    ...    Wait For Elements State    text=Account Type           visible
    Run Keyword And Continue On Failure
    ...    Wait For Elements State    text=${T42_ACCOUNT_TYPE} >> nth=0        visible
    Run Keyword And Continue On Failure
    ...    Wait For Elements State    text=Status           visible
    Run Keyword And Continue On Failure
    ...    Wait For Elements State    text=${T42_ACCOUNT_STATUS} >> nth=0      visible
    # Verify additional Customer Information fields are present
    Run Keyword And Continue On Failure
    ...    Wait For Elements State    text=Current Balance >> nth=0            visible
    Run Keyword And Continue On Failure
    ...    Wait For Elements State    text=Daily Limit Remaining >> nth=0      visible
    Run Keyword And Continue On Failure
    ...    Wait For Elements State    text=Contact Information >> nth=0        visible
    # Verify the transaction type buttons are visible
    Run Keyword And Continue On Failure
    ...    Wait For Elements State    ${CREATE_TXN_DEPOSIT_BTN}      visible
    Run Keyword And Continue On Failure
    ...    Wait For Elements State    ${CREATE_TXN_WITHDRAWAL_BTN}   visible

t4.2.5 Navigate to Transaction Type – Withdraw
    [Documentation]    Verify that clicking the Withdraw button from the Customer Information
    ...                step navigates to the Transaction step for Withdrawal, showing:
    ...                - Two panels: "Withdraw Funds" and "Transaction Summary"
    ...                - Withdraw Funds panel pre-filled with Account Name, Account Number
    ...                  (with account type e.g. Savings), and Current Balance
    ...                - Withdrawal Type dropdown, Withdrawal Amount input, Transaction Notes field
    ...                - Cancel and Process Withdrawal buttons
    [Tags]             transactions    create    withdrawal    smoke    mvp
    Open New Transaction Modal
    Search Account In Create Transaction Modal    ${T42_ACCOUNT_NUMBER}
    Select Account From Create Transaction Results    ${T42_ACCOUNT_NUMBER}
    Click                      ${CREATE_TXN_WITHDRAWAL_BTN}
    # Verify both panel headings are visible
    Run Keyword And Continue On Failure
    ...    Wait For Elements State    text=Withdraw Funds >> nth=0          visible
    Run Keyword And Continue On Failure
    ...    Wait For Elements State    text=Transaction Summary >> nth=0     visible
    # Verify Withdraw Funds panel pre-fills account info from the selected account
    Run Keyword And Continue On Failure
    ...    Wait For Elements State    text=${T42_ACCOUNT_NAME} >> nth=0     visible
    Run Keyword And Continue On Failure
    ...    Wait For Elements State    text=${T42_ACCOUNT_NUMBER} >> nth=0   visible
    Run Keyword And Continue On Failure
    ...    Wait For Elements State    text=${T42_ACCOUNT_TYPE} >> nth=0     visible
    Run Keyword And Continue On Failure
    ...    Wait For Elements State    text=Current Balance >> nth=0         visible
    # Verify form inputs are present
    Run Keyword And Continue On Failure
    ...    Wait For Elements State    ${CREATE_TXN_TYPE_SELECT}             visible
    Run Keyword And Continue On Failure
    ...    Wait For Elements State    ${CREATE_TXN_AMOUNT_INPUT}            visible
    Run Keyword And Continue On Failure
    ...    Wait For Elements State    ${CREATE_TXN_NOTES_INPUT}             visible
    # Verify action buttons are present
    Run Keyword And Continue On Failure
    ...    Wait For Elements State    ${CREATE_TXN_CANCEL_BTN}              visible
    Run Keyword And Continue On Failure
    ...    Wait For Elements State    ${CREATE_TXN_PROCESS_WITHDRAWAL_BTN}  visible

t4.2.6 Real-Time Summary Updates with Withdrawal Amount
    [Documentation]    Verify that the Transaction Summary panel updates immediately as the
    ...                user fills in the withdrawal form:
    ...                - Entering an amount shows the withdrawal amount in the summary
    ...                - The summary displays New Balance = Current Balance – withdrawal amount (correct math)
    [Tags]             transactions    create    withdrawal    regression    mvp
    Navigate To Withdrawal Step
    # Select withdrawal type
    Click                      ${CREATE_TXN_TYPE_SELECT}
    Wait For Elements State    css=.ant-select-dropdown:not(.ant-select-dropdown-hidden)    visible
    Click
    ...    css=.ant-select-dropdown:not(.ant-select-dropdown-hidden) .ant-select-item-option-content:has-text("${T42_WITHDRAWAL_TYPE}")
    Wait For Load Spinner To Disappear
    # Capture Current Balance from the summary panel BEFORE entering the amount
    ${current_balance_str}=    Get Transaction Summary Field Value    Current Balance
    ${current_balance}=        Evaluate    float('${current_balance_str}'.replace(',', ''))
    # Enter the withdrawal amount
    Fill Text                  ${CREATE_TXN_AMOUNT_INPUT}    ${T42_WITHDRAWAL_AMOUNT}
    Wait For Elements State    text=${T42_WITHDRAWAL_AMOUNT} >> nth=0    visible
    Wait For Elements State    text=New Balance >> nth=0                 visible
    # Compute expected new balance and assert the summary shows the correct value
    ${withdrawal}=             Evaluate    float(str('${T42_WITHDRAWAL_AMOUNT}').replace(',', ''))
    ${expected_new_balance}=   Evaluate    round(${current_balance} - ${withdrawal}, 2)
    ${new_balance_str}=        Get Transaction Summary Field Value    New Balance
    ${displayed_new_balance}=  Evaluate    float('${new_balance_str}'.replace(',', ''))
    Should Be Equal As Numbers    ${displayed_new_balance}    ${expected_new_balance}
    ...    msg=Summary New Balance is wrong: expected ${expected_new_balance} (${current_balance} − ${withdrawal}) but got ${displayed_new_balance}

t4.2.7 Process Withdrawal and Review
    [Documentation]    Verify that completing the withdrawal form and clicking Process Withdrawal
    ...                navigates to the Review step which displays:
    ...                - "Withdrawal Successful" heading and sub-message
    ...                - Labels: Transaction ID, Customer, Account number, Transaction Type,
    ...                  Amount, Date & Time, Auth Code, Notes, Previous Balance, New Balance
    ...                - Correct Customer Name, Account Number, Transaction Type, Amount (exact match)
    ...                - New Balance = Previous Balance − Withdrawal Amount (math validation)
    ...                - Print Receipt and New Transaction buttons
    [Tags]             transactions    create    withdrawal    smoke    mvp
    Navigate To Withdrawal Step
    # Fill the withdrawal form
    Click                      ${CREATE_TXN_TYPE_SELECT}
    Wait For Elements State    css=.ant-select-dropdown:not(.ant-select-dropdown-hidden)    visible
    Click
    ...    css=.ant-select-dropdown:not(.ant-select-dropdown-hidden) .ant-select-item-option-content:has-text("${T42_WITHDRAWAL_TYPE}")
    Wait For Load Spinner To Disappear
    Fill Text                  ${CREATE_TXN_AMOUNT_INPUT}    ${T42_WITHDRAWAL_AMOUNT}
    Fill Text                  ${CREATE_TXN_NOTES_INPUT}     ${T42_WITHDRAWAL_NOTES}
    # Submit the withdrawal
    Click                      ${CREATE_TXN_PROCESS_WITHDRAWAL_BTN}
    Wait For Load Spinner To Disappear
    # Label assertions — verify all receipt field labels are present
    Run Keyword And Continue On Failure
    ...    Wait For Elements State    text=Withdrawal Successful >> nth=0                    visible
    Run Keyword And Continue On Failure
    ...    Wait For Elements State    text=Transaction has been processed successfully >> nth=0    visible
    Run Keyword And Continue On Failure
    ...    Wait For Elements State    text=Transaction ID >> nth=0                           visible
    Run Keyword And Continue On Failure
    ...    Wait For Elements State    text=Customer >> nth=0                                 visible
    Run Keyword And Continue On Failure
    ...    Wait For Elements State    text=Account number >> nth=0                           visible
    Run Keyword And Continue On Failure
    ...    Wait For Elements State    text=Transaction Type >> nth=0                         visible
    Run Keyword And Continue On Failure
    ...    Wait For Elements State    text=Amount >> nth=0                                   visible
    Run Keyword And Continue On Failure
    ...    Wait For Elements State    text=Date & Time >> nth=0                              visible
    Run Keyword And Continue On Failure
    ...    Wait For Elements State    text=Auth Code >> nth=0                                visible
    Run Keyword And Continue On Failure
    ...    Wait For Elements State    text=Notes >> nth=0                                    visible
    Run Keyword And Continue On Failure
    ...    Wait For Elements State    text=Previous Balance >> nth=0                         visible
    Run Keyword And Continue On Failure
    ...    Wait For Elements State    text=New Balance >> nth=0                              visible
    # Value assertions — exact matching using :text-is() to avoid partial matches
    ${_cust_name}=    Get Text    :text-is("${T42_CUSTOMER_NAME}") >> nth=0
    Run Keyword And Continue On Failure
    ...    Should Be Equal As Strings    ${_cust_name}    ${T42_CUSTOMER_NAME}
    ...    msg=Customer Name mismatch: expected '${T42_CUSTOMER_NAME}' but got '${_cust_name}'
    ${_acct_no}=      Get Text    :text-is("${T42_ACCOUNT_NUMBER}") >> nth=0
    Run Keyword And Continue On Failure
    ...    Should Be Equal As Strings    ${_acct_no}    ${T42_ACCOUNT_NUMBER}
    ...    msg=Account Number mismatch: expected '${T42_ACCOUNT_NUMBER}' but got '${_acct_no}'
    ${_w_type}=       Get Text    :text-is("${T42_WITHDRAWAL_TYPE}") >> nth=0
    Run Keyword And Continue On Failure
    ...    Should Be Equal As Strings    ${_w_type}    ${T42_WITHDRAWAL_TYPE}
    ...    msg=Withdrawal Type mismatch: expected '${T42_WITHDRAWAL_TYPE}' but got '${_w_type}'
    ${_w_amount}=     Get Text    :text-is("${T42_WITHDRAWAL_AMOUNT}") >> nth=0
    Run Keyword And Continue On Failure
    ...    Should Be Equal As Strings    ${_w_amount}    ${T42_WITHDRAWAL_AMOUNT}
    ...    msg=Withdrawal Amount mismatch: expected '${T42_WITHDRAWAL_AMOUNT}' but got '${_w_amount}'
    # Assert receipt New Balance = Previous Balance − Withdrawal Amount
    ${prev_balance_str}=       Get Transaction Summary Field Value    Previous Balance
    ${prev_balance}=           Evaluate    float('${prev_balance_str}'.replace(',', ''))
    ${withdrawal}=             Evaluate    float(str('${T42_WITHDRAWAL_AMOUNT}').replace(',', ''))
    ${expected_new_balance}=   Evaluate    round(${prev_balance} - ${withdrawal}, 2)
    ${new_balance_str}=        Get Transaction Summary Field Value    New Balance
    ${displayed_new_balance}=  Evaluate    float('${new_balance_str}'.replace(',', ''))
    Should Be Equal As Numbers    ${displayed_new_balance}    ${expected_new_balance}
    ...    msg=Receipt New Balance is wrong: expected ${expected_new_balance} (${prev_balance} − ${withdrawal}) but got ${displayed_new_balance}
    # Verify the action buttons on the confirmation screen
    Run Keyword And Continue On Failure
    ...    Wait For Elements State    ${CREATE_TXN_PRINT_RECEIPT_BTN}       visible
    Run Keyword And Continue On Failure
    ...    Wait For Elements State    ${CREATE_TXN_NEW_TXN_BTN_CONFIRM}     visible

t4.2.8 Verify Newest Transaction Appears at the Top (Withdrawal)
    [Documentation]    Verify that after completing the withdrawal flow and closing the confirmation,
    ...                the new Withdrawal transaction appears as the most recent (first) row
    ...                in the Transactions list, showing:
    ...                Transaction Type = Withdrawal, Debit Account Number = customer account,
    ...                Credit Account Number = N/A, and Status column visible.
    [Tags]             transactions    create    withdrawal    smoke    mvp
    # Complete the full withdrawal flow
    Navigate To Withdrawal Step
    Click                      ${CREATE_TXN_TYPE_SELECT}
    Wait For Elements State    css=.ant-select-dropdown:not(.ant-select-dropdown-hidden)    visible
    Click
    ...    css=.ant-select-dropdown:not(.ant-select-dropdown-hidden) .ant-select-item-option-content:has-text("${T42_WITHDRAWAL_TYPE}")
    Wait For Load Spinner To Disappear
    Fill Text                  ${CREATE_TXN_AMOUNT_INPUT}    ${T42_WITHDRAWAL_AMOUNT}
    Fill Text                  ${CREATE_TXN_NOTES_INPUT}     ${T42_WITHDRAWAL_NOTES}
    Click                      ${CREATE_TXN_PROCESS_WITHDRAWAL_BTN}
    Wait For Load Spinner To Disappear
    Wait For Elements State    ${CREATE_TXN_NEW_TXN_BTN_CONFIRM}    visible
    # Navigate back to the Transactions list via browser back button
    Go Back
    Wait For Load Spinner To Disappear
    # Verify the newest transaction (first row) is the Withdrawal just created
    Wait For Elements State
    ...    css=.ant-table-body table tbody tr:not([aria-hidden="true"]) >> nth=0
    ...    visible
    ${first_row_text}=    Get Text
    ...    css=.ant-table-body table tbody tr:not([aria-hidden="true"]) >> nth=0
    Should Contain    ${first_row_text}    Withdraw
    Should Contain    ${first_row_text}    ${T42_ACCOUNT_NUMBER}

t4.2.9 View Details of the Newest Transaction (Withdrawal)
    [Documentation]    Verify that clicking the View (eye) icon for the newest Withdrawal
    ...                transaction opens the detail modal which shows all relevant data:
    ...                - Transaction Type = Withdrawal
    ...                - Transaction Amount, Service Fee, Remarks, Transaction Status
    ...                - Debit Account Name = customer account
    ...                - Debit Account Number = customer account number
    ...                - Credit Account Name = N/A
    ...                - Credit Account Number = N/A
    ...                - Created on and Updated on timestamps
    [Tags]             transactions    create    withdrawal    smoke    mvp
    # Complete the full withdrawal flow
    Navigate To Withdrawal Step
    Click                      ${CREATE_TXN_TYPE_SELECT}
    Wait For Elements State    css=.ant-select-dropdown:not(.ant-select-dropdown-hidden)    visible
    Click
    ...    css=.ant-select-dropdown:not(.ant-select-dropdown-hidden) .ant-select-item-option-content:has-text("${T42_WITHDRAWAL_TYPE}")
    Wait For Load Spinner To Disappear
    Fill Text                  ${CREATE_TXN_AMOUNT_INPUT}    ${T42_WITHDRAWAL_AMOUNT}
    Fill Text                  ${CREATE_TXN_NOTES_INPUT}     ${T42_WITHDRAWAL_NOTES}
    Click                      ${CREATE_TXN_PROCESS_WITHDRAWAL_BTN}
    Wait For Load Spinner To Disappear
    Wait For Elements State    ${CREATE_TXN_NEW_TXN_BTN_CONFIRM}    visible
    # Navigate back to the Transactions list via browser back button
    Go Back
    Wait For Load Spinner To Disappear
    # Open the detail modal for the newest (first) transaction
    Click                      ${TXN_VIEW_BTN} >> nth=0
    Wait For Elements State    ${TXN_DETAIL_MODAL}                                            visible
    # Verify all required field labels and values in the detail modal
    Wait For Elements State    ${TXN_DETAIL_MODAL} >> text=Transaction ID                     visible
    Wait For Elements State    ${TXN_DETAIL_MODAL} >> text=Transaction Type                   visible
    Wait For Elements State    ${TXN_DETAIL_MODAL} >> text=Transaction Amount                 visible
    Wait For Elements State    ${TXN_DETAIL_MODAL} >> text=Service Fee                        visible
    Wait For Elements State    ${TXN_DETAIL_MODAL} >> text=Remarks                            visible
    Wait For Elements State    ${TXN_DETAIL_MODAL} >> text=Transaction Status                 visible
    Wait For Elements State    ${TXN_DETAIL_MODAL} >> text=Debit Account Name                 visible
    Wait For Elements State    ${TXN_DETAIL_MODAL} >> text=Debit Account Number               visible
    Wait For Elements State    ${TXN_DETAIL_MODAL} >> text=Credit Account Name                visible
    Wait For Elements State    ${TXN_DETAIL_MODAL} >> text=Credit Account Number              visible
    Wait For Elements State    ${TXN_DETAIL_MODAL} >> text=Created on                         visible
    Wait For Elements State    ${TXN_DETAIL_MODAL} >> text=Updated on                         visible
    # Verify Withdrawal-specific values: debit is customer account, credit is N/A
    Wait For Elements State    ${TXN_DETAIL_MODAL} >> text=${T42_ACCOUNT_NAME}                visible
    Wait For Elements State    ${TXN_DETAIL_MODAL} >> text=${T42_ACCOUNT_NUMBER}              visible
    Wait For Elements State
    ...    ${TXN_DETAIL_MODAL} >> text=Withdrawal
    ...    visible
    # Close the detail modal
    Click                      ${TXN_DETAIL_BACK_BTN}
    Wait For Elements State    ${TXN_DETAIL_MODAL}    hidden
    Wait For Elements State    ${TXN_TABLE}            visible
