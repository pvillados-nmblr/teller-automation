*** Settings ***
Library     Browser
Resource    common.resource
Resource    ../locators/customers_locators.resource


*** Keywords ***
Navigate To Customers
    [Documentation]    Navigates to the Customers module via the sidebar
    Click                      ${CUSTOMERS_MENU}
    Wait For Elements State    ${CUSTOMER_SEARCH_FIELD}    visible
    Get Url                    contains    /customers

View Customer List
    [Documentation]    Verifies the customer list page is loaded and visible
    Wait For Elements State    ${CUSTOMER_TABLE}    visible

Search For Customer
    [Documentation]    Searches for a customer by name or Customer ID
    [Arguments]        ${search_value}
    Fill Text          ${CUSTOMER_SEARCH_FIELD}    ${search_value}
    Click              ${CUSTOMER_SEARCH_BUTTON}
    Wait For Elements State    ${CUSTOMER_TABLE}    visible

View Customer Profile
    [Documentation]    Clicks View Profile for a specific customer row matching the given name
    [Arguments]        ${customer_name}
    Click              css=tr:has-text("${customer_name}") >> ${VIEW_PROFILE_LINK}
    Wait For Elements State    text=Banking Details    visible

View Customer Accounts
    [Documentation]    Clicks View Accounts for a specific customer row matching the given name
    [Arguments]        ${customer_name}
    Click              css=tr:has-text("${customer_name}") >> ${VIEW_ACCOUNTS_LINK}
    Wait For Elements State    ${ACCOUNT_SEARCH_FIELD}    visible

View Customer Account Transactions
    [Documentation]    Clicks View Account Transactions for a specific account row
    [Arguments]        ${account_number}
    Click              css=tr:has-text("${account_number}") >> ${VIEW_ACCOUNT_TRANSACTIONS_LINK}
    Wait For Elements State    css=table    visible

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
