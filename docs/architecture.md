# Architecture

- App layers
  - TimingEngine: Monotonic stopwatch with millisecond precision, lap capture, and state machine (idle/running/paused).
  - AppState: Observable source of truth that bridges TimingEngine, preference storage, and view models.
  - Preferences: Appearance (system/dark/light), custom text color, layout mode, orientation behavior, keep‑awake toggle.
  - UI: SwiftUI views for Single‑Column and Two‑Column layouts, shared controls, theming.
- Concurrency & observation
  - Use Swift’s `Observation` (`@Observable`, `@State`, `@Environment`) to publish state changes.
  - Use a display‑driven tick where available (CADisplayLink on iOS/visionOS) and a high‑frequency timer on macOS.
- Platforms
  - iOS/iPadOS/visionOS: Display‑linked updates for smooth UI; disable idle sleep while app is active.
  - macOS: Use `ProcessInfo.processInfo.beginActivity(options: .idleSystemSleepDisabled, reason:)` to keep the display awake.

