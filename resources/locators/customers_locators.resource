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
${CUSTOMER_TABLE}                     css=[data-testid="table-customers"]
${CUSTOMER_TABLE_ROWS}                css=[data-testid="table-customers"] tbody tr

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

# Customer Status Filter — AntD column filter dropdown
# No data-testid — AntD class/attribute selectors
${CUSTOMER_STATUS_FILTER}           css=span.ant-table-filter-trigger
${FILTER_OPTION_ACTIVE}             css=[data-menu-id$="-active"]
${FILTER_OPTION_INACTIVE}           css=[data-menu-id$="-inactive"]
${FILTER_OPTION_DORMANT}            css=[data-menu-id$="-dormant"]
${FILTER_OPTION_CLOSED}             css=[data-menu-id$="-closed"]
${FILTER_OPTION_BLOCKED}            css=[data-menu-id$="-blocked"]
${FILTER_OPTION_SUSPENDED}          css=[data-menu-id$="-suspended"]
${FILTER_APPLY_BTN}                 css=button.ant-btn-primary.ant-btn-sm:has-text("OK")
${FILTER_RESET_BTN}                 css=.ant-table-filter-dropdown-btns .ant-btn-link