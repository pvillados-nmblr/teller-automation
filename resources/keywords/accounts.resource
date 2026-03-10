*** Settings ***
Library     Browser
Resource    common.resource
Resource    ../locators/accounts_locators.resource


*** Keywords ***
Navigate To Accounts
    [Documentation]    Navigates to the Accounts module via the sidebar and ensures clean state
    Click                      ${ACCOUNTS_MENU}
    Wait For Elements State    ${ACCOUNTS_SEARCH_FIELD}    visible
    Get Url                    contains    /accounts
    Reload
    Wait For Elements State    ${ACCOUNTS_SEARCH_FIELD}    visible

Wait For Load Spinner To Disappear
    [Documentation]    Waits for any loading spinner to disappear before proceeding
    ${spinner_visible}=    Run Keyword And Return Status
    ...                    Wait For Elements State    css=.ant-spin-spinning    visible    timeout=2s
    IF    ${spinner_visible}
        Wait For Elements State    css=.ant-spin-spinning    hidden    timeout=30s
    END

Filter Accounts Results Should Contain Only Status
    [Documentation]    Verifies that all visible rows in the accounts table match the expected status,
    ...                or that a "No Data" message is shown if no matching records exist.
    ...                Iterates through all pagination pages to verify each page.
    [Arguments]        ${expected_status}
    Sleep    1s    # Wait for filter to apply
    ${no_data_visible}=    Run Keyword And Return Status
    ...                    Wait For Elements State    ${NO_DATA_MESSAGE}    visible    timeout=3s
    IF    ${no_data_visible}
        Log    No data found for status: ${expected_status}
    ELSE
        ${page}=    Set Variable    1
        WHILE    ${page} <= 100    # Safety limit to prevent infinite loop
            ${total_rows}=      Get Element Count    css=.ant-table-body table tbody tr:not([aria-hidden="true"]):not(:empty)
            ${matching_rows}=   Get Element Count    css=.ant-table-body table tbody tr:not([aria-hidden="true"]):has-text("${expected_status}")
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
