*** Settings ***
Library     Browser    timeout=5s


*** Variables ***
${TODO_ROW_LOCATOR}     app-todo-item
${TODO_COUNTER_LOCATOR}    .todo-count

*** Keywords ***
Get Input Field
    [Documentation]    ...
    ${input_field} =    Get Element By
    ...    selection_strategy=Placeholder
    ...    text=What needs to be done?
    RETURN    ${input_field}

Get One Todo Row By Text Content
    [Documentation]    ...
    [Arguments]    ${text_content}
    ${row} =    Get Element    selector=${TODO_ROW_LOCATOR}:has(label:text("${text_content}"))
    RETURN    ${row}

Get One Todo Row Checkbox By Text Content
    [Documentation]    ...
    [Arguments]    ${text}
    ${row} =    Get One Todo Row By Text Content    ${text}
    ${locator} =    Set Variable    ${row} >> input[type="checkbox"]
    ${checkbox} =    Get Element    ${locator}
    RETURN    ${checkbox}
