# SwiftUI Feature Gallery

A small, modular iOS demo app that showcases common SwiftUI UI components and patterns inside a single project.

The goal of this repo is to serve as a playground / reference for:
- Exploring core SwiftUI views and navigation patterns
- Trying out a simple, SPM-based modular architecture
- Having a compact “feature gallery” you can extend with your own demos

Target platform: **iOS 17+**  
Tools: **Xcode 15+**, **Swift**, **SwiftUI**, **Swift Package Manager**

---

## Features

All feature demos are accessible from the **Catalog** screen.

- **Catalog**
  - Entry point that lists all available demos
  - Uses `AppRoute` enum for typed navigation between feature screens

- **Forms**
  - Text field
  - Toggle
  - Slider
  - Date picker
  - “Submit” button wired to a simple analytics call

- **Lists**
  - `List` with:
    - Delete (`onDelete`)
    - Reorder (`onMove`)
  - Built-in `EditButton` in the toolbar

- **Navigation**
  - `NavigationStack` usage
  - Sheet (`.sheet`) presentation
  - Popover (`.popover`) presentation

- **Text & Rich**
  - Basic rich text demo:
    - Markdown (`**bold**`, `_italic_`, `~strikethrough~`)
    - Embedded link

- **Animations**
  - Simple spring animation demo:
    - Resizable rounded rectangle
    - Button toggles width with `.animation(.spring(...), value: ...)`

- **Gestures & Drag & Drop**
  - Drag gesture:
    - Draggable card that follows the finger
    - Smooth return to original position with animation

- **Charts (placeholder)**
  - Placeholder card describing where Swift Charts examples can go
  - Ready to be replaced with real `Charts` demos (`LineMark`, `BarMark`, etc.)

- **Images & Drawing**
  - Card with a gradient background and rounded rectangle mask
  - Acts as a starting point for custom drawing and canvas experiments

- **“SwiftData” (mock)**
  - Notes list screen backed by an **in-memory repository**, not real SwiftData
  - Uses:
    - `Note` model (`id`, `title`, `text`)
    - `InMemoryNotesRepository` actor
  - “Add note” button appends demo notes and reloads the list

- **Networking (mock)**
  - Fake “fetch” request:
    - Shows `ProgressView` while “loading”
    - Uses `Task.sleep` to simulate latency
    - Fills label with a local placeholder string after delay
  - Intended as a slot to plug real networking / JSON parsing later

- **Widgets / Live Activities (placeholder)**
  - Describes where WidgetKit / Live Activities integration would live
  - The current screen is purely informational (no separate widget target yet)

- **UIKit Interop**
  - Demonstrates mixing SwiftUI with UIKit:
    - `UIActivityViewController` via `UIViewControllerRepresentable`
    - Simple “Share” button opens the system share sheet

- **Static Map**
  - `Map` (MapKit + SwiftUI) inside a card:
    - Preconfigured region
    - Rounded corners
    - `allowsHitTesting(false)` to keep it “static” in the gallery

---

## Architecture

The app is split into an app target and several local Swift Packages.

### App target

**Target:** `UIFeatureGalleryApp`

Main pieces:

- `ExampleAppApp` (`@main`)
  - Creates a default `AppContainer`
  - Boots the SwiftUI hierarchy
- `RootView`
  - Wraps everything inside `NavigationStack`
  - Shows the catalog as the root screen
  - Pushes feature screens using `AppRoute`
- `DestinationView`
  - Switches on `AppRoute` and returns the corresponding feature screen
- (Optional) `DevMenuView`
  - A simple development menu view (debug playground entry point)
- `Localizable.strings`
  - Basic localization scaffolding for **en** and **ru**

---

### Swift Packages

#### `AppCore`

Core infrastructure:

- `AppRoute`
  - `enum` describing all routes (catalog, forms, lists, navigation, textRich, animations, gesturesDnD, charts, imagesDrawing, swiftData, networking, widgets, uikitInterop, mapsStatic)
  - Provides `title` and `systemImage` for each route
  - Used by the catalog and navigation stack
- `AppContainer`
  - Lightweight dependency container
  - Holds:
    - `Loggering` implementation (`ConsoleLogger`)
    - `Analyticsing` implementation (`ConsoleAnalytics`)
    - `FeatureFlags`
  - Exposed via `EnvironmentValues.appContainer`
- `Loggering` / `ConsoleLogger`
  - Wraps `os.Logger` with a simple `log(_:, category:)` API
- `Analyticsing` / `ConsoleAnalytics`
  - Very small analytics facade
  - In demo: prints events to the console
- `FeatureFlags`
  - Struct used to toggle experimental features
- `L10n`
  - Helper for localized strings (used together with `Localizable.strings`)

#### `DesignSystem`

Shared UI building blocks:

- **Tokens**
  - `DS.Spacing` – spacing constants (`xs`, `s`, `m`, `l`, `xl`)
  - `DS.Radius` – corner radius constants
  - Color helpers (`Color.dsBackground`, `Color.dsCard`)
- **Components**
  - `FeatureScreen`
    - Common shell for all feature screens
    - Scrollable vertical stack with padding and background
  - `Card`
    - Rounded container for grouping elements
  - `AppButton`
    - Simple button wrapper with full-width text and “primary / secondary” variants

#### `DataLayer`

Data & repository layer:

- `Note`
  - Simple value type (`id: UUID`, `title: String`, `text: String`)
- `NotesRepository` protocol
  - `func list() async -> [Note]`
  - `func add(_ note: Note) async`
- `InMemoryNotesRepository` (actor)
  - Keeps notes in memory
  - Used by the “SwiftData (mock)” feature
- `Networking.swift`
  - Placeholder for future network client implementation

#### `Features`

Package that groups all feature targets:

- `FeatureCatalog`
- `FeatureForms`
- `FeatureLists`
- `FeatureNavigation`
- `FeatureTextRich`
- `FeatureAnimations`
- `FeatureGesturesDnD`
- `FeatureCharts`
- `FeatureImagesDrawing`
- `FeatureSwiftData`
- `FeatureNetworking`
- `FeatureWidgets`
- `FeatureUIKitInterop`
- `FeatureMapsStatic`

Each target exposes one main `View` (e.g. `FeatureFormsScreen`, `FeatureListsScreen`, …) and depends on:

- `AppCore` for container, routing, logging, analytics
- `DesignSystem` for layout primitives
- `DataLayer` where needed (e.g. notes repository in the SwiftData mock)

---

## Tests

The repo includes a small test target:

- `UIFeatureGalleryAppTests`
  - `AppRouteTests` – verifies route metadata (titles, system images, etc.)
  - `InMemoryNotesRepositoryTests` – tests basic add/list behavior

---

## Requirements

- **Xcode** 15 or newer
- **iOS** 17.0 or newer (Simulator is enough; no device-only APIs are used)
- No external dependencies (no CocoaPods, no external SPMs) – everything is local Swift + system frameworks.

---

## Getting Started

```bash
git clone git@github.com:plasticfennekfox/swiftui-feature-gallery.git
cd swiftui-feature-gallery
open UIFeatureGalleryApp.xcodeproj
```

Then in Xcode:

1. Select the **`UIFeatureGalleryApp`** scheme.
2. Choose an **iOS 17+ simulator** (e.g. iPhone 16).
3. Press **Run**.

You’ll see the **Catalog** screen; tap any item to open the corresponding feature demo.

---

## Extending the Gallery

Some ideas for future improvements:

- Replace the **Charts** placeholder with real Swift Charts examples
- Swap the “SwiftData (mock)” implementation for real **SwiftData** models and persistence
- Wire the **Networking** screen to a real HTTP client and public API
- Add an actual **WidgetKit** extension and Live Activity
- Expand the **Dev Menu** with runtime toggles and diagnostics
- Add more gesture, animation, and accessibility examples

Feel free to fork and adapt this project as a starting point for your own SwiftUI experiments.
