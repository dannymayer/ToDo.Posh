# 📝 ToDoPosh

ToDoPosh is a lightweight PowerShell Core implementation of the
classic [todo.txt](https://github.com/todotxt/todo.txt-cli) command-line tool.

Designed for cross-platform portability and minimalism, this module
allows you to manage your tasks from the terminal using a simple,
plain-text format.

---

## 🚀 Features

* Full compatibility with the `todo.txt` file format
* Modular, extensible, and PowerShell-native design
* Automatic date stamping on added tasks
* Runtime configuration engine (Get/Set-ModuleSetting)
* Config file initialization and loading
* Centralized environment variable setup with `Set-TodoDirectory`
* CRUD functionality: add, complete, delete, update, and read tasks
* Task filtering via `Get-Todo` (priority, context, project, completed)

---

## 📦 Installation

```powershell
# Clone the repository
git clone https://github.com/your-org/ToDoPosh.git
cd ToDoPosh

# Build the module
./build.ps1
```

---

## 🛠️ Usage

### ➕ Add a Task

```powershell
Add-Todo -Text "Read the todo.txt spec" -Priority A
```

Adds a new task to your configured `todo.txt` file. If `DateOnAdd` is enabled,
the task is prepended with today’s date.

### ✅ Complete a Task
```powershell
Complete-Todo -LineNumber 3
```

### ❌ Delete a Task
```powershell
Remove-Todo -LineNumber 2
```

### 📝 Update a Task
```powershell
Update-Todo -LineNumber 1 -Text "Call mom @phone +Family" -Priority B
```

### 📋 View Tasks
```powershell
Get-Todo -Priority A -Project Work -Incomplete
```

### ⚙️ Runtime Configuration
```powershell
Set-ModuleSetting -Name 'BackupOnWrite' -Value $false
```

### 🗂 Load from Config
```powershell
Load-SettingsFromFile -Path "$env:TODO_DIR\config.json"
```

### 🆕 Initialize Default Config
```powershell
Initialize-TodoConfig -Force
```

### 🌍 Set Default ToDo Directory as Environment Variable
```powershell
Set-TodoDirectory -Path "$HOME\.todo"
```

---

## ⚙️ Configuration

Use `Get-ModuleSetting` to retrieve module settings:

```powershell
Get-ModuleSetting -Name 'DateOnAdd'
```

### ⚙️ Runtime Configuration
```powershell
Set-ModuleSetting -Name 'BackupOnWrite' -Value $false
```

### 🗂 Load from Config
```powershell
Load-SettingsFromFile -Path "$env:TODO_DIR\config.json"
```

### 🆕 Initialize Default Config
```powershell
Initialize-TodoConfig -Force
```

### 🌍 Set Environment Variable
```powershell
Set-TodoDirectory -Path "$HOME\.todo"
```

### Default Settings

* `DateOnAdd`: Whether to prepend a creation date to new tasks
* `DefaultPriority`: Optional default priority value
* `TaskFilePath`: Path to the main todo.txt file
* `DoneFilePath`: Path to archive completed tasks
* `ReportFilePath`: Output path for reports
* `BackupOnWrite`: Whether to write a `.bak` file before saving
* `ArchiveOnComplete`: Whether completed tasks move to `done.txt`
* `UseColorOutput`: Whether to use ANSI color for output
* `AllowEmptyTaskText`: Allow tasks with no text (for testing)
* `TrimWhitespace`: Clean up leading/trailing spaces
* `EnableProjectIndex`: Enable +project/@context tagging

These defaults can be overridden in a future release via `Set-ModuleSetting`,
environment variables, or a config file.

---

## 📁 Directory Structure

```ascii
ToDoPosh/
│
├── build.ps1               # Module build script
├── ToDoPosh.psm1           # Module script loader
├── ToDoPosh.psd1           # Module manifest
│
├── public/                 # Exported functions
│
├── private/                # Internal-only helpers
│
└── out/                    # Build output
```

---

## 🧭 Roadmap

* [x] Add task (`Add-Todo`)
* [x] Runtime configuration engine (`Get/Set-ModuleSetting`)
* [x] JSON-based config load/save (`Load-SettingsFromFile`, `Initialize-TodoConfig`)
* [x] Read todo.txt into objects (`Read-ToDoFile`)
* [x] Write todo.txt safely (`Write-ToDoFile`)
* [x] Complete/Delete/Update tasks
* [ ] Publish to Powershell Gallery
* [ ] Task reporting (`Write-TodoReport` or `Export-TodoReport`)
* [ ] Sorting and grouping logic in `Get-Todo` (e.g., by project, priority)
* [ ] CLI experience enhancements (tab completion, argument inference)
* [ ] First-run wizard or installer for bootstrapping user environment
* [ ] Dynamic reconfiguration of `TODO_DIR` through settings

---

## 📄 License

This project is licensed under the MIT License. See the `LICENSE` file for details.
