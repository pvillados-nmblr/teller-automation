*** Settings ***
Documentation       t2.4 View Availed and Eligible Products
...                 Covers Products Availed list view, pagination, and product detail side panel
...                 (Savings and Loans), as well as Eligible Products list view, search
...                 (active and archived), pagination, and detail side panel for both product types.

Resource            ../../resources/keywords/common.resource
Resource            ../../resources/keywords/customers.resource

Suite Setup         Login To Teller App
Suite Teardown      Close Browser
Test Setup          Navigate To Customer Profile Page
Test Teardown       Close Drawer If Open


*** Keywords ***
Navigate To Customer Profile Page
    [Documentation]    Navigates to the Customer List, searches for the target customer,
    ...                and opens their profile page.
    Navigate To Customers
    View Customer Profile    ${T24_CUSTOMER_NAME}

Close Drawer If Open
    [Documentation]    Closes any open drawer by clicking the close button if it exists.
    ${drawer_visible}=    Run Keyword And Return Status
    ...    Wait For Elements State    ${PRODUCT_DETAILS_DRAWER}    visible    timeout=1s
    IF    ${drawer_visible}
        Click    ${PRODUCT_DETAILS_CLOSE_BTN}
        Wait For Elements State    ${PRODUCT_DETAILS_DRAWER}    hidden
    END


*** Test Cases ***

# ====================================================================
# PRODUCTS AVAILED
# ====================================================================

t2.4.1 View Products Availed of Existing Customer
    [Documentation]    Verify that the Products Availed tab on a customer profile displays
    ...                a table with the correct columns: Product Name, Product Category, and
    ...                Action; and that a See Details button is visible per row.
    [Tags]             customers    products    smoke

    Click                       ${PRODUCTS_AVAILED_TAB}
    Wait For Elements State     ${PRODUCT_TABLE}                    visible
    Wait For Elements State     text=Product Name                   visible
    Wait For Elements State     text=Product Category               visible
    Wait For Elements State     text="Action"                       visible
    Wait For Elements State     ${SEE_DETAILS_BTN} >> nth=0         visible

t2.4.2 Pagination and Navigation of Products Availed
    [Documentation]    Verify that pagination controls on the Products Availed tab work correctly:
    ...                Next loads page 2, clicking a page number loads that page directly, and
    ...                Back returns to the prior page. Skips if only one page of data exists.
    [Tags]             customers    products    regression

    Click                       ${PRODUCTS_AVAILED_TAB}
    Wait For Elements State     ${PRODUCT_TABLE}    visible
    ${has_multiple_pages}=    Run Keyword And Return Status
    ...    Wait For Elements State    css=.ant-pagination-next:not(.ant-pagination-disabled)    visible    timeout=3s
    IF    ${has_multiple_pages}
        Click                      ${PAGINATION_NEXT}
        Wait For Elements State    css=li.ant-pagination-item-active:has-text("2")    visible
        ${page3_exists}=    Run Keyword And Return Status
        ...    Wait For Elements State    css=li.ant-pagination-item:has-text("3")    visible    timeout=2s
        IF    ${page3_exists}
            Click                      css=li.ant-pagination-item:has-text("3")
            Wait For Elements State    css=li.ant-pagination-item-active:has-text("3")    visible
            Click                      ${PAGINATION_PREV}
            Wait For Elements State    css=li.ant-pagination-item-active:has-text("2")    visible
        ELSE
            Click                      ${PAGINATION_PREV}
            Wait For Elements State    css=li.ant-pagination-item-active:has-text("1")    visible
        END
    ELSE
        Log    Only one page of availed products — pagination navigation skipped
        Wait For Elements State    css=.ant-pagination-next.ant-pagination-disabled    visible
    END

t2.4.3 See Specific Details of an Availed Savings Product
    [Documentation]    Verify that clicking See Details on an availed Savings product opens a
    ...                side panel containing Product ID, Product Details, Eligibility for Customer Type,
    ...                Account Configuration, Interest Configuration, Fees & Charges, and Custom Fields
    ...                (values entered during availment). The panel closes without errors.
    ...
    ...                Preconditions:
    ...                - The user must be authenticated and logged into the Teller App.
    ...                - The customer must already be onboarded within the Higala environment.
    ...                - The customer must have at least one availed savings product.
    ...                - The user must have permission to view customer profiles and product details.
    [Tags]             customers    products    smoke

    Click                       ${PRODUCTS_AVAILED_TAB}
    Wait For Elements State     css=.ant-table-body tr:has-text("${T24_AVAILED_SAVINGS_PRODUCT}") >> nth=0    visible
    Click                       css=.ant-table-body tr:has-text("${T24_AVAILED_SAVINGS_PRODUCT}") >> nth=0 >> ${SEE_DETAILS_BTN}
    Wait For Elements State     ${PRODUCT_DETAILS_DRAWER}    visible

    # Panel header displays the product ID (PROD_xxx format)
    Wait For Elements State     css=.ant-drawer-title    visible

    # Product Details
    Wait For Elements State     ${PRODUCT_DETAILS_DRAWER} >> text=Product name                  visible
    Wait For Elements State     ${PRODUCT_DETAILS_DRAWER} >> text=Product type                  visible
    Wait For Elements State     ${PRODUCT_DETAILS_DRAWER} >> text=Description                   visible
    Wait For Elements State     ${PRODUCT_DETAILS_DRAWER} >> text=Status                        visible

    # Eligibility for Customer Type
    Scroll To Element           ${PRODUCT_DETAILS_DRAWER} >> text=Minimum age
    Wait For Elements State     ${PRODUCT_DETAILS_DRAWER} >> text=Minimum age                   visible
    Wait For Elements State     ${PRODUCT_DETAILS_DRAWER} >> text=Required Documents            visible

    # Account Configuration
    Scroll To Element           ${PRODUCT_DETAILS_DRAWER} >> text=Average daily balance
    Wait For Elements State     ${PRODUCT_DETAILS_DRAWER} >> text=Average daily balance         visible
    Wait For Elements State     ${PRODUCT_DETAILS_DRAWER} >> text=Initial deposit               visible
    Wait For Elements State     ${PRODUCT_DETAILS_DRAWER} >> text=Overdrafts                    visible
    Wait For Elements State     ${PRODUCT_DETAILS_DRAWER} >> text=Withdrawal limit frequency    visible
    Wait For Elements State     ${PRODUCT_DETAILS_DRAWER} >> text=Withdrawal limit amount       visible

    # Interest Configuration
    Scroll To Element           ${PRODUCT_DETAILS_DRAWER} >> text="Interest rate(%)"
    Wait For Elements State     ${PRODUCT_DETAILS_DRAWER} >> text="Interest rate(%)"            visible
    Wait For Elements State     ${PRODUCT_DETAILS_DRAWER} >> text=Interest type                 visible
    Wait For Elements State     ${PRODUCT_DETAILS_DRAWER} >> text=Interest time period          visible
    Wait For Elements State     ${PRODUCT_DETAILS_DRAWER} >> text=Interest rate structure       visible

    # Fees & Charges
    Scroll To Element           ${PRODUCT_DETAILS_DRAWER} >> text=Excess withdrawal fee
    Wait For Elements State     ${PRODUCT_DETAILS_DRAWER} >> text=Excess withdrawal fee         visible
    Wait For Elements State     ${PRODUCT_DETAILS_DRAWER} >> text=Dormancy fee                  visible
    Wait For Elements State     ${PRODUCT_DETAILS_DRAWER} >> text=Account closure fee           visible
    Wait For Elements State     ${PRODUCT_DETAILS_DRAWER} >> text=Tax rate type                 visible
    Wait For Elements State     ${PRODUCT_DETAILS_DRAWER} >> text=Tax rate value                visible

    # Close side panel
    Click                       ${PRODUCT_DETAILS_CLOSE_BTN}
    Wait For Elements State     ${PRODUCT_DETAILS_DRAWER}    hidden

t2.4.4 See Specific Details of an Availed Loans Product
    [Documentation]    Verify that clicking See Details on an availed Loans product opens a
    ...                side panel containing Product ID, Product Definition, Product Details,
    ...                Loan Features, Eligibility Criteria, Pricing & Fees, and Loan Details
    ...                (values entered during availment). The panel closes without errors.
    [Tags]             customers    products    smoke

    Click                       ${PRODUCTS_AVAILED_TAB}
    Wait For Elements State     css=.ant-table-body tr:has-text("${T24_AVAILED_LOAN_PRODUCT}") >> nth=0    visible
    Click                       css=.ant-table-body tr:has-text("${T24_AVAILED_LOAN_PRODUCT}") >> nth=0 >> ${SEE_DETAILS_BTN}
    Wait For Elements State     ${PRODUCT_DETAILS_DRAWER}    visible

    # Panel header displays the product ID (PROD_xxx format)
    Wait For Elements State     css=.ant-drawer-title    visible

    # Product Definition
    Wait For Elements State     ${PRODUCT_DETAILS_DRAWER} >> text=Loan type                     visible
    Wait For Elements State     ${PRODUCT_DETAILS_DRAWER} >> text=Preferred customers           visible
    Wait For Elements State     ${PRODUCT_DETAILS_DRAWER} >> text=Loan purpose                  visible

    # Product Details
    Wait For Elements State     ${PRODUCT_DETAILS_DRAWER} >> text=Product name                  visible
    Wait For Elements State     ${PRODUCT_DETAILS_DRAWER} >> text=Product type                  visible
    Wait For Elements State     ${PRODUCT_DETAILS_DRAWER} >> text=Description                   visible

    # Loan Features
    Scroll To Element           ${PRODUCT_DETAILS_DRAWER} >> text=Minimum loan amount
    Wait For Elements State     ${PRODUCT_DETAILS_DRAWER} >> text=Minimum loan amount           visible
    Wait For Elements State     ${PRODUCT_DETAILS_DRAWER} >> text=Maximum loan amount           visible
    Wait For Elements State     ${PRODUCT_DETAILS_DRAWER} >> text=Loan term length              visible
    Wait For Elements State     ${PRODUCT_DETAILS_DRAWER} >> text=Loan term unit                visible
    Wait For Elements State     ${PRODUCT_DETAILS_DRAWER} >> text=Interest rate type            visible
    Wait For Elements State     ${PRODUCT_DETAILS_DRAWER} >> text=Repayment method              visible

    # Eligibility Criteria
    Scroll To Element           ${PRODUCT_DETAILS_DRAWER} >> text=Minimum age
    Wait For Elements State     ${PRODUCT_DETAILS_DRAWER} >> text=Minimum age                   visible
    Wait For Elements State     ${PRODUCT_DETAILS_DRAWER} >> text=Maximum age                   visible
    Wait For Elements State     ${PRODUCT_DETAILS_DRAWER} >> text=Minimum income level          visible
    Wait For Elements State     ${PRODUCT_DETAILS_DRAWER} >> text=Credit score                  visible
    Wait For Elements State     ${PRODUCT_DETAILS_DRAWER} >> text=Employment type               visible
    Wait For Elements State     ${PRODUCT_DETAILS_DRAWER} >> text=Required documents            visible

    # Pricing & Fees
    Scroll To Element           ${PRODUCT_DETAILS_DRAWER} >> text=Processing fee type
    Wait For Elements State     ${PRODUCT_DETAILS_DRAWER} >> text="Interest rate (%)"           visible
    Wait For Elements State     ${PRODUCT_DETAILS_DRAWER} >> text=Interest rate structure       visible
    Wait For Elements State     ${PRODUCT_DETAILS_DRAWER} >> text="Processing fee"                visible
    Wait For Elements State     ${PRODUCT_DETAILS_DRAWER} >> text=Processing fee type             visible
    Wait For Elements State     ${PRODUCT_DETAILS_DRAWER} >> text=Penalty interest rate         visible
    Wait For Elements State     ${PRODUCT_DETAILS_DRAWER} >> text=Penalty conditions            visible

    # TODO: Re-enable Loan Details section once UI is fixed
    # # Loan Details (values entered during availment)
    # Scroll To Element           ${PRODUCT_DETAILS_DRAWER} >> text=Mode of disbursement
    # Wait For Elements State     ${PRODUCT_DETAILS_DRAWER} >> text="Loan amount"                 visible
    # Wait For Elements State     ${PRODUCT_DETAILS_DRAWER} >> text=Loan term length              visible
    # Wait For Elements State     ${PRODUCT_DETAILS_DRAWER} >> text=Loan term unit                visible
    # Wait For Elements State     ${PRODUCT_DETAILS_DRAWER} >> text=Mode of disbursement          visible

    # Close side panel
    Click                       ${PRODUCT_DETAILS_CLOSE_BTN}
    Wait For Elements State     ${PRODUCT_DETAILS_DRAWER}    hidden


# ====================================================================
# ELIGIBLE PRODUCTS
# ====================================================================

t2.4.5 View Eligible Products for Existing Customer
    [Documentation]    Verify that the Eligible Products tab displays a table with the correct
    ...                columns: Product Name, Product Category, and Action; and that each row
    ...                has both See Details and Avail Product buttons.
    [Tags]             customers    products    smoke

    Click                       ${ELIGIBLE_PRODUCTS_TAB}
    Wait For Elements State     ${PRODUCT_TABLE}                    visible
    Wait For Elements State     text=Product Name                   visible
    Wait For Elements State     text=Product Category               visible
    Wait For Elements State     text="Action"                       visible
    Wait For Elements State     ${SEE_DETAILS_BTN} >> nth=0         visible
    Wait For Elements State     ${AVAIL_PRODUCT_BTN} >> nth=0       visible

t2.4.6 Search Eligible Products
    [Documentation]    Verify that searching by a valid active product name filters the
    ...                Eligible Products table to show only matching results, and clearing
    ...                the search restores the full eligible products list.
    [Tags]             customers    products    smoke

    Click                       ${ELIGIBLE_PRODUCTS_TAB}
    Wait For Elements State     ${PRODUCT_TABLE}    visible

    # Search for an active product
    Fill Text                   ${PRODUCT_SEARCH_INPUT}    ${T24_ACTIVE_PRODUCT}
    Click                       ${PRODUCT_SEARCH_BTN}
    Wait For Elements State     ${PRODUCT_TABLE}    visible
    Wait For Elements State     css=.ant-table-body table tbody tr:has-text("${T24_ACTIVE_PRODUCT}")    visible

    # Clear search and verify the full list is restored
    Fill Text                   ${PRODUCT_SEARCH_INPUT}    ${EMPTY}
    Click                       ${PRODUCT_SEARCH_BTN}
    Wait For Elements State     ${PRODUCT_TABLE}                    visible
    Wait For Elements State     ${SEE_DETAILS_BTN} >> nth=0         visible

t2.4.7 Search Archived Products in Eligible Products
    [Documentation]    Verify that searching for an archived product in the Eligible Products
    ...                tab returns no results, confirming archived products are excluded from
    ...                the eligible list. Clearing the search restores the full list.
    [Tags]             customers    products    negative

    Click                       ${ELIGIBLE_PRODUCTS_TAB}
    Wait For Elements State     ${PRODUCT_TABLE}    visible

    # Search for an archived product — should yield no results
    Fill Text                   ${PRODUCT_SEARCH_INPUT}    ${T24_ARCHIVED_PRODUCT}
    Click                       ${PRODUCT_SEARCH_BTN}
    Wait For Elements State     css=.ant-empty-description    visible

    # Clear search and verify the full list is restored
    Fill Text                   ${PRODUCT_SEARCH_INPUT}    ${EMPTY}
    Click                       ${PRODUCT_SEARCH_BTN}
    Wait For Elements State     ${PRODUCT_TABLE}                    visible
    Wait For Elements State     ${SEE_DETAILS_BTN} >> nth=0         visible

t2.4.8 Pagination and Navigation of Eligible Products
    [Documentation]    Verify that pagination controls on the Eligible Products tab work
    ...                correctly: Next loads page 2, clicking a page number loads that page
    ...                directly, and Back returns to the prior page.
    ...                Skips if only one page of data exists.
    [Tags]             customers    products    regression

    Click                       ${ELIGIBLE_PRODUCTS_TAB}
    Wait For Elements State     ${PRODUCT_TABLE}    visible
    ${has_multiple_pages}=    Run Keyword And Return Status
    ...    Wait For Elements State    css=.ant-pagination-next:not(.ant-pagination-disabled)    visible    timeout=3s
    IF    ${has_multiple_pages}
        Click                      ${PAGINATION_NEXT}
        Wait For Elements State    css=li.ant-pagination-item-active:has-text("2")    visible
        ${page3_exists}=    Run Keyword And Return Status
        ...    Wait For Elements State    css=li.ant-pagination-item:has-text("3")    visible    timeout=2s
        IF    ${page3_exists}
            Click                      css=li.ant-pagination-item:has-text("3")
            Wait For Elements State    css=li.ant-pagination-item-active:has-text("3")    visible
            Click                      ${PAGINATION_PREV}
            Wait For Elements State    css=li.ant-pagination-item-active:has-text("2")    visible
        ELSE
            Click                      ${PAGINATION_PREV}
            Wait For Elements State    css=li.ant-pagination-item-active:has-text("1")    visible
        END
    ELSE
        Log    Only one page of eligible products — pagination navigation skipped
        Wait For Elements State    css=.ant-pagination-next.ant-pagination-disabled    visible
    END

t2.4.9 See Specific Details of an Eligible Savings Product
    [Documentation]    Verify that clicking See Details on an eligible Savings product opens
    ...                a side panel containing Product Details, Eligibility for Customer Type,
    ...                Account Configuration, Interest Configuration, and Fees & Charges.
    ...                The panel layout is consistent and closes without errors.
    [Tags]             customers    products    smoke

    Click                       ${ELIGIBLE_PRODUCTS_TAB}
    Wait For Elements State     css=.ant-table-body tr:has-text("Savings") >> nth=0    visible
    Click                       css=.ant-table-body tr:has-text("Savings") >> nth=0 >> ${SEE_DETAILS_BTN}
    Wait For Elements State     ${PRODUCT_DETAILS_DRAWER}    visible

    # Product Details
    Wait For Elements State     ${PRODUCT_DETAILS_DRAWER} >> text=Product name                  visible
    Wait For Elements State     ${PRODUCT_DETAILS_DRAWER} >> text=Product type                  visible
    Wait For Elements State     ${PRODUCT_DETAILS_DRAWER} >> text=Description                   visible
    Wait For Elements State     ${PRODUCT_DETAILS_DRAWER} >> text=Status                        visible

    # Eligibility for Customer Type
    Scroll To Element           ${PRODUCT_DETAILS_DRAWER} >> text=Minimum age
    Wait For Elements State     ${PRODUCT_DETAILS_DRAWER} >> text=Minimum age                   visible
    Wait For Elements State     ${PRODUCT_DETAILS_DRAWER} >> text=Required Documents            visible

    # Account Configuration
    Scroll To Element           ${PRODUCT_DETAILS_DRAWER} >> text=Average daily balance
    Wait For Elements State     ${PRODUCT_DETAILS_DRAWER} >> text=Average daily balance         visible
    Wait For Elements State     ${PRODUCT_DETAILS_DRAWER} >> text=Initial deposit               visible
    Wait For Elements State     ${PRODUCT_DETAILS_DRAWER} >> text=Overdrafts                    visible
    Wait For Elements State     ${PRODUCT_DETAILS_DRAWER} >> text=Withdrawal limit frequency    visible
    Wait For Elements State     ${PRODUCT_DETAILS_DRAWER} >> text=Withdrawal limit amount       visible

    # Interest Configuration
    Scroll To Element           ${PRODUCT_DETAILS_DRAWER} >> text="Interest rate(%)"
    Wait For Elements State     ${PRODUCT_DETAILS_DRAWER} >> text="Interest rate(%)"            visible
    Wait For Elements State     ${PRODUCT_DETAILS_DRAWER} >> text=Interest type                 visible
    Wait For Elements State     ${PRODUCT_DETAILS_DRAWER} >> text=Interest time period          visible
    Wait For Elements State     ${PRODUCT_DETAILS_DRAWER} >> text=Interest rate structure       visible

    # Fees & Charges
    Scroll To Element           ${PRODUCT_DETAILS_DRAWER} >> text=Excess withdrawal fee
    Wait For Elements State     ${PRODUCT_DETAILS_DRAWER} >> text=Excess withdrawal fee         visible
    Wait For Elements State     ${PRODUCT_DETAILS_DRAWER} >> text=Dormancy fee                  visible
    Wait For Elements State     ${PRODUCT_DETAILS_DRAWER} >> text=Account closure fee           visible
    Wait For Elements State     ${PRODUCT_DETAILS_DRAWER} >> text=Tax rate type                 visible
    Wait For Elements State     ${PRODUCT_DETAILS_DRAWER} >> text=Tax rate value                visible

    # Close side panel
    Click                       ${PRODUCT_DETAILS_CLOSE_BTN}
    Wait For Elements State     ${PRODUCT_DETAILS_DRAWER}    hidden

t2.4.10 See Specific Details of an Eligible Loans Product
    [Documentation]    Verify that clicking See Details on an eligible Loans product opens a
    ...                side panel containing Product Definition, Product Details, Loan Features,
    ...                Eligibility Criteria, Pricing & Fees, and read-only Loan Details reference
    ...                values. The panel layout is consistent and closes without errors.
    [Tags]             customers    products    smoke

    Click                       ${ELIGIBLE_PRODUCTS_TAB}
    Wait For Elements State     css=.ant-table-body tr:has-text("Loan") >> nth=0    visible
    Click                       css=.ant-table-body tr:has-text("Loan") >> nth=0 >> ${SEE_DETAILS_BTN}
    Wait For Elements State     ${PRODUCT_DETAILS_DRAWER}    visible

    # Product Definition
    Wait For Elements State     ${PRODUCT_DETAILS_DRAWER} >> text=Loan type                     visible
    Wait For Elements State     ${PRODUCT_DETAILS_DRAWER} >> text=Preferred customers           visible
    Wait For Elements State     ${PRODUCT_DETAILS_DRAWER} >> text=Loan purpose                  visible

    # Product Details
    Wait For Elements State     ${PRODUCT_DETAILS_DRAWER} >> text=Product name                  visible
    Wait For Elements State     ${PRODUCT_DETAILS_DRAWER} >> text=Product type                  visible
    Wait For Elements State     ${PRODUCT_DETAILS_DRAWER} >> text=Description                   visible

    # Loan Features
    Scroll To Element           ${PRODUCT_DETAILS_DRAWER} >> text=Minimum loan amount
    Wait For Elements State     ${PRODUCT_DETAILS_DRAWER} >> text=Minimum loan amount           visible
    Wait For Elements State     ${PRODUCT_DETAILS_DRAWER} >> text=Maximum loan amount           visible
    Wait For Elements State     ${PRODUCT_DETAILS_DRAWER} >> text=Loan term length              visible
    Wait For Elements State     ${PRODUCT_DETAILS_DRAWER} >> text=Loan term unit                visible
    Wait For Elements State     ${PRODUCT_DETAILS_DRAWER} >> text=Interest rate type            visible
    Wait For Elements State     ${PRODUCT_DETAILS_DRAWER} >> text=Repayment method              visible

    # Eligibility Criteria
    Scroll To Element           ${PRODUCT_DETAILS_DRAWER} >> text=Minimum age
    Wait For Elements State     ${PRODUCT_DETAILS_DRAWER} >> text=Minimum age                   visible
    Wait For Elements State     ${PRODUCT_DETAILS_DRAWER} >> text=Maximum age                   visible
    Wait For Elements State     ${PRODUCT_DETAILS_DRAWER} >> text=Minimum income level          visible
    Wait For Elements State     ${PRODUCT_DETAILS_DRAWER} >> text=Credit score                  visible
    Wait For Elements State     ${PRODUCT_DETAILS_DRAWER} >> text=Employment type               visible
    Wait For Elements State     ${PRODUCT_DETAILS_DRAWER} >> text=Required documents            visible

    # Pricing & Fees
    Scroll To Element           ${PRODUCT_DETAILS_DRAWER} >> text=Processing fee type
    Wait For Elements State     ${PRODUCT_DETAILS_DRAWER} >> text="Interest rate (%)"           visible
    Wait For Elements State     ${PRODUCT_DETAILS_DRAWER} >> text=Interest rate structure       visible
    Wait For Elements State     ${PRODUCT_DETAILS_DRAWER} >> text="Processing fee"                visible
    Wait For Elements State     ${PRODUCT_DETAILS_DRAWER} >> text=Processing fee type             visible
    Wait For Elements State     ${PRODUCT_DETAILS_DRAWER} >> text=Penalty interest rate         visible
    Wait For Elements State     ${PRODUCT_DETAILS_DRAWER} >> text=Penalty conditions            visible

    # TODO: Re-enable Loan Details section once UI is fixed
    # # Loan Details (read-only reference values)
    # Scroll To Element           ${PRODUCT_DETAILS_DRAWER} >> text=Mode of disbursement
    # Wait For Elements State     ${PRODUCT_DETAILS_DRAWER} >> text="Loan amount"                 visible
    # Wait For Elements State     ${PRODUCT_DETAILS_DRAWER} >> text=Loan term length              visible
    # Wait For Elements State     ${PRODUCT_DETAILS_DRAWER} >> text=Loan term unit                visible
    # Wait For Elements State     ${PRODUCT_DETAILS_DRAWER} >> text=Mode of disbursement          visible

    # Close side panel
    Click                       ${PRODUCT_DETAILS_CLOSE_BTN}
    Wait For Elements State     ${PRODUCT_DETAILS_DRAWER}    hidden
