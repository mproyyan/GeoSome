# GeoSome

## 📁 Directory Structure

Below is the current directory structure of the project:

```text
GeoSome/
├── GeoSome/
│   ├── Assets.xcassets/
│   ├── GeoSomeApp.swift
│   ├── ContentView.swift
│   │
│   └── Features/
│       ├── Project/
│       │   ├── Models/
│       │   ├── Views/
│       │   ├── ViewModels/
│       │   └── Component/
│       │
│       └── ConstructionArea/
│           ├── Models/
│           ├── Views/
│           ├── ViewModels/
│           └── Component/
└── GeoSome.xcodeproj/
```

---

## 📖 Structure Overview

### 1. Root & App Level
- **`GeoSome/`**: The primary source code directory for the application.
- **`GeoSomeApp.swift`**: The main entry point for the SwiftUI application.
- **`Assets.xcassets/`**: Catalog for icons, image assets, and color sets.

---

### 2. Feature Modules (`Features/`)
Code is organized into independent feature modules inside `Features/` to improve scalability, maintainability, and separation of concerns.

Current modules:
- **`Project/`**: Handles all logic, flows, and UI related to projects.
- **`ConstructionArea/`**: Manages all workflows, maps, and information related to construction areas.

---

### 3. Architecture within Each Feature
Each feature module follows the MVVM structure:

| Folder | Description & Responsibilities |
| :--- | :--- |
| **`Models/`** | Data models, domain entities, and data structures specific to the feature. |
| **`Views/`** | Primary screens and user interfaces that make up the feature. |
| **`ViewModels/`** | Presentation and state management logic connecting Views and Models (e.g., using `@Observable` or `ObservableObject`). |
| **`Component/`** | Reusable UI components and sub-views scoped specifically to the feature (e.g., custom cards, list items, badges). |

---

## 🛠️ Code Formatting (SwiftFormat)

This project uses [SwiftFormat](https://github.com/nicklockwood/SwiftFormat) to enforce consistent code style and formatting. Configuration options (such as 2-space indentation and Swift 6.0 rules) are set in `.swiftformat`.

### Installation

Install via [Homebrew](https://brew.sh/):

```bash
brew install swiftformat
```

### Usage

Format all Swift files in the source directory:

```bash
swiftformat GeoSome/
```

Check formatting rules without modifying files (lint mode):

```bash
swiftformat --lint GeoSome/
```

*(Optional)* You can also integrate SwiftFormat as an Xcode Build Phase Run Script or install the [SwiftFormat for Xcode](https://github.com/nicklockwood/SwiftFormat#xcode-source-editor-extension) extension.
