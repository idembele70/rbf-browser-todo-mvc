*** Settings ***
Resource    ${CURDIR}../../../../shared/resources/variables.resource
Resource    ${CURDIR}../../../../shared/resources/locators.resource
Resource    ${CURDIR}../../../../shared/resources/assertions.resource
Resource    ${CURDIR}../../../../shared/resources/actions.resource

Test Tags    creation
Test Teardown    Close Browser


*** Variables ***
${MALICIOUS_TEXT}    <script>alert('xss')</script>


*** Test Cases ***
Create A Single Todo With Standard Title
    [Documentation]    ...
    [Tags]    happy    smoke
    Given The User Opens The TodoMVC Angular Application
    When The User Types "Buy groceries" In The Todo Input Field
    And The User Presses The Enter Key
    Then A Todo Item "Buy groceries" Should Be Visible In The List
    And The Todo Counter Should Display "1 item left"
    And The Input Field Should Be Empty

Create Multiple Todos Sequentially
    [Documentation]    ...
    [Tags]    happy
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

Create A Todo Using A Very Long Title
    [Documentation]    ...
    [Tags]    edge
    Given The User Opens The TodoMVC Angular Application
    When The User Types A String Of 255 Characters In The Todo Input Field
    And The User Presses The Enter Key
    Then A Todo Item With Full 255-Character Title Should Be Visible In The List
    And The Todo Counter Should Display "1 item left"

Attempt to create a todo with only whitespace
    [Documentation]    ...
    [Tags]    negative    edge    fixme
    # TODO: The user should not be able to add todo with only whitespace
    Given The User Opens The TodoMVC Angular Application
    When The User Types "${SPACE*5}" In The Todo Input Field
    And The User Presses The Enter Key
    Then No Todo Item Should Be Added To The List
    And No Counter Should Be Displayed

Create a todo with leading and trailing whitespace
    [Documentation]    ...
    [Tags]    edge    fixme
    # Todo: The user should not be able to add todo with leading and trailing whitespace
    ${text} =    Set Variable    Buy groceries
    ${name} =    Set Variable   ${SPACE*3}${text}${SPACE*3}
    Given The User Opens The TodoMVC Angular Application
    When The User Types "${name}" In The Todo Input Field
    And The User Presses The Enter Key
    Then A Todo Item With The Trimmed Title "${text}" Should Be Visible In The List
    And The Todo Counter Should Display "1 item left"

Create a todo with special characters
    [Documentation]    ...
    [Tags]    edge
    ${name} =    Set Variable    Buy milk & eggs @ store #1!
    Given The User Opens The TodoMVC Angular Application
    When The User Types "${name}" In The Todo Input Field
    And The User Presses The Enter Key
    Then A Todo Item "${name}" Should Be Visible In The List
    And The Todo Counter Should Display "1 item left"

Create a todo with emoji characters
    [Documentation]    ...
    [Tags]    edge
    ${name} =    Set Variable    🛒 Buy groceries 🥦
    Given The User Opens The TodoMVC Angular Application
    When The User Types "${name}" In The Todo Input Field
    And The User Presses The Enter Key
    Then A Todo Item "${name}" Should Be Visible In The List
    And The Todo Counter Should Display "1 item left"

Create A Todo With Html/Script Injection Content
    [Documentation]    ...
    [Tags]    negative    security    edge
    Given The User Opens The TodoMVC Angular Application
    When The User Types "${MALICIOUS_TEXT}" In The Todo Input Field
    And The User Presses The Enter Key
    Then The Content Should Be Rendered As Plain Text In The Todo Item
    And No Javascript Alert Should Be Triggered
    And The Todo Counter Should Display "1 item left"

Create A Todo With A Numeric-Only Title
    [Documentation]    ...
    [Tags]    edge
    ${name} =    Set Variable    12345
    Given The User Opens The TodoMVC Angular Application
    When The User Types "${name}" In The Todo Input Field
    And The User Presses The Enter Key
    Then A Todo Item "${name}" Should Be Visible In The List
    And The Todo Counter Should Display "1 item left"

Create A Todo After Refreshing The Page (Persistence Check)
    [Documentation]    ...
    [Tags]    edge    persistence    fixme
    # There's not persistence, It should be implemented.
    ${name} =    Set Variable    Buy groceries
    Given The User Opens The TodoMVC Angular Application
    And The User Create A Todo "${name}"
    When The User Refreshes The Browser Page
    Then The Todo Item "${name}" Should Still Be Visible In The List
    And The Todo Counter Should Display "1 item left"

Create A Todo With Unicode/Non-Latin Title
    [Documentation]    ...
    [Tags]    edge    i18n
    ${name} =    Set Variable    Купить молоко
    Given The User Opens The TodoMVC Angular Application
    When The User Types "${name}" In The Todo Input Field
    And The User Presses The Enter Key
    Then A Todo Item "${name}" Should Be Visible In The List
    And The Todo Counter Should Display "1 item left"

Attempt To Create A Todo By Pressing Tab Instead Of Enter
    [Documentation]    ...
    [Tags]    negative    edge
    ${name} =    Set Variable    Buy groceries
    Given The User Opens The TodoMVC Angular Application
    When The User Types "${name}" In The Todo Input Field
    And The User Presses The Tab Key
    Then No Todo Item Should Be Added To The List
    And The List Should Remain Empty

Create A Todo With A Single Character Title
    [Documentation]    ...
    [Tags]    edge
    ${name} =     Set Variable    A
    Given The User Opens The TodoMVC Angular Application
    When The User Types "${name}" In The Todo Input Field
    The User Presses The Enter Key
    Then A Todo Item "${name}" Should Be Visible In The List
    And The Todo Counter Should Display "1 item left"

Create a todo while "Active" filter is selected
    [Documentation]    ...
    [Tags]    edge    filter
    ${name} =    Set Variable    New active task
    Given The User Opens The TodoMVC Angular Application
    And The User Has Previously Created And Completed A Todo "Done Task"
    And The User Clicks On The "Active" Filter
    When The User Types "${name}" In The Todo Input Field
    And The User Presses The Enter Key
    Then The Todo Item "${name}" Should Visible In The Filter List
    And The Counter Should Be Updated Accordingly

Create A Todo While Completed Filter Is Selected
    [Documentation]    ...
    [Tags]    edge    filter
    ${filter_name} =    Set Variable    Completed
    ${name} =    Set Variable    New task
    Given The User Opens The TodoMVC Angular Application
    And The User Has Previously Created And Completed A Todo "Done task"
    And The User Clicks On The "${filter_name}" Filter
    When The User Types "${name}" In The Todo Input Field
    And The User Presses The Enter Key
    Then The Todo Item "${name}" Should Not Be Visible In The "${filter_name}" Filtered List
    And Switching To "Active" Filter Should Display "New task"


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
    Press Key Enter

The User Presses The Tab Key
    [Documentation]    ...
    Press Key Tab

A Todo Item "${expected_text}" Should Be Visible In The List
    [Documentation]    ...
    ${todo_row} =    Get One Todo Row By Text Content    text_content=${expected_text}
    Get Element States    ${todo_row}    contains    visible

The Todo Counter Should Display "${display_name}"
    [Documentation]    ...
    Get Text    selector=${TODO_COUNTER_LOCATOR}    assertion_operator=equal    assertion_expected=${display_name}

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

The User Types A String Of 255 Characters In The Todo Input Field
    [Documentation]    ...
    ${name} =    Evaluate    'A' * 255
    Fill Todo Text    ${name}

A Todo Item With Full 255-Character Title Should Be Visible In The List
    [Documentation]    ...
    ${name} =    Evaluate    'A' * 255
    Todo Item Should Be Visible    ${name}

No Todo Item Should Be Added To The List
    [Documentation]    ...
    Todo List Should Be Empty

No Counter Should Be Displayed
    [Documentation]    ...
    Todo List Counter Should Be Hidden

A Todo Item With The Trimmed Title "${text}" Should Be Visible In The List
    [Documentation]    ...
    Todo Item Should Be Visible    text=${text}

The Content Should Be Rendered As Plain Text In The Todo Item
    [Documentation]    ...
    Todo Item Should Be Visible    text=${MALICIOUS_TEXT}

# Question pour julie comment faire ça proprement ? Solution proposé ci-dessous.
No Javascript Alert Should Be Triggered
    [Documentation]    ...
    ${status} =    Run Keyword And Return Status
    ...    Wait For Alert
    ...    dismiss
    ...    2s

The User Create A Todo "${text}"
    [Documentation]    ...
    Fill Todo Text    ${text}
    Press Key Enter
    Wait For Todo To Be Visible    ${text}

The User Refreshes The Browser Page
    [Documentation]    ...
    Reload Page

The Todo Item "${text}" Should Still Be Visible In The List
    [Documentation]    ...
    Todo Item Should Be Visible    text=${text}

The List Should Remain Empty
    [Documentation]    ...
    Todo List Should Be Empty

The User Has Previously Created And Completed A Todo "${text}"
    [Documentation]    ...
    Fill Todo Text    name=${text}
    Press Key Enter
    Wait For Todo To Be Visible    ${text}
    Complete One Todo    ${text}

The User Clicks On The "${filter_name}" Filter
    [Documentation]    ...
    Navigate To Filter View    ${filter_name}

The Todo Item "${name}" Should Visible In The Filter List
    [Documentation]    ...
    Todo Item Should Be Visible    text=${name}

The Counter Should Be Updated Accordingly
    [Documentation]    ...
    The Todo Counter Should Display "1 item left"

The Todo Item "${todo_name}" Should Not Be Visible In The "${filter_name}" Filtered List
    [Documentation]    ...
    Todo Item Should Be Detached    text=${todo_name}

Switching To "${filter_name}" Filter Should Display "${todo_name}"
    [Documentation]    ...
    Navigate To Filter View    ${filter_name}
    Todo Item Should Be Visible    ${todo_name}

