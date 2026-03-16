*** Variables ***
# ============================================================
# Reports Module Locators
# ============================================================

# Navigation
${REPORTS_MENU}                     css=.ant-menu-title-content >> text=Reports

# Report Type Buttons (sidebar list)
${EOD_BALANCE_BTN}                  css=div.cursor-pointer:has-text("End of Day Balance")
${TOTAL_BALANCE_BTN}                css=div.cursor-pointer:has-text("Total Balance")

# End of Day — Single Closing Date Picker
${CLOSING_DATE_INPUT}               css=input[placeholder="DD MMM YYYY"]

# Total Balance — Date Range Picker
${DATE_RANGE_START_INPUT}           css=input[placeholder="Start date"][date-range="start"]
${DATE_RANGE_END_INPUT}             css=input[placeholder="End date"][date-range="end"]

# Download
${DOWNLOAD_CSV_BTN}                 css=button:has-text("Download CSV")
