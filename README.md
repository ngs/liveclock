Live Clock The Gig Timer

Scaffolded SwiftUI multi‑platform app source is under `Sources/`.

- App identifier: `io.ngs.LiveClock`
- Display name: Live Clock The Gig Timer
- Platforms: iOS, iPadOS, macOS, tvOS, visionOS

How to build
- Option A — Tuist: run `tuist generate`, open the workspace, pick a platform scheme, and run.
- Option B — Xcode + SPM: open `Package.swift` and follow `PROJECT_SETUP.md` to add an App target that depends on the package products (Core, Platform, UI) and uses the App entry from `Sources/App`.

What’s included
- Core stopwatch engine with millisecond precision and laps.
- Time formatter `HH:MM:SS.mmm`.
- Single‑ and two‑column layouts with lap list.
- Preferences: theme (system/light/dark), text color, keep‑awake, layout/orientation behavior.
- Platform helpers: display‑linked ticker (iOS/tvOS/visionOS) and idle‑sleep control.

Next steps
- Add assets (app icons), fine‑tune typography per platform, and write tests.
