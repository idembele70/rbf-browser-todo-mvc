*** Settings ***
Library     Browser
Resource    ${CURDIR}/locators.resource


*** Keywords ***
Fill Todo Text
    [Documentation]    ...
    [Arguments]    ${name}
    ${input_field} =    Get Input Field
    Fill Text    selector=${input_field}    txt=${name}

Press Key Enter
    [Documentation]    ...
    Keyboard Key    action=press    key=Enter

Press Key Tab
    [Documentation]    ...
    Keyboard Key    action=press    key=Tab

Reload Page
    [Documentation]    ...
    Reload

Complete One Todo
    [Documentation]    ...
    [Arguments]    ${text}
    ${checkbox} =    Get One Todo Row Checkbox By Text Content    ${text}
    Check Checkbox    ${checkbox}

Navigate To Filter View
    [Documentation]    ...
    [Arguments]    ${filter_name}
    ${link} =    Get Element By Role    LINK    name=${filter_name}    exact=True
    Click    selector=${link}
    Get Classes    ${link}    equal    selected
