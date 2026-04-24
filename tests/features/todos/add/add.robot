*** Settings ***
Library     Browser


*** Variables ***
${BASE_URL}     http://localhost:4200/
${BROWSER}      chromium
${HEADLESS}     False


*** Test Cases ***
Create A Single Todo With Standard Title
    [Documentation]    ...
    [Tags]    happy    smoke    creation
    Given The User Opens The TodoMVC Angular Application
    When The User Types "Buy groceries" In The Todo Input Field
    And The User Presses The Enter Key
    Then A Todo Item "Buy groceries" Should Be Visible In The List
    And The Todo Counter Should Display "1 item left"
    And The Input Field Should Be Empty

Create Multiple Todos Sequentially
    [Documentation]    ...
    [Tags]    happy    creation
    Given The User Opens The TodoMVC Angular Application
    When The User Types "Buy groceries" In The Todo Input Field
    And The User Presses The Enter Key
    And The User Types "Walk the dog" In The Todo Input Field
    And The User Presses The Enter Key
    And The User Types "Read a book" In The Todo Input Field
    And The User Presses The Enter Key
    Then The Todo List Should Contain 3 Items
    And The Items "Buy groceries", "Walk the dog" And "Read a book" Should Be Visible
    And The Todo Counter Should Display "3 items left"

*** Keywords ***
The User Opens The TodoMVC Angular Application
    [Documentation]    ...
    Open Browser    url=${BASE_URL}    browser=${BROWSER}    headless=${HEADLESS}
    ${todo_heading} =    Get Element By Role
    ...    role=HEADING
    ...    name=Todos
    ...    level=1
    ...    exact=True
    Wait For Elements State    ${todo_heading}    visible

The User Types "${text}" In The Todo Input Field
    [Documentation]    ...
    Fill Todo Text    ${text}

The User Presses The Enter Key
    [Documentation]    ...
    Keyboard Key    action=press    key=Enter

A Todo Item "${expected_text}" Should Be Visible In The List
    [Documentation]    ...
    ${todo_row} =    Get One Todo Row By Text Content    text_content=${expected_text}
    Get Element States    ${todo_row}    contains    visible

The Todo Counter Should Display "${display_name}"
    [Documentation]    ...
    Get Text    selector=.todo-count    assertion_operator=equal    assertion_expected=${display_name}

The Input Field Should Be Empty
    [Documentation]    ...
    ${input_field} =    Get Input Field
    Get Property
    ...    selector=${input_field}
    ...    property=value
    ...    assertion_operator=equal
    ...    assertion_expected=${EMPTY}

The Todo List Should Contain 3 Items
    [Documentation]    ...
    Get Element Count    selector=app-todo-item    assertion_operator=equal    assertion_expected=${3}

The Items "${first}", "${second}" And "${last}" Should Be Visible
    [Documentation]    ...
    Todo List Should Be Visible    ${first}    ${second}    ${last}

### ACTIONS KEYWORD

Fill Todo Text
    [Documentation]    ...
    [Arguments]    ${name}
    ${input_field} =    Get Input Field
    Fill Text    selector=${input_field}    txt=${name}

Todo List Should Be Visible
    [Documentation]    ...
    [Arguments]    @{names}
    FOR    ${name}    IN    @{names}
        Todo Item Should Be Visible    ${name}
    END

Todo Item Should Be Visible
    [Documentation]    ...
    [Arguments]    ${item}
    ${row} =    Get One Todo Row By Text Content    text_content=${item}
    Get Element States    ${row}    contains    visible

### LOCATOR KEYWORD

Get Input Field
    [Documentation]    ...
    ${input_field} =    Get Element By
    ...    selection_strategy=Placeholder
    ...    text=What needs to be done?
    RETURN    ${input_field}

Get One Todo Row By Text Content
    [Documentation]    ...
    [Arguments]    ${text_content}
    ${row} =    Get Element    selector=li:has-text("${text_content}")
    RETURN    ${row}
