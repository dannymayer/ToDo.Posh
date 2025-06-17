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
* Configurable settings via `Get-ModuleSetting` (and soon `Set-ModuleSetting`)
* Customizable file paths via environment variables or configuration
* Seamless integration with scripts, aliases, and Git workflows

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

---

## ⚙️ Configuration

Use `Get-ModuleSetting` to retrieve module settings:

```powershell
Get-ModuleSetting -Name 'DateOnAdd'
```

### Default Settings

* `DateOnAdd`: Whether to prepend a creation date to new tasks
* `TaskFilePath`: Path to the main todo.txt file
* `DoneFilePath`: Path to archive completed tasks
* `BackupOnWrite`: Whether to write a `.bak` file before saving
* `ArchiveOnComplete`: Whether completed tasks are moved to `done.txt`

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
* [ ] Complete task
* [ ] Delete task
* [ ] Modify task
* [ ] List and filter tasks
* [ ] `Set-ModuleSetting` support
* [ ] Persistent configuration via JSON/INI
* [ ] Alias management and tab completion

---

## 📄 License

This project is licensed under the MIT License. See the `LICENSE` file for details.
