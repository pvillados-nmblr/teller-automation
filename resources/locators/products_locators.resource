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

# Tabs
${ACTIVE_PRODUCTS_TAB}              css=[data-testid="tab-active"]
${ARCHIVED_PRODUCTS_TAB}            css=[data-testid="tab-inactive"]
${ACTIVE_PRODUCTS_TAB_BTN}          css=[data-testid="tab-active"]

# Active Products Table
${ACTIVE_PRODUCTS_TABLE}            css=[data-testid="table-products-active"]
${ACTIVE_PRODUCTS_TABLE_ROWS}       css=[data-testid="table-products-active"] tbody tr:not([aria-hidden="true"])

# Archived Products Table
${ARCHIVED_PRODUCTS_TABLE}          css=[data-testid="table-products-archived"]

# Row-level Action Buttons
${VIEW_PRODUCT_BTN}                 css=[data-testid="btn-products-view"]
${EDIT_PRODUCT_BTN}                 css=[data-testid="btn-products-edit"]
${ARCHIVE_PRODUCT_BTN}              css=[data-testid="btn-products-archive"]
${RESTORE_PRODUCT_BTN}              css=[data-testid="btn-products-restore"]

# Pagination
${PRODUCTS_PAGINATION_NEXT}         css=.ant-pagination-next button
${PRODUCTS_PAGINATION_NEXT_DISABLED}    css=.ant-pagination-next.ant-pagination-disabled
${PRODUCTS_PAGINATION_FIRST}        css=.ant-pagination-item-1

# Create Product Page
${CREATE_PRODUCT_PAGE}              css=[data-testid="page-products-create"]
${CREATE_PRODUCT_STEPS}             css=[data-testid="steps-products-create"]

# Edit Product Page
${EDIT_PRODUCT_PAGE}                css=[data-testid="page-products-edit"]
# Updated Save Button in products_locators.resource
${EDIT_PRODUCT_SAVE_BTN}            css=button#btn:has-text("Save Changes")
${EDIT_PRODUCT_BACK_BTN}            css=button#btn:has-text("Back")

# Leave Page Confirmation Dialog (Navigation Blocker Modal)
${LEAVE_PAGE_CONFIRM_MODAL}         css=.ant-modal-content:has([data-testid="btn-navigation-blocker-confirm"])
${LEAVE_PAGE_CONFIRM_BTN}           css=[data-testid="btn-navigation-blocker-confirm"]
${LEAVE_PAGE_CANCEL_BTN}            css=[data-testid="btn-navigation-blocker-cancel"]

# Product Details Modal
${PRODUCT_DETAILS_MODAL}            css=[data-testid="modal-product-details"] .ant-modal-content

# Update Status Modal (Archive / Restore)
${PRODUCT_UPDATE_STATUS_MODAL}      css=[data-testid="modal-product-update-status"] .ant-modal-content
${ARCHIVE_PRODUCT_CONFIRM_BTN}      css=[data-testid="modal-product-update-status-btn-ok"]
${ARCHIVE_PRODUCT_CANCEL_BTN}       css=[data-testid="modal-product-update-status-btn-cancel"]

# Product Details Drawer
${PRODUCT_DETAILS_DRAWER}           css=[data-testid="drawer-product-details"]
