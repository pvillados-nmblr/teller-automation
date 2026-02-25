*** Settings ***
Documentation       t2.1 View the List of Customers
...                 Covers initial load, pagination, search, status filtering,
...                 and customer profile view.

Resource            ../../resources/keywords/common.resource
Resource            ../../resources/keywords/customers.resource

Suite Setup         Login To Teller App
Suite Teardown      Close Browser


*** Variables ***
${VALID_CUSTOMER_ID}        31612a6237264aef9785c5efe8021f7e
${VALID_CUSTOMER_NAME}      Peach Villados
${NON_EXISTING_CUSTOMER}    NONEXISTENT99999


*** Test Cases ***
t2.1.1 Initial Load and View of Customer List
    [Documentation]    Verify that navigating to the Customers module displays the customer list
    ...                with all required columns and action buttons visible.
    [Tags]             customers    smoke
    Navigate To Customers
    Wait For Elements State    text=Customer ID           visible
    Wait For Elements State    text=Customer Name         visible
    Wait For Elements State    text=Date of Birth         visible
    Wait For Elements State    text=Created on            visible
    Wait For Elements State    text=Last Updated          visible
    Wait For Elements State    text=Customer Status       visible
    Wait For Elements State    text="Action"              visible
    Wait For Elements State    ${VIEW_PROFILE_LINK} >> nth=0       visible
    Wait For Elements State    ${VIEW_ACCOUNTS_LINK} >> nth=0      visible

t2.1.2 Pagination and Navigation
    [Documentation]    Verify that pagination controls work correctly:
    ...                Next loads page 2, clicking page 3 loads page 3,
    ...                and Back returns to page 2.
    [Tags]             customers    regression
    Navigate To Customers
    # Click Next arrow to go to page 2
    Click                      ${PAGINATION_NEXT}
    Wait For Elements State    css=li.ant-pagination-item-active:has-text("2")    visible
    # Click page number 3
    Click                      css=li.ant-pagination-item:has-text("3")
    Wait For Elements State    css=li.ant-pagination-item-active:has-text("3")    visible
    # Click Back arrow to go back to page 2
    Click                      ${PAGINATION_PREV}
    Wait For Elements State    css=li.ant-pagination-item-active:has-text("2")    visible

t2.1.3 Search for Valid Customer ID
    [Documentation]    Verify that searching by a valid Customer ID returns exactly one record
    ...                and all required columns are visible in the results.
    [Tags]             customers    smoke
    Navigate To Customers
    Fill Text                  ${CUSTOMER_SEARCH_FIELD}    ${VALID_CUSTOMER_ID}
    Click                      ${CUSTOMER_SEARCH_BUTTON}
    Wait For Elements State    css=table tbody tr            visible
    Get Element Count          css=table tbody tr            ==    1
    Wait For Elements State    text=Customer ID             visible
    Wait For Elements State    text=Customer Name           visible
    Wait For Elements State    text=Date of Birth           visible
    Wait For Elements State    text=Created on              visible
    Wait For Elements State    text=Last Updated            visible
    Wait For Elements State    text=Customer Status         visible
    Wait For Elements State    ${VIEW_PROFILE_LINK}         visible
    Wait For Elements State    ${VIEW_ACCOUNTS_LINK}        visible
    # Clear search and verify list reloads
    Click                      ${CUSTOMER_SEARCH_CLEAR}
    Wait For Elements State    ${CUSTOMER_SEARCH_FIELD}     visible

t2.1.4 Search for Valid Customer Name
    [Documentation]    Verify that searching by a valid Customer Name returns matching records
    ...                and all required columns are visible in the results.
    [Tags]             customers    smoke
    Navigate To Customers
    Fill Text                  ${CUSTOMER_SEARCH_FIELD}    ${VALID_CUSTOMER_NAME}
    Click                      ${CUSTOMER_SEARCH_BUTTON}
    Wait For Elements State    css=table tbody tr           visible
    Wait For Elements State    text=${VALID_CUSTOMER_NAME}  visible
    Wait For Elements State    text=Customer ID             visible
    Wait For Elements State    text=Customer Name           visible
    Wait For Elements State    text=Date of Birth           visible
    Wait For Elements State    text=Created on              visible
    Wait For Elements State    text=Last Updated            visible
    Wait For Elements State    text=Customer Status         visible
    Wait For Elements State    ${VIEW_PROFILE_LINK}         visible
    Wait For Elements State    ${VIEW_ACCOUNTS_LINK}        visible
    # Clear search and verify list reloads
    Click                      ${CUSTOMER_SEARCH_CLEAR}
    Wait For Elements State    ${CUSTOMER_SEARCH_FIELD}     visible

t2.1.5 Search for Non-Existing Customer
    [Documentation]    Verify that searching for a non-existing customer shows a "No Data" message
    ...                with an empty table and no application errors.
    [Tags]             customers    negative
    Navigate To Customers
    Fill Text                  ${CUSTOMER_SEARCH_FIELD}    ${NON_EXISTING_CUSTOMER}
    Click                      ${CUSTOMER_SEARCH_BUTTON}
    Wait For Elements State    text=No Data                visible
    Get Element Count          css=table tbody tr          ==    0

t2.1.6 Filter Customer List by Status - Active
    [Documentation]    Verify that filtering by Active status shows only Active customers.
    ...                If no Active customers exist, a "No Data" message is shown.
    [Tags]             customers    regression
    Navigate To Customers
    Click                      ${CUSTOMER_STATUS_FILTER}
    Click                      text=Active
    Wait For Elements State    css=table                   visible
    Filter Results Should Contain Only Status              Active

t2.1.7 Filter Customer List by Status - Inactive
    [Documentation]    Verify that filtering by Inactive status shows only Inactive customers.
    ...                If no Inactive customers exist, a "No Data" message is shown.
    [Tags]             customers    regression
    Navigate To Customers
    Click                      ${CUSTOMER_STATUS_FILTER}
    Click                      text=Inactive
    Wait For Elements State    css=table                   visible
    Filter Results Should Contain Only Status              Inactive

t2.1.8 Filter Customer List by Status - Dormant
    [Documentation]    Verify that filtering by Dormant status shows only Dormant customers.
    ...                If no Dormant customers exist, a "No Data" message is shown.
    [Tags]             customers    regression
    Navigate To Customers
    Click                      ${CUSTOMER_STATUS_FILTER}
    Click                      text=Dormant
    Wait For Elements State    css=table                   visible
    Filter Results Should Contain Only Status              Dormant

t2.1.9 Filter Customer List by Status - Closed
    [Documentation]    Verify that filtering by Closed status shows only Closed customers.
    ...                If no Closed customers exist, a "No Data" message is shown.
    [Tags]             customers    regression
    Navigate To Customers
    Click                      ${CUSTOMER_STATUS_FILTER}
    Click                      text=Closed
    Wait For Elements State    css=table                   visible
    Filter Results Should Contain Only Status              Closed

t2.1.10 Filter Customer List by Status - Blocked
    [Documentation]    Verify that filtering by Blocked status shows only Blocked customers.
    ...                If no Blocked customers exist, a "No Data" message is shown.
    [Tags]             customers    regression
    Navigate To Customers
    Click                      ${CUSTOMER_STATUS_FILTER}
    Click                      text=Blocked
    Wait For Elements State    css=table                   visible
    Filter Results Should Contain Only Status              Blocked

t2.1.11 Filter Customer List by Status - Suspended
    [Documentation]    Verify that filtering by Suspended status shows only Suspended customers.
    ...                If no Suspended customers exist, a "No Data" message is shown.
    [Tags]             customers    regression
    Navigate To Customers
    Click                      ${CUSTOMER_STATUS_FILTER}
    Click                      text=Suspended
    Wait For Elements State    css=table                   visible
    Filter Results Should Contain Only Status              Suspended

t2.1.12 Customer Profile View - Details Verification
    [Documentation]    Verify that clicking View Profile displays the customer's full profile
    ...                with all required section headers and fields correctly visible.
    [Tags]             customers    smoke
    Navigate To Customers
    View Customer Profile      ${VALID_CUSTOMER_NAME}
    # Verify section headers
    Wait For Elements State    text=Banking Details                  visible
    Wait For Elements State    text=Customer Details                 visible
    Wait For Elements State    text=Identification                   visible
    Wait For Elements State    text=Employment History               visible
    # Verify Banking Details fields
    Wait For Elements State    text=DFSP Institution ID              visible
    Wait For Elements State    text=Customer ID                      visible
    Wait For Elements State    text=Identity                         visible
    # Verify Customer Details fields
    Wait For Elements State    text=Email Address                    visible
    Wait For Elements State    text=Gender                           visible
    Wait For Elements State    text=Date of Birth                    visible
    Wait For Elements State    text=Nationality                      visible
    Wait For Elements State    text=Complete Address                 visible
    Wait For Elements State    text=Mobile Number                    visible
    Wait For Elements State    text=Civil Status                     visible
    Wait For Elements State    text=Country of Birth                 visible
    Wait For Elements State    text=TIN                              visible
    # Verify Identification fields
    Wait For Elements State    text=ID Type                          visible
    Wait For Elements State    text=ID Number                        visible
    Wait For Elements State    text=Expiry Date                      visible
    # Verify Employment History fields
    Wait For Elements State    text=Employer                         visible
    Wait For Elements State    text=Employer Industry                visible
    Wait For Elements State    text=Job Title                        visible
    Wait For Elements State    text=Monthly Income                   visible
    # Scroll down and verify Identity Verification Details section
    Scroll To Element          text=Identity Verification Details
    Wait For Elements State    text=Identity Verification Details    visible
    Wait For Elements State    text=Selfie                           visible
    Wait For Elements State    text=ID (Front)                       visible
    Wait For Elements State    text=ID (Back)                        visible
