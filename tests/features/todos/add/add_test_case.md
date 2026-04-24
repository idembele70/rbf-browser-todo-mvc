# TodoMVC Angular — Test Cases: Todo Creation

> **Application:** [https://todomvc.com/examples/angular/dist/browser/](https://todomvc.com/examples/angular/dist/browser/)
> **Feature:** Create a new todo item
> **Framework:** Robot Framework Browser (BDD / Gherkin style)

---

## Feature: Create a New Todo Item

---

### TC-001 — Create a single todo with a standard title

**Tags:** `happy-path` `smoke` `creation`

```gherkin
Given the user opens the TodoMVC Angular application
When the user types "Buy groceries" in the todo input field
And the user presses the Enter key
Then a todo item "Buy groceries" should be visible in the list
And the todo counter should display "1 item left"
And the input field should be empty
```

---

### TC-002 — Create multiple todos sequentially

**Tags:** `happy-path` `creation`

```gherkin
Given the user opens the TodoMVC Angular application
When the user types "Buy groceries" in the todo input field
And the user presses the Enter key
And the user types "Walk the dog" in the todo input field
And the user presses the Enter key
And the user types "Read a book" in the todo input field
And the user presses the Enter key
Then the todo list should contain 3 items
And the items "Buy groceries", "Walk the dog" and "Read a book" should be visible
And the todo counter should display "3 items left"
```

---

### TC-003 — Create a todo using a very long title

**Tags:** `edge-case` `creation`

```gherkin
Given the user opens the TodoMVC Angular application
When the user types a string of 255 characters in the todo input field
And the user presses the Enter key
Then a todo item with the full 255-character title should be visible in the list
And the todo counter should display "1 item left"
```

---

### TC-004 — Attempt to create a todo with only whitespace

**Tags:** `negative` `edge-case` `creation`

```gherkin
Given the user opens the TodoMVC Angular application
When the user types "     " (spaces only) in the todo input field
And the user presses the Enter key
Then no todo item should be added to the list
And the todo list should remain empty
And no counter should be displayed
```

---

### TC-005 — Attempt to create a todo with an empty input

**Tags:** `negative` `creation`

```gherkin
Given the user opens the TodoMVC Angular application
When the user clicks on the todo input field
And the user presses the Enter key without typing anything
Then no todo item should be added to the list
And the todo list should remain empty
```

---

### TC-006 — Create a todo with leading and trailing whitespace

**Tags:** `edge-case` `creation`

```gherkin
Given the user opens the TodoMVC Angular application
When the user types "   Buy groceries   " in the todo input field
And the user presses the Enter key
Then a todo item with the trimmed title "Buy groceries" should be visible in the list
And the todo counter should display "1 item left"
```

---

### TC-007 — Create a todo with special characters

**Tags:** `edge-case` `creation`

```gherkin
Given the user opens the TodoMVC Angular application
When the user types "Buy milk & eggs @ store #1!" in the todo input field
And the user presses the Enter key
Then a todo item "Buy milk & eggs @ store #1!" should be visible in the list
And the todo counter should display "1 item left"
```

---

### TC-008 — Create a todo with emoji characters

**Tags:** `edge-case` `creation`

```gherkin
Given the user opens the TodoMVC Angular application
When the user types "🛒 Buy groceries 🥦" in the todo input field
And the user presses the Enter key
Then a todo item "🛒 Buy groceries 🥦" should be visible in the list
And the todo counter should display "1 item left"
```

---

### TC-009 — Create a todo with HTML/script injection content

**Tags:** `negative` `security` `edge-case` `creation`

```gherkin
Given the user opens the TodoMVC Angular application
When the user types "<script>alert('xss')</script>" in the todo input field
And the user presses the Enter key
Then the content should be rendered as plain text in the todo item
And no JavaScript alert should be triggered
And the todo counter should display "1 item left"
```

---

### TC-010 — Create a todo with a numeric-only title

**Tags:** `edge-case` `creation`

```gherkin
Given the user opens the TodoMVC Angular application
When the user types "12345" in the todo input field
And the user presses the Enter key
Then a todo item "12345" should be visible in the list
And the todo counter should display "1 item left"
```

---

### TC-011 — Newly created todo should have an unchecked state by default

**Tags:** `happy-path` `creation` `state`

```gherkin
Given the user opens the TodoMVC Angular application
When the user types "Buy groceries" in the todo input field
And the user presses the Enter key
Then the todo item "Buy groceries" should be visible
And the checkbox of "Buy groceries" should be unchecked
And the todo item should not have a strikethrough style
```

---

### TC-012 — Input field should retain focus after todo creation

**Tags:** `happy-path` `creation` `ux`

```gherkin
Given the user opens the TodoMVC Angular application
When the user types "Buy groceries" in the todo input field
And the user presses the Enter key
Then the todo input field should still have focus
And the user should be able to immediately type a new todo
```

---

### TC-013 — Todo order should respect insertion order

**Tags:** `happy-path` `creation` `ordering`

```gherkin
Given the user opens the TodoMVC Angular application
When the user creates the following todos in order:
  | title         |
  | First task    |
  | Second task   |
  | Third task    |
Then the todo list should display items in this order:
  | position | title       |
  | 1        | First task  |
  | 2        | Second task |
  | 3        | Third task  |
```

---

### TC-014 — Create a todo after refreshing the page (persistence check)

**Tags:** `edge-case` `creation` `persistence`

```gherkin
Given the user opens the TodoMVC Angular application
And the user creates a todo "Buy groceries"
When the user refreshes the browser page
Then the todo item "Buy groceries" should still be visible in the list
And the todo counter should display "1 item left"
```

---

### TC-015 — Create a todo with a Unicode/non-latin title

**Tags:** `edge-case` `creation` `i18n`

```gherkin
Given the user opens the TodoMVC Angular application
When the user types "Купить молоко" in the todo input field
And the user presses the Enter key
Then a todo item "Купить молоко" should be visible in the list
And the todo counter should display "1 item left"
```

---

### TC-016 — Attempt to create a todo by pressing Tab instead of Enter

**Tags:** `negative` `edge-case` `creation`

```gherkin
Given the user opens the TodoMVC Angular application
When the user types "Buy groceries" in the todo input field
And the user presses the Tab key
Then no todo item should be added to the list
And the todo list should remain empty
```

---

### TC-017 — Create a todo with a single character title

**Tags:** `edge-case` `creation`

```gherkin
Given the user opens the TodoMVC Angular application
When the user types "A" in the todo input field
And the user presses the Enter key
Then a todo item "A" should be visible in the list
And the todo counter should display "1 item left"
```

---

### TC-018 — Counter label pluralization (1 item vs N items)

**Tags:** `happy-path` `creation` `ux`

```gherkin
Given the user opens the TodoMVC Angular application
When the user creates a todo "Buy groceries"
Then the todo counter should display "1 item left"
When the user creates a todo "Walk the dog"
Then the todo counter should display "2 items left"
```

---

### TC-019 — Create a todo while "Active" filter is selected

**Tags:** `edge-case` `creation` `filter`

```gherkin
Given the user opens the TodoMVC Angular application
And the user has previously created and completed a todo "Done task"
And the user clicks on the "Active" filter
When the user types "New active task" in the todo input field
And the user presses the Enter key
Then the todo item "New active task" should be visible in the filtered list
And the counter should be updated accordingly
```

---

### TC-020 — Create a todo while "Completed" filter is selected

**Tags:** `edge-case` `creation` `filter`

```gherkin
Given the user opens the TodoMVC Angular application
And the user has previously created and completed a todo "Done task"
And the user clicks on the "Completed" filter
When the user types "New task" in the todo input field
And the user presses the Enter key
Then the todo item "New task" should NOT be visible in the "Completed" filtered list
And switching to "Active" filter should display "New task"
```

---

### TC-021 — "Toggle all" arrow should appear after first todo is created

**Tags:** `happy-path` `creation` `ui`

```gherkin
Given the user opens the TodoMVC Angular application
And the toggle-all arrow is not visible
When the user creates a todo "Buy groceries"
Then the toggle-all arrow should become visible in the UI
```

---

### TC-022 — Footer with filters should appear after first todo is created

**Tags:** `happy-path` `creation` `ui`

```gherkin
Given the user opens the TodoMVC Angular application
And the footer with filters is not visible
When the user creates a todo "Buy groceries"
Then the footer should be visible
And the filters "All", "Active" and "Completed" should be displayed
```