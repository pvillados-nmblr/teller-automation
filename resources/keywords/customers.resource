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
    [Documentation]    Verifies that all visible rows in the table match the expected status,
    ...                or that a "No Data" message is shown if no matching records exist.
    [Arguments]        ${expected_status}
    ${no_data_visible}=    Run Keyword And Return Status
    ...                    Wait For Elements State    ${NO_DATA_MESSAGE}    visible    timeout=5s
    IF    not ${no_data_visible}
        ${rows}=           Get Element Count    ${CUSTOMER_TABLE_ROWS}
        FOR    ${i}    IN RANGE    1    ${rows} + 1
            Get Text    css=table tbody tr:nth-child(${i}) td:has-text("${expected_status}")
            ...         contains    ${expected_status}
        END
    END
