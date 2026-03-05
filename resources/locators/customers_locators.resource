*** Variables ***
# ============================================================
# Customers Module Locators
# ============================================================

# Navigation - Sidebar
${CUSTOMERS_MENU}                     css=[data-testid="nav-sidebar-customers"]


# Customer List Page
${CUSTOMER_SEARCH_FIELD}              css=[data-testid="search-customers-input"]
${CUSTOMER_SEARCH_BUTTON}             css=[data-testid="search-customers-btn"]
${CUSTOMER_SEARCH_CLEAR}              css=span.ant-input-clear-icon

# Customer List Table
${CUSTOMER_TABLE}                     css=table
${CUSTOMER_TABLE_ROWS}                css=table tbody tr

# Customer List Actions (per row)
${VIEW_PROFILE_LINK}        css=[data-testid="btn-customers-view-profile"]
${VIEW_ACCOUNTS_LINK}       css=[data-testid="btn-customers-view-accounts"]


# Pagination
${PAGINATION_NEXT}                    css=button.ant-pagination-item-link:has(svg[data-icon="right"])
${PAGINATION_PREV}                    css=button.ant-pagination-item-link:has(svg[data-icon="left"])
${PAGINATION_PAGE}                    css=li.ant-pagination-item a[rel="nofollow"]

# Customer Status Filter (column header filter icon)
${CUSTOMER_STATUS_FILTER}             css=th:has-text("Customer Status") svg

# Customer Accounts Page
${ACCOUNT_SEARCH_FIELD}               css=input[placeholder="Search accounts..."]
${ACCOUNT_SEARCH_BUTTON}              text=Search

# Customer Account Actions
${VIEW_ACCOUNT_TRANSACTIONS_LINK}     text=View Account Transactions

# No Data
${NO_DATA_MESSAGE}                    text=No Data
