*** Variables ***
# ============================================================
# Reports Module Locators
# ============================================================
# Update these to match your actual teller app HTML

# Navigation
${REPORTS_MENU}                css=[data-menu="reports"]

# Report Form
${REPORT_TYPE_DROPDOWN}        id=report-type
${CLOSING_DATE_FIELD}          id=closing-date
${DATE_FROM_FIELD}             id=date-from
${DATE_TO_FIELD}               id=date-to
${GENERATE_REPORT_BUTTON}      id=generate-report-button

# Report Output
${REPORT_RESULT}               css=.report-result
