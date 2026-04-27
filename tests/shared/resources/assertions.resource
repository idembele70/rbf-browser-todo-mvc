*** Settings ***
Resource     ${CURDIR}/locators.resource


*** Keywords ***
Todo List Should Be Visible
    [Documentation]    ...
    [Arguments]    @{names}
    FOR    ${name}    IN    @{names}
        Todo Item Should Be Visible    ${name}
    END

Todo Item Should Be Visible
    [Documentation]    ...
    [Arguments]    ${text}
    ${row} =    Get One Todo Row By Text Content    text_content=${text}
    Get Element States    ${row}    contains    visible

Todo Item Should Be Detached
    [Documentation]    ...
    [Arguments]    ${text}
    Get Element States   "${text}"    equals    detached

Todo List Should Be Empty
    [Documentation]    ...
    Get Element Count    selector=${TODO_ROW_LOCATOR}    assertion_operator=equal    assertion_expected=${0}

Todo List Counter Should Be Hidden
    [Documentation]    ...
    Get Element Count    selector=${TODO_COUNTER_LOCATOR}    assertion_operator=equal    assertion_expected=0

Wait For Todo To Be Visible
    [Documentation]    ...
    [Arguments]    ${text}
    ${row} =    Get One Todo Row By Text Content    ${text}
    Wait For Elements State    selector=${row}    state=visible
