*** Variables ***
# ============================================================
# Products Module Locators
# data-testid: products.*
# ============================================================

# Navigation
${PRODUCTS_MENU}                    css=[data-testid="nav-sidebar-products"]

# Products List Page
${PRODUCTS_LIST_PAGE}               css=[data-testid="page-products-list"]
${CREATE_PRODUCT_BTN}               css=[data-testid="btn-products-create"]

# Active Products Table
${ACTIVE_PRODUCTS_TABLE}            css=[data-testid="table-products-active"]

# Archived Products Table
${ARCHIVED_PRODUCTS_TABLE}          css=[data-testid="table-products-archived"]

# Row-level Action Buttons
${VIEW_PRODUCT_BTN}                 css=[data-testid="btn-products-view"]
${EDIT_PRODUCT_BTN}                 css=[data-testid="btn-products-edit"]
${ARCHIVE_PRODUCT_BTN}              css=[data-testid="btn-products-archive"]
${RESTORE_PRODUCT_BTN}              css=[data-testid="btn-products-restore"]

# Create Product Page
${CREATE_PRODUCT_PAGE}              css=[data-testid="page-products-create"]
${CREATE_PRODUCT_STEPS}             css=[data-testid="steps-products-create"]

# Edit Product Page
${EDIT_PRODUCT_PAGE}                css=[data-testid="page-products-edit"]

# Product Details Modal
${PRODUCT_DETAILS_MODAL}            css=[data-testid="modal-product-details"]

# Update Status Modal
${PRODUCT_UPDATE_STATUS_MODAL}      css=[data-testid="modal-product-update-status"]

# Product Details Drawer
${PRODUCT_DETAILS_DRAWER}           css=[data-testid="drawer-product-details"]
