*** Settings ***
Library     Browser
Resource    common.resource
Resource    ../locators/customers_locators.resource


*** Keywords ***
Navigate To Customers
    [Documentation]    Navigates to the Customers module via the sidebar and ensures clean state
    Click                      ${CUSTOMERS_MENU}
    Wait For Elements State    ${CUSTOMER_SEARCH_FIELD}    visible
    Get Url                    contains    /customers
    Reload
    Wait For Elements State    ${CUSTOMER_SEARCH_FIELD}    visible

View Customer List
    [Documentation]    Verifies the customer list page is loaded and visible
    Wait For Elements State    ${CUSTOMER_TABLE}    visible

Search For Customer
    [Documentation]    Searches for a customer by name or Customer ID
    [Arguments]        ${search_value}
    Fill Text          ${CUSTOMER_SEARCH_FIELD}    ${search_value}
    Click              ${CUSTOMER_SEARCH_BUTTON}
    Wait For Elements State    ${CUSTOMER_TABLE}    visible

Clear Customer Search
    [Documentation]    Clears the customer search field and reloads the full list
    Fill Text          ${CUSTOMER_SEARCH_FIELD}    ${EMPTY}
    Click              ${CUSTOMER_SEARCH_BUTTON}
    Wait For Elements State    ${CUSTOMER_TABLE}    visible

Reset Customer Status Filter
    [Documentation]    Resets any applied customer status filter
    ${filter_active}=    Run Keyword And Return Status
    ...                  Wait For Elements State    css=span.ant-table-filter-trigger.active    visible    timeout=1s
    IF    ${filter_active}
        Click                      ${CUSTOMER_STATUS_FILTER}
        Wait For Elements State    ${FILTER_RESET_BTN}    visible
        Click                      ${FILTER_RESET_BTN}
        Sleep    0.5s
    END

View Customer Profile
    [Documentation]    Clicks View Profile for a specific customer row matching the given name.
    ...                Searches for the customer first to ensure visibility regardless of filter state.
    [Arguments]        ${customer_name}
    Search For Customer    ${customer_name}
    Click              css=tr:has-text("${customer_name}") >> ${VIEW_PROFILE_LINK} >> nth=0
    Wait For Elements State    text=Banking Details    visible

View Customer Accounts
    [Documentation]    Clicks View Accounts for a specific customer row matching the given name.
    ...                Searches for the customer first to ensure visibility regardless of filter state.
    [Arguments]        ${customer_name}
    Search For Customer    ${customer_name}
    Click              css=tr:has-text("${customer_name}") >> ${VIEW_ACCOUNTS_LINK} >> nth=0
    Wait For Elements State    ${ACCOUNT_SEARCH_FIELD}    visible

View Customer Account Transactions
    [Documentation]    Clicks View Account Transactions for a specific account row
    [Arguments]        ${account_number}
    Click              css=tr:has-text("${account_number}") >> ${VIEW_ACCOUNT_TRANSACTIONS_LINK}
    Wait For Elements State    ${TRANSACTION_SEARCH_FIELD}    visible

Navigate To Customer Account Transactions Page
    [Documentation]    Navigates to the Account Transactions page for the target account
    ...                via Customers → View Accounts → View Account Transactions
    [Arguments]        ${customer_name}    ${account_number}
    Navigate To Customers
    View Customer Accounts              ${customer_name}
    View Customer Account Transactions  ${account_number}
    Wait For Load Spinner To Disappear

Wait For Load Spinner To Disappear
    [Documentation]    Waits for any loading spinner to disappear before proceeding
    ${spinner_visible}=    Run Keyword And Return Status
    ...                    Wait For Elements State    css=.ant-spin-spinning    visible    timeout=2s
    IF    ${spinner_visible}
        Wait For Elements State    css=.ant-spin-spinning    hidden    timeout=30s
    END

Filter Account Results Should Contain Only Status
    [Documentation]    Verifies that all visible rows in the customer accounts table match the expected
    ...                status, or that a "No Data" message is shown if no matching records exist.
    ...                Iterates through all pagination pages to verify each page (max 10 rows per page).
    [Arguments]        ${expected_status}
    Sleep    1s    # Wait for filter to apply
    ${no_data_visible}=    Run Keyword And Return Status
    ...                    Wait For Elements State    css=.ant-empty-description    visible    timeout=3s
    IF    ${no_data_visible}
        Log    No data found for status: ${expected_status}
    ELSE
        ${page}=    Set Variable    1
        WHILE    ${page} <= 100    # Safety limit to prevent infinite loop
            ${total_rows}=      Get Element Count    css=[data-testid="table-customers-accounts"] tbody tr:not([aria-hidden="true"]):not(:empty)
            ${matching_rows}=   Get Element Count    css=[data-testid="table-customers-accounts"] tbody tr:not([aria-hidden="true"]):has-text("${expected_status}")
            Should Be Equal    ${total_rows}    ${matching_rows}
            ...    Page ${page}: Expected all ${total_rows} rows to have status "${expected_status}", but only ${matching_rows} matched
            Log    Page ${page}: All ${total_rows} rows contain status "${expected_status}"
            ${next_disabled}=    Run Keyword And Return Status
            ...                  Wait For Elements State    css=.ant-pagination-next.ant-pagination-disabled    visible    timeout=1s
            IF    ${next_disabled}
                Log    Reached last page (page ${page})
                BREAK
            END
            Click    css=.ant-pagination-next button
            Sleep    0.5s    # Wait for page to load
            ${page}=    Evaluate    ${page} + 1
        END
    END

Navigate To Customer Accounts Page
    [Documentation]    Navigates to the View Accounts page for the target customer
    [Arguments]        ${customer_name}
    Navigate To Customers
    View Customer Accounts    ${customer_name}

Filter Results Should Contain Only Status
    [Documentation]    Verifies that all visible rows across all pages match the expected status,
    ...                or that a "No Data" message is shown if no matching records exist.
    ...                Iterates through all pagination pages to verify each page (max 10 rows per page).
    [Arguments]        ${expected_status}
    Sleep    1s    # Wait for filter to apply
    ${no_data_visible}=    Run Keyword And Return Status
    ...                    Wait For Elements State    css=.ant-empty-description    visible    timeout=3s
    IF    ${no_data_visible}
        Log    No data found for status: ${expected_status}
    ELSE
        ${page}=    Set Variable    1
        WHILE    ${page} <= 100    # Safety limit to prevent infinite loop
            # Count total visible rows (exclude hidden/empty rows) and rows with expected status
            ${total_rows}=      Get Element Count    css=[data-testid="table-customers"] tbody tr:not([aria-hidden="true"]):not(:empty)
            ${matching_rows}=   Get Element Count    css=[data-testid="table-customers"] tbody tr:not([aria-hidden="true"]):has-text("${expected_status}")
            # Verify all rows match the expected status
            Should Be Equal    ${total_rows}    ${matching_rows}
            ...    Page ${page}: Expected all ${total_rows} rows to have status "${expected_status}", but only ${matching_rows} matched
            Log    Page ${page}: All ${total_rows} rows contain status "${expected_status}"
            # Check if next page button is disabled (last page)
            ${next_disabled}=    Run Keyword And Return Status
            ...                  Wait For Elements State    css=.ant-pagination-next.ant-pagination-disabled    visible    timeout=1s
            IF    ${next_disabled}
                Log    Reached last page (page ${page})
                BREAK
            END
            # Click next page
            Click    css=.ant-pagination-next button
            Sleep    0.5s    # Wait for page to load
            ${page}=    Evaluate    ${page} + 1
        END
    END

Filter Txn Results Should Contain Only Type
    [Documentation]    Verifies that all visible transaction rows match the expected type.
    ...                If data exists, also clicks the first row's Eye icon and verifies
    ...                the detail modal contains all required field labels, then closes it.
    ...                If no data, verifies the "No Data" message.
    [Arguments]        ${expected_type}
    Wait For Load Spinner To Disappear
    Sleep    1s    # Wait for filter to apply
    ${no_data_visible}=    Run Keyword And Return Status
    ...                    Wait For Elements State    css=.ant-empty-description    visible    timeout=3s
    IF    ${no_data_visible}
        Log    No data found for type: ${expected_type}
    ELSE
        ${total_rows}=      Get Element Count    css=[data-testid="table-customers-account-transactions"] tbody tr:not([aria-hidden="true"]):not(:empty)
        ${matching_rows}=   Get Element Count    css=[data-testid="table-customers-account-transactions"] tbody tr:not([aria-hidden="true"]):has-text("${expected_type}")
        Should Be Equal    ${total_rows}    ${matching_rows}
        ...    Expected all ${total_rows} rows to have type "${expected_type}", but only ${matching_rows} matched
        Log    All ${total_rows} rows contain type "${expected_type}"
        # Wait for spinner and open first row detail modal
        Wait For Load Spinner To Disappear
        Click    ${VIEW_TXN_BTN} >> nth=0
        Wait For Elements State    ${TXN_DETAIL_MODAL}              visible
        Wait For Elements State    ${TXN_DETAIL_MODAL} >> text=Transaction ID         visible
        Wait For Elements State    ${TXN_DETAIL_MODAL} >> text=Transaction Type       visible
        Wait For Elements State    ${TXN_DETAIL_MODAL} >> text=Transaction Amount     visible
        Wait For Elements State    ${TXN_DETAIL_MODAL} >> text=Service Fee            visible
        Wait For Elements State    ${TXN_DETAIL_MODAL} >> text=Remarks                visible
        Wait For Elements State    ${TXN_DETAIL_MODAL} >> text=Transaction Status     visible
        Wait For Elements State    ${TXN_DETAIL_MODAL} >> text=Debit Account Name     visible
        Wait For Elements State    ${TXN_DETAIL_MODAL} >> text=Credit Account Name    visible
        Wait For Elements State    ${TXN_DETAIL_MODAL} >> text=Debit Account Number   visible
        Wait For Elements State    ${TXN_DETAIL_MODAL} >> text=Credit Account Number  visible
        Wait For Elements State    ${TXN_DETAIL_MODAL} >> text=Created on             visible
        Wait For Elements State    ${TXN_DETAIL_MODAL} >> text=Updated on             visible
        Click    ${TXN_DETAIL_BACK_BTN}
        Wait For Elements State    ${TXN_DETAIL_MODAL}              hidden
    END

Filter Txn Results Should Contain Only Status
    [Documentation]    Verifies that all visible transaction rows match the expected status.
    ...                If data exists, also clicks the first row's Eye icon and verifies
    ...                the detail modal contains all required field labels, then closes it.
    ...                If no data, verifies the "No Data" message.
    [Arguments]        ${expected_status}
    Wait For Load Spinner To Disappear
    Sleep    1s    # Wait for filter to apply
    ${no_data_visible}=    Run Keyword And Return Status
    ...                    Wait For Elements State    css=.ant-empty-description    visible    timeout=3s
    IF    ${no_data_visible}
        Log    No data found for status: ${expected_status}
    ELSE
        ${total_rows}=      Get Element Count    css=[data-testid="table-customers-account-transactions"] tbody tr:not([aria-hidden="true"]):not(:empty)
        ${matching_rows}=   Get Element Count    css=[data-testid="table-customers-account-transactions"] tbody tr:not([aria-hidden="true"]):has-text("${expected_status}")
        Should Be Equal    ${total_rows}    ${matching_rows}
        ...    Expected all ${total_rows} rows to have status "${expected_status}", but only ${matching_rows} matched
        Log    All ${total_rows} rows contain status "${expected_status}"
        # Wait for spinner and open first row detail modal
        Wait For Load Spinner To Disappear
        Click    ${VIEW_TXN_BTN} >> nth=0
        Wait For Elements State    ${TXN_DETAIL_MODAL}              visible
        Wait For Elements State    ${TXN_DETAIL_MODAL} >> text=Transaction ID         visible
        Wait For Elements State    ${TXN_DETAIL_MODAL} >> text=Transaction Type       visible
        Wait For Elements State    ${TXN_DETAIL_MODAL} >> text=Transaction Amount     visible
        Wait For Elements State    ${TXN_DETAIL_MODAL} >> text=Service Fee            visible
        Wait For Elements State    ${TXN_DETAIL_MODAL} >> text=Remarks                visible
        Wait For Elements State    ${TXN_DETAIL_MODAL} >> text=Transaction Status     visible
        Wait For Elements State    ${TXN_DETAIL_MODAL} >> text=Debit Account Name     visible
        Wait For Elements State    ${TXN_DETAIL_MODAL} >> text=Credit Account Name    visible
        Wait For Elements State    ${TXN_DETAIL_MODAL} >> text=Debit Account Number   visible
        Wait For Elements State    ${TXN_DETAIL_MODAL} >> text=Credit Account Number  visible
        Wait For Elements State    ${TXN_DETAIL_MODAL} >> text=Created on             visible
        Wait For Elements State    ${TXN_DETAIL_MODAL} >> text=Updated on             visible
        Click    ${TXN_DETAIL_BACK_BTN}
        Wait For Elements State    ${TXN_DETAIL_MODAL}              hidden
    END

Close Modal If Open
    [Documentation]    Closes any open modal dialog to prevent blocking subsequent tests.
    ...                Uses Escape key as primary method for reliability.
    ${modal_open}=    Run Keyword And Return Status
    ...               Wait For Elements State    css=.ant-modal-wrap:not([style*="display: none"])    visible    timeout=1s
    IF    ${modal_open}
        Keyboard Key    press    Escape
        Sleep    0.5s
        # Verify modal is closed, try clicking close button if Escape didn't work
        ${still_open}=    Run Keyword And Return Status
        ...               Wait For Elements State    css=.ant-modal-wrap:not([style*="display: none"])    visible    timeout=1s
        IF    ${still_open}
            Click    css=.ant-modal-close
        END
    END
