*** Settings ***
Documentation       t3.2 View the List of Transactions of a Bank Account
...                 Covers entry point via Accounts module, pagination, transaction detail view,
...                 search by ID, date range filtering, type filtering, status filtering,
...                 and navigation back to Accounts list.

Resource            ../../resources/keywords/common.resource
Resource            ../../resources/keywords/accounts.resource

Suite Setup         Login To Teller App
Suite Teardown      Close Browser
Test Setup          Setup Account Transaction Page
Test Teardown       Close Modal If Open


*** Keywords ***
Setup Account Transaction Page
    [Documentation]    Navigates to the Transaction History page for the target account
    ...                via the Accounts module and ensures a clean state.
    Navigate To Account Transactions    ${VALID_ACCOUNT_NUMBER}
    Reload
    Wait For Load Spinner To Disappear


*** Variables ***
${VALID_ACCOUNT_NUMBER}     7710458152114857
${VALID_ACCOUNT_NAME}       Peach Villados

# Target transaction for search and detail verification
${VALID_TXN_ID}             0fbb394edde64d9d83bf945291919df0
${TXN_TYPE}                 Fund Transfer
${TXN_AMOUNT}               50,000.00
${TXN_SERVICE_FEE}          0.00
${TXN_REMARKS}              N/A
${TXN_STATUS}               Success
${TXN_DEBIT_ACCT_NAME}      Chai Villados
${TXN_CREDIT_ACCT_NAME}     Peach Villados
${TXN_DEBIT_ACCT_NO}        7710455410784261
${TXN_CREDIT_ACCT_NO}       7710458152114857
${TXN_CREATED_ON}           01 Oct 2025 15:06:28
${TXN_ROW}                  css=.ant-table-body table tbody tr:has-text("${VALID_TXN_ID}")
${NON_EXISTING_TXN_ID}      NONEXISTENT99999

# Date range for t3.2.5
${DATE_FROM}                2026-03-01
${DATE_TO}                  2026-03-06


*** Test Cases ***
t3.2.1 View Account Transaction History (Entry Point)
    [Documentation]    Verify that clicking View Transactions from the Accounts module navigates
    ...                to the Transaction History page with all required columns and action buttons.
    [Tags]             accounts    transactions    smoke    mvp
    Get Url                    contains    /transactions
    Wait For Elements State    text=Transaction ID                                       visible
    Wait For Elements State    text=Transaction Type                                     visible
    Wait For Elements State    text=Date & Time                                          visible
    Wait For Elements State    text=Debit Amount                                         visible
    Wait For Elements State    text=Credit Amount                                        visible
    Wait For Elements State    text=Status                                               visible
    Wait For Elements State    text=Last Updated                                         visible
    Wait For Elements State    text="Action"                                             visible
    Wait For Elements State    ${VIEW_TXN_BTN} >> nth=0                                 visible
    Wait For Elements State    ${DOWNLOAD_TXN_BTN} >> nth=0                             visible

t3.2.2 Pagination in Viewing Transaction History
    [Documentation]    Verify pagination controls work correctly:
    ...                Next loads page 2, clicking page 3 loads page 3,
    ...                and Back returns to page 2.
    [Tags]             accounts    transactions    regression    mvp
    # Click Next arrow to go to page 2
    Click                      ${PAGINATION_NEXT}
    Wait For Elements State    css=li.ant-pagination-item-active:has-text("2")    visible
    # Click page number 3
    Click                      css=li.ant-pagination-item:has-text("3")
    Wait For Elements State    css=li.ant-pagination-item-active:has-text("3")    visible
    # Click Back arrow to return to page 2
    Click                      ${PAGINATION_PREV}
    Wait For Elements State    css=li.ant-pagination-item-active:has-text("2")    visible

t3.2.3 View Specific Transaction Details (via Accounts)
    [Documentation]    Verify that clicking the Eye icon opens the transaction detail modal
    ...                with all required field labels, and the modal closes cleanly.
    [Tags]             accounts    transactions    smoke    mvp
    Click                      ${VIEW_TXN_BTN} >> nth=0
    Wait For Elements State    ${ACCT_TXN_DETAIL_MODAL}                                    visible
    # Verify all required field labels are present in the modal
    Wait For Elements State    ${ACCT_TXN_DETAIL_MODAL} >> text=Transaction ID             visible
    Wait For Elements State    ${ACCT_TXN_DETAIL_MODAL} >> text=Transaction Type           visible
    Wait For Elements State    ${ACCT_TXN_DETAIL_MODAL} >> text=Transaction Amount         visible
    Wait For Elements State    ${ACCT_TXN_DETAIL_MODAL} >> text=Service Fee               visible
    Wait For Elements State    ${ACCT_TXN_DETAIL_MODAL} >> text=Remarks                   visible
    Wait For Elements State    ${ACCT_TXN_DETAIL_MODAL} >> text=Transaction Status         visible
    Wait For Elements State    ${ACCT_TXN_DETAIL_MODAL} >> text=Debit Account Name        visible
    Wait For Elements State    ${ACCT_TXN_DETAIL_MODAL} >> text=Credit Account Name       visible
    Wait For Elements State    ${ACCT_TXN_DETAIL_MODAL} >> text=Debit Account Number      visible
    Wait For Elements State    ${ACCT_TXN_DETAIL_MODAL} >> text=Credit Account Number     visible
    Wait For Elements State    ${ACCT_TXN_DETAIL_MODAL} >> text=Created on                visible
    Wait For Elements State    ${ACCT_TXN_DETAIL_MODAL} >> text=Updated on                visible
    # Close modal and verify return to transaction list
    Click                      ${ACCT_TXN_DETAIL_BACK_BTN}
    Wait For Elements State    ${ACCT_TXN_DETAIL_MODAL}    hidden
    Wait For Elements State    ${ACCT_TXN_TABLE}           visible

t3.2.4 Search Transaction by ID and View Details (via Accounts)
    [Documentation]    Verify that searching by a valid Transaction ID returns exactly one record,
    ...                and the detail modal displays all expected field values accurately.
    [Tags]             accounts    transactions    smoke    mvp
    Fill Text                  ${ACCT_TXN_SEARCH_FIELD}    ${VALID_TXN_ID}
    Click                      ${ACCT_TXN_SEARCH_BUTTON}
    Wait For Load Spinner To Disappear
    Wait For Elements State    ${TXN_ROW}    visible
    Get Element Count          css=.ant-table-body table tbody tr:not([aria-hidden="true"])    ==    1
    # Open transaction detail modal
    Click                      ${TXN_ROW} >> ${VIEW_TXN_BTN}
    Wait For Elements State    ${ACCT_TXN_DETAIL_MODAL}                                        visible
    # Verify all field values match the expected transaction data
    Wait For Elements State    ${ACCT_TXN_DETAIL_MODAL} >> text=${VALID_TXN_ID}               visible
    Wait For Elements State    ${ACCT_TXN_DETAIL_MODAL} >> text=${TXN_TYPE}                   visible
    Wait For Elements State    ${ACCT_TXN_DETAIL_MODAL} >> text=${TXN_AMOUNT}                 visible
    Wait For Elements State    ${ACCT_TXN_DETAIL_MODAL} >> text="${TXN_SERVICE_FEE}"          visible
    Wait For Elements State    ${ACCT_TXN_DETAIL_MODAL} >> text=${TXN_REMARKS}                visible
    Wait For Elements State    ${ACCT_TXN_DETAIL_MODAL} >> text=${TXN_STATUS}                 visible
    Wait For Elements State    ${ACCT_TXN_DETAIL_MODAL} >> text=${TXN_DEBIT_ACCT_NAME}        visible
    Wait For Elements State    ${ACCT_TXN_DETAIL_MODAL} >> text=${TXN_CREDIT_ACCT_NAME}       visible
    Wait For Elements State    ${ACCT_TXN_DETAIL_MODAL} >> text=${TXN_DEBIT_ACCT_NO}          visible
    Wait For Elements State    ${ACCT_TXN_DETAIL_MODAL} >> text=${TXN_CREDIT_ACCT_NO}         visible
    Wait For Elements State    ${ACCT_TXN_DETAIL_MODAL} >> text=${TXN_CREATED_ON} >> nth=0    visible
    # Close modal and verify return to filtered list
    Click                      ${ACCT_TXN_DETAIL_BACK_BTN}
    Wait For Elements State    ${ACCT_TXN_DETAIL_MODAL}    hidden
    Wait For Elements State    ${TXN_ROW}                  visible

t3.2.5 Search Transactions Using Date Range (via Accounts)
    [Documentation]    Verify the date range filter shows only transactions within the selected range.
    [Tags]             accounts    transactions    regression    mvp
    # Apply a date range with known results
    Click                      ${DATE_TIME_FILTER}
    Wait For Elements State    ${DATE_START_INPUT}    visible
    Select Date Range From AntD Picker    ${DATE_FROM}    ${DATE_TO}
    Click                      ${DATE_FILTER_SEARCH_BTN}
    Wait For Elements State    ${ACCT_TXN_TABLE}    visible
    # Verify at least one result row is visible
    Wait For Elements State    css=.ant-table-body table tbody tr:not([aria-hidden="true"]) >> nth=0    visible
    # Verify all transaction dates are within the specified range
    Verify Acct Txn Dates Within Range    ${DATE_FROM}    ${DATE_TO}
    # Verify all required columns are still present after filtering
    Wait For Elements State    text=Transaction ID       visible
    Wait For Elements State    text=Transaction Type     visible
    Wait For Elements State    text=Date & Time          visible
    Wait For Elements State    text=Debit Amount         visible
    Wait For Elements State    text=Credit Amount        visible
    Wait For Elements State    text=Status               visible
    Wait For Elements State    text=Last Updated         visible
    Wait For Elements State    text="Action"             visible

t3.2.6 Filter Transactions by Type: Send Money (via Accounts)
    [Documentation]    Verify filtering by Send Money shows only Send Money transactions.
    ...                If data exists, verifies the detail modal contains all required fields.
    ...                If no data, verifies the "No Data" message.
    [Tags]             accounts    transactions    regression    mvp
    Click                      ${TXN_TYPE_FILTER}
    Click                      ${TXN_TYPE_SEND_MONEY}
    Click                      ${FILTER_APPLY_BTN}
    Wait For Elements State    ${ACCT_TXN_TABLE}    visible
    Filter Acct Txn Results Should Contain Only Type    Send Money

t3.2.7 Filter Transactions by Type: Cash In (via Accounts)
    [Documentation]    Verify filtering by Cash In shows only Cash In transactions.
    ...                If data exists, verifies the detail modal contains all required fields.
    ...                If no data, verifies the "No Data" message.
    [Tags]             accounts    transactions    regression    mvp
    Click                      ${TXN_TYPE_FILTER}
    Click                      ${TXN_TYPE_CASH_IN}
    Click                      ${FILTER_APPLY_BTN}
    Wait For Elements State    ${ACCT_TXN_TABLE}    visible
    Filter Acct Txn Results Should Contain Only Type    Cash In

t3.2.8 Filter Transactions by Type: Fund Transfer (via Accounts)
    [Documentation]    Verify filtering by Fund Transfer shows only Fund Transfer transactions.
    ...                If data exists, verifies the detail modal contains all required fields.
    ...                If no data, verifies the "No Data" message.
    [Tags]             accounts    transactions    regression    mvp
    Click                      ${TXN_TYPE_FILTER}
    Click                      ${TXN_TYPE_FUND_TRANSFER}
    Click                      ${FILTER_APPLY_BTN}
    Wait For Elements State    ${ACCT_TXN_TABLE}    visible
    Filter Acct Txn Results Should Contain Only Type    Fund Transfer

t3.2.9 Filter Transactions by Status: Pending (via Accounts)
    [Documentation]    Verify filtering by Pending status shows only Pending transactions.
    ...                If data exists, verifies the detail modal contains all required fields.
    ...                If no data, verifies the "No Data" message.
    [Tags]             accounts    transactions    regression    mvp
    Click                      ${TXN_STATUS_FILTER}
    Click                      ${TXN_STATUS_PENDING}
    Click                      ${FILTER_APPLY_BTN}
    Wait For Elements State    ${ACCT_TXN_TABLE}    visible
    Filter Acct Txn Results Should Contain Only Status    Pending

t3.2.10 Filter Transactions by Status: Success (via Accounts)
    [Documentation]    Verify filtering by Success status shows only Success transactions.
    ...                If data exists, verifies the detail modal contains all required fields.
    ...                If no data, verifies the "No Data" message.
    [Tags]             accounts    transactions    regression    mvp
    Click                      ${TXN_STATUS_FILTER}
    Click                      ${TXN_STATUS_SUCCESS}
    Click                      ${FILTER_APPLY_BTN}
    Wait For Elements State    ${ACCT_TXN_TABLE}    visible
    Filter Acct Txn Results Should Contain Only Status    Success

t3.2.11 Filter Transactions by Status: Failed (via Accounts)
    [Documentation]    Verify filtering by Failed status shows only Failed transactions.
    ...                If data exists, verifies the detail modal contains all required fields.
    ...                If no data, verifies the "No Data" message.
    [Tags]             accounts    transactions    regression    mvp
    Click                      ${TXN_STATUS_FILTER}
    Click                      ${TXN_STATUS_FAILED}
    Click                      ${FILTER_APPLY_BTN}
    Wait For Elements State    ${ACCT_TXN_TABLE}    visible
    Filter Acct Txn Results Should Contain Only Status    Failed

t3.2.12 Navigate Back to Accounts List (from View Transactions)
    [Documentation]    Verify that clicking the Accounts breadcrumb link returns the user
    ...                to the main Accounts List View.
    [Tags]             accounts    transactions    smoke    mvp
    Wait For Elements State    ${ACCOUNTS_BREADCRUMB_LINK}    visible
    Click                      ${ACCOUNTS_BREADCRUMB_LINK}
    Wait For Elements State    ${ACCOUNTS_SEARCH_FIELD}       visible
    Get Url                    contains    /accounts
