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
${ARCHIVED_PRODUCTS_TABLE_ROWS}     css=[data-testid="table-products-archived"] tbody tr:not([aria-hidden="true"])
${ARCHIVED_PRODUCTS_TAB_BTN}        css=[data-testid="tab-inactive"]

# Row-level Action Buttons
${VIEW_PRODUCT_BTN}                 css=[data-testid="btn-products-view"]
${EDIT_PRODUCT_BTN}                 css=[data-testid="btn-products-edit"]
${ARCHIVE_PRODUCT_BTN}              css=[data-testid="btn-products-archive"]
${RESTORE_PRODUCT_BTN}              css=[data-testid="btn-products-restore"]

# Pagination - Active Products (scoped to table data-testid to avoid cross-tab matches)
${PRODUCTS_PAGINATION_NEXT}             css=[data-testid="table-products-active"] .ant-pagination-next button
${PRODUCTS_PAGINATION_NEXT_DISABLED}    css=[data-testid="table-products-active"] .ant-pagination-next.ant-pagination-disabled
${PRODUCTS_PAGINATION_PREV}             css=[data-testid="table-products-active"] .ant-pagination-prev button
${PRODUCTS_PAGINATION_PREV_DISABLED}    css=[data-testid="table-products-active"] .ant-pagination-prev.ant-pagination-disabled
${PRODUCTS_PAGINATION_FIRST}            css=[data-testid="table-products-active"] .ant-pagination-item-1
${PRODUCTS_PAGINATION_PAGE_2}           css=[data-testid="table-products-active"] .ant-pagination-item-2
${PRODUCTS_PAGINATION_PAGE_3}           css=[data-testid="table-products-active"] .ant-pagination-item-3

# Pagination - Archived Products (scoped to table data-testid to avoid cross-tab matches)
${ARCHIVED_PAGINATION_NEXT}             css=[data-testid="table-products-archived"] .ant-pagination-next button
${ARCHIVED_PAGINATION_NEXT_DISABLED}    css=[data-testid="table-products-archived"] .ant-pagination-next.ant-pagination-disabled
${ARCHIVED_PAGINATION_PREV}             css=[data-testid="table-products-archived"] .ant-pagination-prev button
${ARCHIVED_PAGINATION_PREV_DISABLED}    css=[data-testid="table-products-archived"] .ant-pagination-prev.ant-pagination-disabled
${ARCHIVED_PAGINATION_FIRST}            css=[data-testid="table-products-archived"] .ant-pagination-item-1
${ARCHIVED_PAGINATION_PAGE_2}           css=[data-testid="table-products-archived"] .ant-pagination-item-2
${ARCHIVED_PAGINATION_PAGE_3}           css=[data-testid="table-products-archived"] .ant-pagination-item-3

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

# Update Status Modal (Archive / Restore) — shares same data-testid for both actions
${PRODUCT_UPDATE_STATUS_MODAL}      css=[data-testid="modal-product-update-status"] .ant-modal-content
${ARCHIVE_PRODUCT_CONFIRM_BTN}      css=[data-testid="modal-product-update-status-btn-ok"]
${ARCHIVE_PRODUCT_CANCEL_BTN}       css=[data-testid="modal-product-update-status-btn-cancel"]
${RESTORE_PRODUCT_CONFIRM_BTN}      css=[data-testid="modal-product-update-status-btn-ok"]
${RESTORE_PRODUCT_CANCEL_BTN}       css=[data-testid="modal-product-update-status-btn-cancel"]

# Product Details Drawer
${PRODUCT_DETAILS_DRAWER}           css=[data-testid="drawer-product-details"]


# ============================================================
# Create Product — Split Button & Category Dropdown
# ============================================================
${CREATE_PRODUCT_DROPDOWN_TRIGGER}      css=button.ant-btn-compact-last-item
${CREATE_SAVINGS_OPTION}                css=[data-menu-id$="-savings"]
${CREATE_LOANS_OPTION}                  css=[data-menu-id$="-loan"]

# ============================================================
# Create Product — Step 1: Product Configuration Form Fields
# Targeted via data-field attribute on form field wrappers
# ============================================================
${CP_PRODUCT_NAME_INPUT}                css=[data-field="product.name"] input
${CP_PRODUCT_TYPE_SELECT}               css=[data-field="product.type"] .ant-select-selector
${CP_DESCRIPTION_TEXTAREA}              css=[data-field="product.description"] textarea
${CP_MIN_AGE_INPUT}                     css=[data-field="eligibility.minAge"] input
${CP_AVG_DAILY_BALANCE_INPUT}           css=[data-field="accountConfig.avgDailyBalance"] input
${CP_INITIAL_DEPOSIT_INPUT}             css=[data-field="accountConfig.initialDeposit"] input
${CP_WITHDRAWAL_FREQ_SELECT}            css=[data-field="accountConfig.withdrawalLimitFrequency"] .ant-select-selector
${CP_WITHDRAWAL_AMOUNT_INPUT}           css=[data-field="accountConfig.withdrawalLimitAmount"] input
${CP_INTEREST_RATE_INPUT}               css=[data-field="interest.rate"] input
${CP_INTEREST_TYPE_SELECT}              css=[data-field="interest.type"] .ant-select-selector
${CP_INTEREST_PERIOD_SELECT}            css=[data-field="interest.period"] .ant-select-selector
${CP_INTEREST_STRUCTURE_SELECT}         css=[data-field="interest.rateStructure"] .ant-select-selector
${CP_EXCESS_WITHDRAWAL_FEE_INPUT}       css=[data-field="fees.excessWithdrawal"] input
${CP_DORMANCY_FEE_INPUT}                css=[data-field="fees.dormancy"] input
${CP_ACCOUNT_CLOSURE_FEE_INPUT}         css=[data-field="fees.accountClosure"] input
${CP_TRANSACTION_CHARGE_INPUT}          css=[data-field="fees.transactionCharge"] input
${CP_TAX_RATE_TYPE_SELECT}              css=[data-field="fees.taxRateType"] .ant-select-selector
${CP_TAX_RATE_INPUT}                    css=[data-field="fees.taxRate"] input

# ============================================================
# Create Product — Navigation Buttons (scoped to create page)
# ============================================================
${CP_BACK_BTN}                          css=[data-testid="page-products-create"] button.btn-outline:has-text("Back")
${CREATE_PRODUCT_CONTINUE_BTN}          css=[data-testid="page-products-create"] button.btn-primary:has-text("Continue")

# ============================================================
# Create Product — Step 2: Customer Form
# ============================================================
${CP_ADD_SECTION_BTN}                   css=[data-testid="page-products-create"] button.btn-dash

# ============================================================
# Create Product — Step 2: Modals (New Section & New Field)
# Targeted via data-field attributes confirmed from live HTML
# ============================================================
${CP_MODAL}                             css=.ant-modal-wrap:not([style*="display: none"]) .ant-modal-content
${CP_SECTION_NAME_INPUT}                css=.ant-modal-wrap:not([style*="display: none"]) [data-field="sectionName"] input
${CP_ADD_SECTION_CONFIRM_BTN}           css=.ant-modal-wrap:not([style*="display: none"]) .ant-modal-footer button.btn-primary
${CP_MODAL_BACK_BTN}                    css=.ant-modal-wrap:not([style*="display: none"]) .ant-modal-footer button.btn-outline
${CP_FIELD_TYPE_SELECT}                 css=.ant-modal-wrap:not([style*="display: none"]) [data-field="type"] .ant-select-selector
${CP_FIELD_NAME_INPUT}                  css=.ant-modal-wrap:not([style*="display: none"]) [data-field="label"] input
${CP_FIELD_PLACEHOLDER_INPUT}           css=.ant-modal-wrap:not([style*="display: none"]) [data-field="placeholder"] input
${CP_FIELD_OPTIONAL_CHECKBOX}           css=.ant-modal-wrap:not([style*="display: none"]) [data-field="isOptional"] input[type="checkbox"]
${CP_ADD_FIELD_CONFIRM_BTN}             css=.ant-modal-wrap:not([style*="display: none"]) .ant-modal-footer button.btn-primary

# ============================================================
# Create Product — Step 3: Review Product
# ============================================================
${CP_CONFIRM_CREATE_BTN}                css=[data-testid="page-products-create"] button:has-text("Confirm and Create Product")

# ============================================================
# Create Loans Product — Step 1: Product Definition
# ============================================================
${CLP_LOAN_TYPE_SELECT}                 css=[data-field="definition.type"] .ant-select-selector
${CLP_PREFERRED_CUSTOMERS_SALARIED}     css=[data-field="definition.preferredCustomers"] input[value="salariedIndividuals"]
${CLP_LOAN_PURPOSE_TEXTAREA}            css=[data-field="definition.purpose"] textarea

# Create Loans Product — Step 1: Product Details (uses different data-field path than Savings)
${CLP_PRODUCT_NAME_INPUT}               css=[data-field="details.name"] input
${CLP_DESCRIPTION_TEXTAREA}             css=[data-field="details.description"] textarea

# Create Loans Product — Step 1: Loan Features
${CLP_MIN_AMOUNT_INPUT}                 css=[data-field="features.minAmount"] input
${CLP_MAX_AMOUNT_INPUT}                 css=[data-field="features.maxAmount"] input
${CLP_TERM_LENGTH_INPUT}                css=[data-field="features.termLength"] input
${CLP_TERM_UNIT_SELECT}                 css=[data-field="features.termUnit"] .ant-select-selector
${CLP_INTEREST_RATE_TYPE_SELECT}        css=[data-field="features.interestRateType"] .ant-select-selector
${CLP_REPAYMENT_METHOD_INPUT}           css=[data-field="features.repaymentMethod"] input

# Create Loans Product — Step 1: Eligibility Criteria
${CLP_MIN_AGE_INPUT}                    css=[data-field="eligibility.minAge"] input
${CLP_MAX_AGE_INPUT}                    css=[data-field="eligibility.maxAge"] input
${CLP_MIN_INCOME_INPUT}                 css=[data-field="eligibility.minimumIncome"] input
${CLP_CREDIT_SCORE_INPUT}               css=[data-field="eligibility.creditScore"] input
${CLP_EMPLOYMENT_TYPE_SALARIED}         css=[data-field="eligibility.employmentType"] input[value="salaried"]

# Create Loans Product — Step 1: Pricing & Fees
${CLP_PRICING_RATE_INPUT}               css=[data-field="pricingFees.rate"] input
${CLP_RATE_STRUCTURE_SELECT}            css=[data-field="pricingFees.rateStructure"] .ant-select-selector
${CLP_PROCESSING_FEE_INPUT}             css=[data-field="pricingFees.processingFee"] input
${CLP_PROCESSING_FEE_TYPE_SELECT}       css=[data-field="pricingFees.processingFeeType"] .ant-select-selector
${CLP_PENALTY_RATE_INPUT}               css=[data-field="pricingFees.penaltyInterestRate"] input
${CLP_PENALTY_CONDITIONS_TEXTAREA}      css=[data-field="pricingFees.penaltyConditions"] textarea

# Validation Error Messages
${FIELD_VALIDATION_ERROR}               css=span.text-error-6

# Create Loans Product — Step 2: Pre-built Loan Details Section
${CLP_LOAN_DETAILS_SECTION_HEADER}      ${CREATE_PRODUCT_PAGE} >> text=Loan Details
${CLP_DISABLED_FIELDS}                  css=[data-testid="page-products-create"] .ant-input-number-disabled
${CLP_DISABLED_SELECT_FIELDS}           css=[data-testid="page-products-create"] .ant-select[aria-disabled="true"]
