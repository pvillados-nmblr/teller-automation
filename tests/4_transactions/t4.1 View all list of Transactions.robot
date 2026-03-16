*** Settings ***
Documentation       t4.1 View all list of Transactions
...                 Covers entry point via Transactions sidebar, pagination, transaction detail view,
...                 search by ID, date range filtering, type filtering, status filtering,
...                 and total balance verification.

Resource            ../../resources/keywords/common.resource
Resource            ../../resources/keywords/transactions.resource

Suite Setup         Login To Teller App
Suite Teardown      Close Browser
Test Setup          Setup Transactions Page
Test Teardown       Close Modal If Open


*** Variables ***
# Target transaction for t4.1.5 search and detail verification (External/Cash In)
${VALID_TXN_ID}             431bd41cd7144d6395fd7f07bd3053a5
${TXN_TYPE}                 Cash In
${TXN_AMOUNT}               550.50
${TXN_SERVICE_FEE}          0.00
${TXN_REMARKS}              Online Transfer
${TXN_STATUS}               Success
${TXN_INSTAPAY_REF}         813742
${TXN_DEBIT_ACCT_NAME}      jooo Abucay
${TXN_CREDIT_ACCT_NAME}     Camille Reyes Mendoza
${TXN_DEBIT_ACCT_NO}        7710501333354703
${TXN_CREDIT_ACCT_NO}       7710332470539251
${TXN_DEBIT_BANK_CODE}      RCBCPHMMXXX
${TXN_DEBIT_BANK_NAME}      Banco Abucay
${TXN_CREATED_ON}           10 Mar 2026 09:24:18
${TXN_ROW}                  css=.ant-table-body table tbody tr:has-text("${VALID_TXN_ID}")
${NON_EXISTING_TXN_ID}      NONEXISTENT99999

# Date range for t4.1.6 — positive test (data exists on this date)
${DATE_FROM}                2026-03-10
${DATE_TO}                  2026-03-11

# Date range for t4.1.6 — negative test (future date with no expected data)
${DATE_EMPTY_FROM}          2027-01-01
${DATE_EMPTY_TO}            2027-01-31


*** Test Cases ***
t4.1.1 View Transaction History (Entry Point)
    [Documentation]    Verify that navigating to the Transactions module displays the Transactions page
    ...                with all required table columns and action buttons visible.
    [Tags]             transactions    smoke    mvp
    Get Url                    contains    /transactions
    Wait For Elements State    text=Transaction ID            visible
    Wait For Elements State    text=Transaction Type          visible
    Wait For Elements State    text=Date & Time               visible
    Wait For Elements State    text=Credit Account Number     visible
    Wait For Elements State    text=Debit Account Number      visible
    Wait For Elements State    text=Total Amount              visible
    Wait For Elements State    text=Status                    visible
    Wait For Elements State    text="Action"    visible
    Wait For Elements State    ${TXN_VIEW_BTN} >> nth=0      visible
    Wait For Elements State    ${TXN_DOWNLOAD_BTN} >> nth=0  visible

t4.1.2 Pagination in Viewing Transaction History
    [Documentation]    Verify pagination controls work correctly:
    ...                Next loads page 2, clicking page 3 loads page 3,
    ...                and Back returns to page 2.
    [Tags]             transactions    regression    mvp
    # Click Next arrow to go to page 2
    Click                      ${PAGINATION_NEXT}
    Wait For Elements State    css=li.ant-pagination-item-active:has-text("2")    visible
    # Click page number 3
    Click                      css=li.ant-pagination-item:has-text("3")
    Wait For Elements State    css=li.ant-pagination-item-active:has-text("3")    visible
    # Click Back arrow to return to page 2
    Click                      ${PAGINATION_PREV}
    Wait For Elements State    css=li.ant-pagination-item-active:has-text("2")    visible

t4.1.4 View Specific Transaction Details
    [Documentation]    Verify that clicking the Eye icon opens the transaction detail modal
    ...                with all required field labels and the modal closes cleanly.
    [Tags]             transactions    smoke    mvp
    Click                      ${TXN_VIEW_BTN} >> nth=0
    Wait For Elements State    ${TXN_DETAIL_MODAL}                                       visible
    Wait For Elements State    ${TXN_DETAIL_MODAL} >> text=Transaction ID                visible
    Wait For Elements State    ${TXN_DETAIL_MODAL} >> text=Transaction Type              visible
    Wait For Elements State    ${TXN_DETAIL_MODAL} >> text=Transaction Amount            visible
    Wait For Elements State    ${TXN_DETAIL_MODAL} >> text=Service Fee                  visible
    Wait For Elements State    ${TXN_DETAIL_MODAL} >> text=Remarks                      visible
    Wait For Elements State    ${TXN_DETAIL_MODAL} >> text=Transaction Status            visible
    Wait For Elements State    ${TXN_DETAIL_MODAL} >> text=Debit Account Name           visible
    Wait For Elements State    ${TXN_DETAIL_MODAL} >> text=Credit Account Name          visible
    Wait For Elements State    ${TXN_DETAIL_MODAL} >> text=Debit Account Number         visible
    Wait For Elements State    ${TXN_DETAIL_MODAL} >> text=Credit Account Number        visible
    Wait For Elements State    ${TXN_DETAIL_MODAL} >> text=Created on                   visible
    Wait For Elements State    ${TXN_DETAIL_MODAL} >> text=Updated on                   visible
    # Close modal and verify return to the transaction list
    Click                      ${TXN_DETAIL_BACK_BTN}
    Wait For Elements State    ${TXN_DETAIL_MODAL}    hidden
    Wait For Elements State    ${TXN_TABLE}           visible

t4.1.5 Search Transaction by ID and View Details
    [Documentation]    Verify that searching by a known valid Transaction ID returns exactly one record,
    ...                the detail modal displays all expected field values accurately including
    ...                Instapay Reference Number and Bank Code/Name for External transactions,
    ...                and the modal closes cleanly returning to the filtered list.
    [Tags]             transactions    smoke    mvp
    Fill Text                  ${TXN_SEARCH_FIELD}    ${VALID_TXN_ID}
    Click                      ${TXN_SEARCH_BUTTON}
    Wait For Load Spinner To Disappear
    Wait For Elements State    ${TXN_ROW}    visible
    Get Element Count          css=.ant-table-body table tbody tr:not([aria-hidden="true"])    ==    1
    # Open transaction detail modal
    Click                      ${TXN_ROW} >> ${TXN_VIEW_BTN}
    Wait For Elements State    ${TXN_DETAIL_MODAL}                                           visible
    # Verify field values match the expected External/Cash In transaction data
    Wait For Elements State    ${TXN_DETAIL_MODAL} >> text=${VALID_TXN_ID}                  visible
    Wait For Elements State    ${TXN_DETAIL_MODAL} >> text=${TXN_TYPE}                      visible
    Wait For Elements State    ${TXN_DETAIL_MODAL} >> text=${TXN_AMOUNT}                    visible
    Wait For Elements State    ${TXN_DETAIL_MODAL} >> text="${TXN_SERVICE_FEE}"             visible
    Wait For Elements State    ${TXN_DETAIL_MODAL} >> text=${TXN_REMARKS}                   visible
    Wait For Elements State    ${TXN_DETAIL_MODAL} >> text=${TXN_STATUS}                    visible
    Wait For Elements State    ${TXN_DETAIL_MODAL} >> text=${TXN_INSTAPAY_REF}              visible
    Wait For Elements State    ${TXN_DETAIL_MODAL} >> text=${TXN_DEBIT_ACCT_NAME}           visible
    Wait For Elements State    ${TXN_DETAIL_MODAL} >> text=${TXN_CREDIT_ACCT_NAME}          visible
    Wait For Elements State    ${TXN_DETAIL_MODAL} >> text=${TXN_DEBIT_ACCT_NO}             visible
    Wait For Elements State    ${TXN_DETAIL_MODAL} >> text=${TXN_CREDIT_ACCT_NO}            visible
    Wait For Elements State    ${TXN_DETAIL_MODAL} >> text=${TXN_DEBIT_BANK_CODE}           visible
    Wait For Elements State    ${TXN_DETAIL_MODAL} >> text=${TXN_DEBIT_BANK_NAME}           visible
    Wait For Elements State    ${TXN_DETAIL_MODAL} >> text=${TXN_CREATED_ON} >> nth=0       visible
    # Close modal and verify return to the filtered list
    Click                      ${TXN_DETAIL_BACK_BTN}
    Wait For Elements State    ${TXN_DETAIL_MODAL}    hidden
    Wait For Elements State    ${TXN_ROW}             visible

t4.1.6 Search Transactions Using Date Range
    [Documentation]    Verify the date range filter shows only transactions within the selected range.
    [Tags]             transactions    regression    mvp
    Click                      ${TXN_DATE_TIME_FILTER}
    Wait For Elements State    ${TXN_DATE_START_INPUT}    visible
    Select Txn Date Range From AntD Picker    ${DATE_FROM}    ${DATE_TO}
    Click                      ${TXN_DATE_FILTER_SEARCH_BTN}
    Wait For Elements State    ${TXN_TABLE}    visible
    Wait For Elements State    css=.ant-table-body table tbody tr:not([aria-hidden="true"]) >> nth=0    visible
    Verify Txn Dates Within Range    ${DATE_FROM}    ${DATE_TO}
    # Verify all required columns are still present after filtering
    Wait For Elements State    text=Transaction ID           visible
    Wait For Elements State    text=Transaction Type         visible
    Wait For Elements State    text=Date & Time              visible
    Wait For Elements State    text=Credit Account Number    visible
    Wait For Elements State    text=Debit Account Number     visible
    Wait For Elements State    text=Total Amount             visible
    Wait For Elements State    text=Status                   visible
    Wait For Elements State    text="Action"    visible

t4.1.7 Filter Transactions by Type: External
    [Documentation]    Verify filtering by External type shows only External transactions.
    ...                The detail view includes Instapay Reference Number for External transactions.
    ...                If no External transactions exist, the system displays "No Data".
    [Tags]             transactions    regression    mvp
    Click                      ${TXN_TYPE_FILTER}
    Click                      ${TXN_FILTER_EXTERNAL}
    Click                      ${TXN_FILTER_APPLY_BTN}
    Wait For Elements State    ${TXN_TABLE}    visible
    Filter Txn Results Should Contain Only Type    External

t4.1.8 Filter Transactions by Type: Internal
    [Documentation]    Verify filtering by Internal type shows only Internal (Fund Transfer) transactions.
    ...                If no Internal transactions exist, the system displays "No Data".
    [Tags]             transactions    regression    mvp
    Click                      ${TXN_TYPE_FILTER}
    Click                      ${TXN_FILTER_INTERNAL}
    Click                      ${TXN_FILTER_APPLY_BTN}
    Wait For Elements State    ${TXN_TABLE}    visible
    Filter Txn Results Should Contain Only Type    Internal

Filter Transactions by Type: Withdrawal
    [Documentation]    Verify filtering by Withdrawal type shows only Withdrawal transactions.
    ...                If no Withdrawal transactions exist, the system displays "No Data".
    [Tags]             transactions    regression    mvp
    Click                      ${TXN_TYPE_FILTER}
    Click                      ${TXN_FILTER_WITHDRAWAL}
    Click                      ${TXN_FILTER_APPLY_BTN}
    Wait For Elements State    ${TXN_TABLE}    visible
    Filter Txn Results Should Contain Only Type    Withdraw

Filter Transactions by Type: Deposit
    [Documentation]    Verify filtering by Deposit type shows only Deposit transactions.
    ...                If no Deposit transactions exist, the system displays "No Data".
    [Tags]             transactions    regression    mvp
    Click                      ${TXN_TYPE_FILTER}
    Click                      ${TXN_FILTER_DEPOSIT}
    Click                      ${TXN_FILTER_APPLY_BTN}
    Wait For Elements State    ${TXN_TABLE}    visible
    Filter Txn Results Should Contain Only Type    Deposit

t4.1.9 Filter Transactions by Status: Pending
    [Documentation]    Verify filtering by Pending status shows only Pending transactions.
    ...                If no Pending transactions exist, the system displays "No Data".
    [Tags]             transactions    regression    mvp
    Click                      ${TXN_STATUS_FILTER}
    Click                      ${TXN_STATUS_PENDING}
    Click                      ${TXN_FILTER_APPLY_BTN}
    Wait For Elements State    ${TXN_TABLE}    visible
    Filter Txn Results Should Contain Only Status    Pending

t4.1.10 Filter Transactions by Status: Success
    [Documentation]    Verify filtering by Success status shows only Success transactions.
    ...                If no Success transactions exist, the system displays "No Data".
    [Tags]             transactions    regression    mvp
    Click                      ${TXN_STATUS_FILTER}
    Click                      ${TXN_STATUS_SUCCESS}
    Click                      ${TXN_FILTER_APPLY_BTN}
    Wait For Elements State    ${TXN_TABLE}    visible
    Filter Txn Results Should Contain Only Status    Success

t4.1.11 Filter Transactions by Status: Failed
    [Documentation]    Verify filtering by Failed status shows only Failed transactions.
    ...                If no Failed transactions exist, the system displays "No Data".
    [Tags]             transactions    regression    mvp
    Click                      ${TXN_STATUS_FILTER}
    Click                      ${TXN_STATUS_FAILED}
    Click                      ${TXN_FILTER_APPLY_BTN}
    Wait For Elements State    ${TXN_TABLE}    visible
    Filter Txn Results Should Contain Only Status    Failed

t4.1.12 Verify Total Balance Calculation
    [Documentation]    Verify the Total Balance displayed on the Transactions page equals
    ...                the sum of all account balances from the Accounts module.
    [Tags]             transactions    smoke    mvp    skip
    # Step 1: Get Total Balance value from Transactions page
    Wait For Elements State    ${TOTAL_BALANCE_CARD}    visible
    ${balance_text}=           Get Text    ${TOTAL_BALANCE_CARD}
    Should Contain             ${balance_text}    Total Balance
    Should Match Regexp        ${balance_text}    PHP\\s+[0-9,]+\\.[0-9]{2}
    ${total_str}=              Evaluate
    ...    '''${balance_text}'''.replace('Total Balance', '').replace(':', '').replace('PHP', '').replace(',', '').replace('\\n', ' ').strip()
    ${transactions_total}=     Convert To Number    ${total_str}
    # Step 2: Navigate to Accounts and sum all account balances across all pages
    Click                      ${SIDEBAR_ACCOUNTS}
    Wait For Load Spinner To Disappear
    Wait For Elements State    css=.ant-table-body table    visible
    ${accounts_sum}=           Sum All Account Balances
    # Step 3: Navigate back to Transactions and compare
    Navigate To Transactions
    ${txn_rounded}=            Evaluate    round(${transactions_total}, 2)
    ${acc_rounded}=            Evaluate    round(${accounts_sum}, 2)
    Should Be Equal As Numbers    ${txn_rounded}    ${acc_rounded}
    ...    msg=Total Balance on Transactions page (${txn_rounded}) does not match sum of account balances (${acc_rounded})
