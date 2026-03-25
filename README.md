# 📱 Task Management App (Flutter) — Flodo Assignment

## 🚀 Overview

This is a Task Management mobile application built using Flutter as part of the Flodo AI take-home assignment.

The app allows users to create, manage, and organize tasks with dependencies, while maintaining a clean UI and smooth user experience.

---

## 🛠️ Tech Stack

* Flutter (Dart)
* Provider (State Management)
* Hive (Local Database)
* SharedPreferences (Draft Persistence)

---

## 📌 Features

### ✅ Core Features

* Create, Read, Update, Delete (CRUD) tasks
* Task fields:

  * Title
  * Description
  * Due Date
  * Status (To-Do, In Progress, Done)
  * Blocked By (task dependency)

---

### 🔒 Task Dependency (Blocked By)

* Tasks can depend on another task
* Blocked tasks appear greyed out with a lock icon
* Automatically unlock when the parent task is marked as Done

---

### 💾 Draft Persistence

* Input is saved if user leaves the screen
* Restored when reopened
* Cleared after saving

---

### 🔍 Search & Filter

* Search tasks by title
* Filter tasks by status

---

## ⭐ Stretch Goal Implemented

### Debounced Search + Highlight

* 300ms debounced search
* Matching text is highlighted in task titles

---

## ⏳ Async Handling

* 2-second delay for create/update
* Loading indicator shown
* Prevents duplicate submissions

---

## ⚙️ Setup Instructions

```bash
flutter pub get
flutter run
```

---

## 🎯 Track Selected

Track B: Mobile Specialist

---

## 🤖 AI Usage

ChatGPT was used to assist with:

* Debugging issues
* UI improvements
---
