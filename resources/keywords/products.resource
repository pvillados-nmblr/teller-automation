*** Settings ***
Library     Browser
Resource    common.resource


*** Keywords ***
Navigate To Products
    [Documentation]    Navigates to the Products module
    Navigate To Module    products

View Active Products
    [Documentation]    Verifies the list of active products is visible
    Wait For Elements State    css=.active-products-list    visible

View Archived Products
    [Documentation]    Navigates to and verifies the archived products list
    Click              id=archived-tab
    Wait For Elements State    css=.archived-products-list    visible

Fill New Product Form
    [Documentation]    Fills in the new product creation form
    [Arguments]        &{product}
    Select Options By  id=product-type      value    ${product.type}
    Fill Text          id=product-name      ${product.name}
    Fill Text          id=interest-rate     ${product.interest_rate}
    Fill Text          id=description       ${product.description}

Submit New Product Form
    [Documentation]    Submits the new product creation form
    Click              id=create-product-button
    Wait For Elements State    css=.success-message    visible

Verify Product Is Created
    [Documentation]    Verifies the product was successfully created
    [Arguments]        ${product_name}
    Get Text           css=.success-message    contains    ${product_name}

Create New Product
    [Documentation]    End-to-end keyword to create a new product
    [Arguments]        &{product}
    Navigate To Products
    Fill New Product Form      &{product}
    Submit New Product Form
    Verify Product Is Created  ${product.name}
