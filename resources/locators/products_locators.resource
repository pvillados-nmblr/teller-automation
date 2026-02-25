*** Variables ***
# ============================================================
# Products Module Locators
# ============================================================
# Update these to match your actual teller app HTML

# Navigation
${PRODUCTS_MENU}               css=[data-menu="products"]

# Tabs
${ACTIVE_TAB}                  id=active-tab
${ARCHIVED_TAB}                id=archived-tab

# Product Lists
${ACTIVE_PRODUCTS_LIST}        css=.active-products-list
${ARCHIVED_PRODUCTS_LIST}      css=.archived-products-list

# New Product Form
${PRODUCT_TYPE_DROPDOWN}       id=product-type
${PRODUCT_NAME_FIELD}          id=product-name
${INTEREST_RATE_FIELD}         id=interest-rate
${DESCRIPTION_FIELD}           id=description
${CREATE_PRODUCT_BUTTON}       id=create-product-button

# Messages
${SUCCESS_MESSAGE}             css=.success-message
