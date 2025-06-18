# ✅ todo.txt Syntax Guide

The `todo.txt` format is a plain text system for organizing tasks using a simple,
structured format that is both human- and machine-readable. Below is a reference
for how to structure your task entries.

---

## 🔤 Basic Format

```
(P) YYYY-MM-DD Task description +Project @Context
```

* `(P)` - Optional single-letter priority, must be uppercase A–Z and in parentheses
* `YYYY-MM-DD` - Optional creation date
* `Task description` - Freeform text
* `+Project` - One or more tags starting with a plus sign
* `@Context` - One or more tags starting with an at sign

---

## 🛠️ Examples

```
(A) 2025-06-17 Write syntax guide +Docs @writing
2025-06-17 Buy milk @errands
(B) File quarterly report +Finance @office
x 2025-06-15 2025-06-10 Call mom +Family @phone
```

---

## ✅ Completed Tasks

* Begin with `x` followed by the completion date and optional creation date.

```
x 2025-06-17 2025-06-10 Task text here +Project @Context
```

---

## ⛔ Special Notes

* Tasks are ordered by their appearance in the file.
* Priority must come before the date and text.
* The `x` marker for completed tasks must be the first character.

---

## 📚 More Resources

* [todo.txt CLI GitHub](https://github.com/todotxt/todo.txt-cli)
* Example file: [Sample.todo](./Sample.todo)
