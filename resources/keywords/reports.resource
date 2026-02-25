*** Settings ***
Library     Browser
Resource    common.resource


*** Keywords ***
Navigate To Reports
    [Documentation]    Navigates to the Reports module
    Navigate To Module    reports

Generate End Of Day Report
    [Documentation]    Generates the End of Day report for a valid closing date
    [Arguments]        ${closing_date}
    Select Options By  id=report-type    value    end-of-day
    Fill Text          id=closing-date   ${closing_date}
    Click              id=generate-report-button
    Wait For Elements State    css=.report-result    visible

Verify End Of Day Report Is Generated
    [Documentation]    Verifies the End of Day report was successfully generated
    Get Text           css=.report-result    contains    End of Day Report

Generate Total Balance Report
    [Documentation]    Generates the Total Balance report for a valid date range
    [Arguments]        ${date_from}    ${date_to}
    Select Options By  id=report-type    value    total-balance
    Fill Text          id=date-from      ${date_from}
    Fill Text          id=date-to        ${date_to}
    Click              id=generate-report-button
    Wait For Elements State    css=.report-result    visible

Verify Total Balance Report Is Generated
    [Documentation]    Verifies the Total Balance report was successfully generated
    Get Text           css=.report-result    contains    Total Balance Report
