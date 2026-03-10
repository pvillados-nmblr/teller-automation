*** Variables ***
# ============================================================
# Accounts Module Locators
# ============================================================

# Navigation - Sidebar
${ACCOUNTS_MENU}                    css=[data-testid="nav-sidebar-accounts"]

# Accounts List Page - Search
${ACCOUNTS_SEARCH_FIELD}            css=input[placeholder="Search accounts..."]
${ACCOUNTS_SEARCH_BUTTON}           css=#btnSearch:has-text("Search")

# Accounts List Table
${ACCOUNTS_TABLE}                   css=.ant-table-body table
${ACCOUNTS_TABLE_ROWS}              css=.ant-table-body table tbody tr

# Account Actions (per row)
${VIEW_ACCOUNT_TRANSACTIONS_LINK}   css=[data-testid="btn-customers-accounts-view-transactions"]

# Pagination
${PAGINATION_NEXT}                  css=button.ant-pagination-item-link:has(svg[data-icon="right"])
${PAGINATION_PREV}                  css=button.ant-pagination-item-link:has(svg[data-icon="left"])

# Account Status Filter (column header filter icon)
${ACCOUNT_STATUS_FILTER}            css=th:has-text("Account Status") span.ant-table-filter-trigger

# Filter Options — AntD dropdown menu items
${FILTER_OPTION_ACTIVE}             css=[data-menu-id$="-active"]
${FILTER_OPTION_INACTIVE}           css=[data-menu-id$="-inactive"]
${FILTER_OPTION_DORMANT}            css=[data-menu-id$="-dormant"]
${FILTER_OPTION_FROZEN}             css=[data-menu-id$="-frozen"]
${FILTER_OPTION_CLOSED}             css=[data-menu-id$="-closed"]
${FILTER_OPTION_OVERDRAWN}          css=[data-menu-id$="-overdrawn"]
${FILTER_OPTION_BLOCKED}            css=[data-menu-id$="-blocked"]
${FILTER_OPTION_SUSPENDED}          css=[data-menu-id$="-suspended"]

# Filter Action Buttons
${FILTER_APPLY_BTN}                 css=button.ant-btn-primary.ant-btn-sm:has-text("OK")
${FILTER_RESET_BTN}                 css=.ant-table-filter-dropdown-btns .ant-btn-link

# No Data
${NO_DATA_MESSAGE}                  css=.ant-empty-description
