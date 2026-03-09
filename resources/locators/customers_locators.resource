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
${VIEW_ACCOUNT_TRANSACTIONS_LINK}     css=[data-testid="btn-customers-accounts-view-transactions"]

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
${FILTER_OPTION_FROZEN}             css=[data-menu-id$="-frozen"]
${FILTER_OPTION_OVERDRAWN}          css=[data-menu-id$="-overdrawn"]

# Customer Accounts Page — Table
${ACCOUNT_TABLE}                    css=[data-testid="table-customers-accounts"]
${ACCOUNT_TABLE_ROWS}               css=[data-testid="table-customers-accounts"] tbody tr

# Account Status Filter — AntD column filter dropdown (accounts page)
${ACCOUNT_STATUS_FILTER}            css=th:has-text("Account Status") span.ant-table-filter-trigger

# Breadcrumb Navigation
${CUSTOMERS_BREADCRUMB_LINK}        css=a[href$="/dashboard/customers"]
${VIEW_ACCOUNTS_BREADCRUMB_LINK}    css=a:has-text("View Accounts")

# ============================================================
# CUSTOMER ACCOUNT TRANSACTIONS PAGE
# ============================================================

# Search
${TRANSACTION_SEARCH_FIELD}         css=input[placeholder="Search transactions..."]
${TRANSACTION_SEARCH_BUTTON}        text=Search

# Transaction Table
${TRANSACTION_TABLE}                css=[data-testid="table-customers-account-transactions"]
${TRANSACTION_TABLE_ROWS}           css=[data-testid="table-customers-account-transactions"] tbody tr

# Transaction Action Buttons
${VIEW_TXN_BTN}                     css=button:has([data-icon="eye"])
${DOWNLOAD_TXN_BTN}                 css=button:has([data-icon="download"])

# Transaction Type Filter — AntD column filter dropdown
${TXN_TYPE_FILTER}                  css=th:has-text("Transaction Type") span.ant-table-filter-trigger
${TXN_TYPE_SEND_MONEY}              css=[data-menu-id$="-fund_transfer_external"]
${TXN_TYPE_CASH_IN}                 css=[data-menu-id$="-cash_in_external"]
${TXN_TYPE_FUND_TRANSFER}           css=[data-menu-id$="-fund_transfer_internal"]

# Date & Time Column Filter — AntD custom date range filter
${DATE_TIME_FILTER}                 css=th:has-text("Date & Time") span.ant-table-filter-trigger
${DATE_START_INPUT}                 css=input[placeholder="Start date"]
${DATE_END_INPUT}                   css=input[placeholder="End date"]
${DATE_FILTER_SEARCH_BTN}           css=.ant-table-filter-dropdown button:has-text("Search")
${DATE_FILTER_RESET_BTN}            css=.ant-table-filter-dropdown button:has-text("Reset")

# Transaction Status Filter — AntD column filter dropdown
${TXN_STATUS_FILTER}                css=th:has-text("Status") span.ant-table-filter-trigger
${TXN_STATUS_PENDING}               css=[data-menu-id$="-pending"]
${TXN_STATUS_SUCCESS}               css=[data-menu-id$="-success"]
${TXN_STATUS_FAILED}                css=[data-menu-id$="-failed"]

# Transaction Detail Modal
${TXN_DETAIL_MODAL}                 css=[data-testid="modal-customers-transaction-details"] .ant-modal-content
${TXN_DETAIL_CLOSE_BTN}             css=.ant-modal-close
${TXN_DETAIL_BACK_BTN}              css=[data-testid="modal-customers-transaction-details-btn-back"]