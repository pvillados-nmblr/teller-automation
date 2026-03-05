*** Settings ***
Documentation       Test suite for the Reports module
...                 Covers generating End of Day Report and Total Balance Report.

Resource            ../../resources/keywords/common.resource
Resource            ../../resources/keywords/reports.resource

Suite Setup         Login To Teller App
Suite Teardown      Logout From Teller App


*** Variables ***
${VALID_CLOSING_DATE}    02/23/2026
${VALID_DATE_FROM}       02/01/2026
${VALID_DATE_TO}         02/23/2026


*** Test Cases ***
# Teller Can Generate End Of Day Report With Valid Closing Date
#     [Documentation]    Verify that the teller can generate an End of Day report using a valid closing date
#     [Tags]             reports    smoke
#     Navigate To Reports
#     Generate End Of Day Report       ${VALID_CLOSING_DATE}
#     Verify End Of Day Report Is Generated

# Teller Can Generate Total Balance Report With Valid Date Range
#     [Documentation]    Verify that the teller can generate a Total Balance report using a valid date range
#     [Tags]             reports    smoke
#     Navigate To Reports
#     Generate Total Balance Report    ${VALID_DATE_FROM}    ${VALID_DATE_TO}
#     Verify Total Balance Report Is Generated
