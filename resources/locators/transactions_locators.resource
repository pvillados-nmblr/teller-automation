*** Variables ***
# ============================================================
# Transactions Module Locators
# ============================================================

# Navigation - Sidebar
# ${TRANSACTIONS_MENU}                css=[data-testid="nav-sidebar-transactions"]    # TODO: restore when data-testid is available
${TRANSACTIONS_MENU}                css=.ant-menu-title-content >> text=Transactions

# Transactions List Page - Total Balance
${TOTAL_BALANCE_CARD}               css=section:has-text("Total Balance:")

# Transactions List Page - Search
${TXN_SEARCH_FIELD}                 css=input[placeholder="Search transactions..."]
${TXN_SEARCH_BUTTON}                css=#btnSearch:has-text("Search")

# Transaction Table
${TXN_TABLE}                        css=.ant-table-body table
${TXN_TABLE_ROWS}                   css=.ant-table-body table tbody tr

# Transaction Action Buttons (per row)
${TXN_VIEW_BTN}                     css=button:has([data-icon="eye"])
${TXN_DOWNLOAD_BTN}                 css=button:has([data-icon="download"])

# Transaction Type Filter (column header filter icon)
${TXN_TYPE_FILTER}                  css=th:has-text("Transaction Type") .ant-table-filter-trigger
${TXN_FILTER_EXTERNAL}              css=[data-menu-id$="-external"]
${TXN_FILTER_INTERNAL}              css=[data-menu-id$="-internal"]
${TXN_FILTER_DEPOSIT}               css=[data-menu-id$="-deposit"]
${TXN_FILTER_WITHDRAWAL}            css=[data-menu-id$="-withdrawal"]

# Date & Time Filter (column header filter icon)
${TXN_DATE_TIME_FILTER}             css=th:has-text("Date & Time") .ant-table-filter-trigger
${TXN_DATE_START_INPUT}             css=input[placeholder="Start date"]
${TXN_DATE_END_INPUT}               css=input[placeholder="End date"]
${TXN_DATE_FILTER_SEARCH_BTN}       css=.ant-table-filter-dropdown button:has-text("Search")
${TXN_DATE_FILTER_RESET_BTN}        css=.ant-table-filter-dropdown button:has-text("Reset")

# Status Filter (column header filter icon)
${TXN_STATUS_FILTER}                css=th:has-text("Status") .ant-table-filter-trigger
${TXN_STATUS_PENDING}               css=[data-menu-id$="-pending"]
${TXN_STATUS_SUCCESS}               css=[data-menu-id$="-success"]
${TXN_STATUS_FAILED}                css=[data-menu-id$="-failed"]

# Filter Action Buttons
${TXN_FILTER_APPLY_BTN}             css=button.ant-btn-primary.ant-btn-sm:has-text("OK")
${TXN_FILTER_RESET_BTN}             css=.ant-table-filter-dropdown-btns .ant-btn-link

# Transaction Detail Modal
${TXN_DETAIL_MODAL}                 css=.ant-modal-content
${TXN_DETAIL_BACK_BTN}              css=.ant-modal-content button:has-text("Back")
${TXN_DETAIL_DOWNLOAD_CSV_BTN}      css=.ant-modal-content button:has-text("Download CSV")

# No Data
${TXN_NO_DATA_MESSAGE}              css=.ant-empty-description
