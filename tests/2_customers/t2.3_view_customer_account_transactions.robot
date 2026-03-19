*** Settings ***
Documentation       t2.3 View the List of Transactions of a Bank Account under a Customer
...                 Covers initial load, pagination, transaction detail view, search by ID,
...                 date range filtering, transaction type filtering, and status filtering.

Resource            ../../resources/keywords/common.resource
Resource            ../../resources/keywords/customers.resource

Suite Setup         Login To Teller App
Suite Teardown      Close Browser
Test Setup          Setup Transaction Page
Test Teardown       Close Modal If Open


*** Keywords ***
Setup Transaction Page
    [Documentation]    Navigates to transaction page and ensures clean state by reloading
    Navigate To Customer Account Transactions Page    ${CUSTOMER_NAME}    ${VALID_ACCOUNT_ID}
    Reload
    Wait For Load Spinner To Disappear


*** Variables ***
${TXN_ROW}                  css=.ant-table-body table tbody tr.ant-table-row:has-text("${VALID_TXN_ID}")
${NON_EXISTING_TXN_ID}      NONEXISTENT99999


*** Test Cases ***
t2.3.1 View Account Transaction History
    [Documentation]    Verify the transaction history page loads successfully with all required
    ...                column headers and action buttons (Eye/View and Download) visible.
    [Tags]             customers    accounts    transactions    smoke    mvp
    Get Url                    contains    /transactions
    # Verify all fields — continue on failure so ALL mismatches are reported
    Run Keyword And Continue On Failure
    ...    Wait For Elements State    text=Transaction ID                                       visible
    Run Keyword And Continue On Failure
    ...    Wait For Elements State    text=Transaction Type                                     visible
    Run Keyword And Continue On Failure
    ...    Wait For Elements State    text=Date & Time                                          visible
    Run Keyword And Continue On Failure
    ...    Wait For Elements State    text=Debit Amount                                         visible
    Run Keyword And Continue On Failure
    ...    Wait For Elements State    text=Credit Amount                                        visible
    Run Keyword And Continue On Failure
    ...    Wait For Elements State    text=Status                                               visible
    Run Keyword And Continue On Failure
    ...    Wait For Elements State    text=Last Updated                                         visible
    Run Keyword And Continue On Failure
    ...    Wait For Elements State    text="Action"                                             visible
    Run Keyword And Continue On Failure
    ...    Wait For Elements State    ${VIEW_TXN_BTN} >> nth=0                                 visible
    Run Keyword And Continue On Failure
    ...    Wait For Elements State    ${DOWNLOAD_TXN_BTN} >> nth=0                             visible

t2.3.2 Pagination in Viewing Transaction History
    [Documentation]    Verify pagination controls work correctly:
    ...                Next loads page 2, clicking page 3 loads page 3,
    ...                and Back returns to page 2.
    [Tags]             customers    accounts    transactions    regression    mvp
    # Click Next arrow to go to page 2
    Click                      ${PAGINATION_NEXT}
    Wait For Elements State    css=li.ant-pagination-item-active:has-text("2")    visible
    # Click page number 3
    Click                      css=li.ant-pagination-item:has-text("3")
    Wait For Elements State    css=li.ant-pagination-item-active:has-text("3")    visible
    # Click Back arrow to return to page 2
    Click                      ${PAGINATION_PREV}
    Wait For Elements State    css=li.ant-pagination-item-active:has-text("2")    visible

t2.3.3 View Specific Transaction Details
    [Documentation]    Verify that clicking the Eye icon on the first row opens the transaction
    ...                detail modal with all required field labels, and the modal closes cleanly.
    [Tags]             customers    accounts    transactions    smoke    mvp
    Click                      ${VIEW_TXN_BTN} >> nth=0
    Wait For Elements State    ${TXN_DETAIL_MODAL}              visible
    # Verify all fields — continue on failure so ALL mismatches are reported
    # Verify all required field labels are present in the modal
    Run Keyword And Continue On Failure
    ...    Wait For Elements State    ${TXN_DETAIL_MODAL} >> text=Transaction ID         visible
    Run Keyword And Continue On Failure
    ...    Wait For Elements State    ${TXN_DETAIL_MODAL} >> text=Transaction Type       visible
    Run Keyword And Continue On Failure
    ...    Wait For Elements State    ${TXN_DETAIL_MODAL} >> text=Transaction Amount     visible
    Run Keyword And Continue On Failure
    ...    Wait For Elements State    ${TXN_DETAIL_MODAL} >> text=Service Fee            visible
    Run Keyword And Continue On Failure
    ...    Wait For Elements State    ${TXN_DETAIL_MODAL} >> text=Remarks                visible
    Run Keyword And Continue On Failure
    ...    Wait For Elements State    ${TXN_DETAIL_MODAL} >> text=Transaction Status     visible
    Run Keyword And Continue On Failure
    ...    Wait For Elements State    ${TXN_DETAIL_MODAL} >> text=Debit Account Name     visible
    Run Keyword And Continue On Failure
    ...    Wait For Elements State    ${TXN_DETAIL_MODAL} >> text=Credit Account Name    visible
    Run Keyword And Continue On Failure
    ...    Wait For Elements State    ${TXN_DETAIL_MODAL} >> text=Debit Account Number   visible
    Run Keyword And Continue On Failure
    ...    Wait For Elements State    ${TXN_DETAIL_MODAL} >> text=Credit Account Number  visible
    Run Keyword And Continue On Failure
    ...    Wait For Elements State    ${TXN_DETAIL_MODAL} >> text=Created on             visible
    Run Keyword And Continue On Failure
    ...    Wait For Elements State    ${TXN_DETAIL_MODAL} >> text=Updated on             visible
    # Close modal and verify return to transaction list
    Click                      ${TXN_DETAIL_BACK_BTN}
    Wait For Elements State    ${TXN_DETAIL_MODAL}              hidden
    Wait For Elements State    ${TRANSACTION_TABLE}             visible

t2.3.4 Search by Transaction ID
    [Documentation]    Verify that searching by a valid Transaction ID returns exactly one record,
    ...                and the detail modal displays all expected field values accurately.
    [Tags]             customers    accounts    transactions    smoke    mvp
    Fill Text                  ${TRANSACTION_SEARCH_FIELD}    ${VALID_TXN_ID}
    Click                      ${TRANSACTION_SEARCH_BUTTON}
    Wait For Elements State    ${TXN_ROW}    visible
    Get Element Count          ${TRANSACTION_TABLE_VISIBLE_ROWS}    ==    1
    # Open transaction detail modal
    Click                      ${TXN_ROW} >> ${VIEW_TXN_BTN}
    Wait For Elements State    ${TXN_DETAIL_MODAL}              visible
    # Verify all field values using exact text matching (:text-is)
    ${_txn_id}=        Get Text    ${TXN_DETAIL_MODAL} >> :text-is("${VALID_TXN_ID}")
    Run Keyword And Continue On Failure
    ...    Should Be Equal As Strings    ${_txn_id}    ${VALID_TXN_ID}
    ...    msg=Transaction ID mismatch: expected '${VALID_TXN_ID}' but got '${_txn_id}'
    ${_txn_type}=      Get Text    ${TXN_DETAIL_MODAL} >> :text-is("${TXN_TYPE}")
    Run Keyword And Continue On Failure
    ...    Should Be Equal As Strings    ${_txn_type}    ${TXN_TYPE}
    ...    msg=Transaction Type mismatch: expected '${TXN_TYPE}' but got '${_txn_type}'
    ${_txn_amount}=    Get Text    ${TXN_DETAIL_MODAL} >> :text-is("${TXN_AMOUNT}")
    Run Keyword And Continue On Failure
    ...    Should Be Equal As Strings    ${_txn_amount}    ${TXN_AMOUNT}
    ...    msg=Transaction Amount mismatch: expected '${TXN_AMOUNT}' but got '${_txn_amount}'
    ${_svc_fee}=       Get Text    ${TXN_DETAIL_MODAL} >> :text-is("${TXN_SERVICE_FEE}")
    Run Keyword And Continue On Failure
    ...    Should Be Equal As Strings    ${_svc_fee}    ${TXN_SERVICE_FEE}
    ...    msg=Service Fee mismatch: expected '${TXN_SERVICE_FEE}' but got '${_svc_fee}'
    ${_remarks}=       Get Text    ${TXN_DETAIL_MODAL} >> :text-is("${TXN_REMARKS}")
    Run Keyword And Continue On Failure
    ...    Should Be Equal As Strings    ${_remarks}    ${TXN_REMARKS}
    ...    msg=Remarks mismatch: expected '${TXN_REMARKS}' but got '${_remarks}'
    ${_status}=        Get Text    ${TXN_DETAIL_MODAL} >> :text-is("${TXN_STATUS}")
    Run Keyword And Continue On Failure
    ...    Should Be Equal As Strings    ${_status}    ${TXN_STATUS}
    ...    msg=Transaction Status mismatch: expected '${TXN_STATUS}' but got '${_status}'
    ${_debit_name}=    Get Text    ${TXN_DETAIL_MODAL} >> :text-is("${TXN_DEBIT_ACCT_NAME}")
    Run Keyword And Continue On Failure
    ...    Should Be Equal As Strings    ${_debit_name}    ${TXN_DEBIT_ACCT_NAME}
    ...    msg=Debit Account Name mismatch: expected '${TXN_DEBIT_ACCT_NAME}' but got '${_debit_name}'
    ${_credit_name}=   Get Text    ${TXN_DETAIL_MODAL} >> :text-is("${TXN_CREDIT_ACCT_NAME}")
    Run Keyword And Continue On Failure
    ...    Should Be Equal As Strings    ${_credit_name}    ${TXN_CREDIT_ACCT_NAME}
    ...    msg=Credit Account Name mismatch: expected '${TXN_CREDIT_ACCT_NAME}' but got '${_credit_name}'
    ${_debit_no}=      Get Text    ${TXN_DETAIL_MODAL} >> :text-is("${TXN_DEBIT_ACCT_NO}")
    Run Keyword And Continue On Failure
    ...    Should Be Equal As Strings    ${_debit_no}    ${TXN_DEBIT_ACCT_NO}
    ...    msg=Debit Account Number mismatch: expected '${TXN_DEBIT_ACCT_NO}' but got '${_debit_no}'
    ${_credit_no}=     Get Text    ${TXN_DETAIL_MODAL} >> :text-is("${TXN_CREDIT_ACCT_NO}")
    Run Keyword And Continue On Failure
    ...    Should Be Equal As Strings    ${_credit_no}    ${TXN_CREDIT_ACCT_NO}
    ...    msg=Credit Account Number mismatch: expected '${TXN_CREDIT_ACCT_NO}' but got '${_credit_no}'
    # Note: Created on and Updated on may have same timestamp
    ${_created_on}=    Get Text    ${TXN_DETAIL_MODAL} >> :text-is("${TXN_CREATED_ON}") >> nth=0
    Run Keyword And Continue On Failure
    ...    Should Be Equal As Strings    ${_created_on}    ${TXN_CREATED_ON}
    ...    msg=Created On mismatch: expected '${TXN_CREATED_ON}' but got '${_created_on}'
    # Close modal and verify return to filtered list
    Click                      ${TXN_DETAIL_BACK_BTN}
    Wait For Elements State    ${TXN_DETAIL_MODAL}              hidden
    Wait For Elements State    ${TXN_ROW}                       visible

t2.3.5 Search for Non-Existing Transaction ID
    [Documentation]    Verify that searching for a non-existing transaction ID shows a "No Data" message
    ...                with an empty table and no application errors.
    [Tags]             customers    accounts    transactions    negative    mvp
    Fill Text                  ${TRANSACTION_SEARCH_FIELD}    ${NON_EXISTING_TXN_ID}
    Click                      ${TRANSACTION_SEARCH_BUTTON}
    Wait For Elements State    css=.ant-empty-description:has-text("No data")    visible
    Wait For Elements State    ${TRANSACTION_TABLE}                              visible

t2.3.6 Search Transactions Using Date Range
    [Documentation]    Verify that the date range filter shows transactions within
    ...                the selected range with all required columns visible.
    [Tags]             customers    accounts    transactions    regression    mvp
    Click                      ${DATE_TIME_FILTER}
    Wait For Elements State    ${DATE_START_INPUT}              visible
    Select Date Range From AntD Picker    ${DATE_FROM}    ${DATE_TO}
    Click                      ${DATE_FILTER_SEARCH_BTN}
    Wait For Elements State    ${TRANSACTION_TABLE}             visible
    # Verify at least one result row is visible
    Wait For Elements State    ${TRANSACTION_TABLE_VISIBLE_ROWS} >> nth=0    visible
    # Verify all transaction dates are within the specified range
    Verify Txn Dates Within Range    ${DATE_FROM}    ${DATE_TO}
    # Verify all required columns are still present after filtering
    # Verify all fields — continue on failure so ALL mismatches are reported
    Run Keyword And Continue On Failure
    ...    Wait For Elements State    text=Transaction ID              visible
    Run Keyword And Continue On Failure
    ...    Wait For Elements State    text=Transaction Type            visible
    Run Keyword And Continue On Failure
    ...    Wait For Elements State    text=Date & Time                 visible
    Run Keyword And Continue On Failure
    ...    Wait For Elements State    text=Debit Amount                visible
    Run Keyword And Continue On Failure
    ...    Wait For Elements State    text=Credit Amount               visible
    Run Keyword And Continue On Failure
    ...    Wait For Elements State    text=Status                      visible
    Run Keyword And Continue On Failure
    ...    Wait For Elements State    text=Last Updated                visible
    Run Keyword And Continue On Failure
    ...    Wait For Elements State    text="Action"                    visible

t2.3.7 Filter Transactions by Type - Send Money
    [Documentation]    Verify filtering by Send Money shows only Send Money transactions.
    ...                If data exists, verifies the detail modal contains all required field labels.
    ...                If no data exists, verifies the "No Data" message.
    [Tags]             customers    accounts    transactions    regression    mvp
    Click                      ${TXN_TYPE_FILTER}
    Click                      ${TXN_TYPE_SEND_MONEY}
    Click                      ${FILTER_APPLY_BTN}
    Wait For Elements State    ${TRANSACTION_TABLE}    visible
    Filter Txn Results Should Contain Only Type    Send Money

t2.3.8 Filter Transactions by Type - Cash In
    [Documentation]    Verify filtering by Cash In shows only Cash In transactions.
    ...                If data exists, verifies the detail modal contains all required field labels.
    ...                If no data exists, verifies the "No Data" message.
    [Tags]             customers    accounts    transactions    regression    mvp
    Click                      ${TXN_TYPE_FILTER}
    Click                      ${TXN_TYPE_CASH_IN}
    Click                      ${FILTER_APPLY_BTN}
    Wait For Elements State    ${TRANSACTION_TABLE}    visible
    Filter Txn Results Should Contain Only Type    Cash In

t2.3.9 Filter Transactions by Type - Fund Transfer
    [Documentation]    Verify filtering by Fund Transfer shows only Fund Transfer transactions.
    ...                If data exists, verifies the detail modal contains all required field labels.
    ...                If no data exists, verifies the "No Data" message.
    [Tags]             customers    accounts    transactions    regression    mvp
    Click                      ${TXN_TYPE_FILTER}
    Click                      ${TXN_TYPE_FUND_TRANSFER}
    Click                      ${FILTER_APPLY_BTN}
    Wait For Elements State    ${TRANSACTION_TABLE}    visible
    Filter Txn Results Should Contain Only Type    Fund Transfer

t2.3.10 Filter Transactions by Status - Pending
    [Documentation]    Verify filtering by Pending status shows only Pending transactions.
    ...                If data exists, verifies the detail modal contains all required field labels.
    ...                If no data exists, verifies the "No Data" message.
    [Tags]             customers    accounts    transactions    regression    mvp
    Click                      ${TXN_STATUS_FILTER}
    Click                      ${TXN_STATUS_PENDING}
    Click                      ${FILTER_APPLY_BTN}
    Wait For Elements State    ${TRANSACTION_TABLE}    visible
    Filter Txn Results Should Contain Only Status    Pending

t2.3.11 Filter Transactions by Status - Success
    [Documentation]    Verify filtering by Success status shows only Success transactions.
    ...                If data exists, verifies the detail modal contains all required field labels.
    ...                If no data exists, verifies the "No Data" message.
    [Tags]             customers    accounts    transactions    regression    mvp
    Click                      ${TXN_STATUS_FILTER}
    Click                      ${TXN_STATUS_SUCCESS}
    Click                      ${FILTER_APPLY_BTN}
    Wait For Elements State    ${TRANSACTION_TABLE}    visible
    Filter Txn Results Should Contain Only Status    Success

t2.3.12 Filter Transactions by Status - Failed
    [Documentation]    Verify filtering by Failed status shows only Failed transactions.
    ...                If data exists, verifies the detail modal contains all required field labels.
    ...                If no data exists, verifies the "No Data" message.
    [Tags]             customers    accounts    transactions    regression    mvp
    Click                      ${TXN_STATUS_FILTER}
    Click                      ${TXN_STATUS_FAILED}
    Click                      ${FILTER_APPLY_BTN}
    Wait For Elements State    ${TRANSACTION_TABLE}    visible
    Filter Txn Results Should Contain Only Status    Failed
