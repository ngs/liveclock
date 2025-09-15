Live Clock The Gig Timer — Agent Guide and Technical Design

Overview
- Goal: A simple, distraction‑free universal timer/stopwatch for live performance use, showing time down to milliseconds with optional lap tracking.
- Platforms: iOS, iPadOS, macOS, visionOS, tvOS.
- Bundle Identifier: io.ngs.LiveClock
- App Name (display/marketing): Live Clock The Gig Timer
- Tech: Swift 5.9+ (or project default), SwiftUI, Observation, no third‑party dependencies.
- UX pillars: instant readability, large typography, reliable timing, minimal chrome, configurable layout/theme.

Non‑Goals (for initial releases)
- No cloud sync or multi‑device coordination.
- No background audio/session timing.
- No complex data persistence beyond preferences.

Architecture
- App layers
  - TimingEngine: Monotonic stopwatch with millisecond precision, lap capture, and state machine (idle/running/paused).
  - AppState: Observable source of truth that bridges TimingEngine, preference storage, and view models.
  - Preferences: Appearance (system/dark/light), custom text color, layout mode, orientation behavior, keep‑awake toggle.
  - UI: SwiftUI views for Single‑Column and Two‑Column layouts, shared controls, theming.
- Concurrency & observation
  - Use Swift’s `Observation` (`@Observable`, `@State`, `@Environment`) to publish state changes.
  - Use a display‑driven tick where available (CADisplayLink on iOS/tvOS/visionOS) and a high‑frequency timer on macOS.
- Platforms
  - iOS/iPadOS/visionOS/tvOS: Display‑linked updates for smooth UI; disable idle sleep while app is active.
  - macOS: Use `ProcessInfo.processInfo.beginActivity(options: .idleSystemSleepDisabled, reason:)` to keep the display awake.

Timing Engine
- Requirements
  - Millisecond display accuracy; update cadence may be 60 Hz while computing using a monotonic clock.
  - Robust pause/resume (accumulate offsets without drift).
  - Lap capture with absolute and delta times.
- Implementation notes
  - Time source: Prefer `ContinuousClock` (Swift) or `CACurrentMediaTime()` for monotonic uptime; store `startInstant` and `accumulated` duration.
  - Update loop: Platform‑specific ticker updates a lightweight `now` used to compute derived `elapsed` on the fly.
  - State: `enum StopwatchState { idle, running, paused }` with transitions; guard against double starts/resets.
  - Laps: `struct Lap { id, atTotal, deltaFromPrev }`; maintain an array with newest first or last (configurable; default newest first in UI).
  - Formatting: Custom formatter producing `HH:MM:SS.mmm` without allocations on every frame.

UI Design
- Layout modes
  - Single‑Column: Large centered clock only (maximizes legibility).
  - Two‑Column: Left = clock, Right = Lap list. On wide screens, allow a resizable split; on compact, fixed 50/50.
- Orientation behavior
  - Follow device rotation (default), or Lock layout orientation (Portrait/Landscape) regardless of device orientation.
  - Implement as an internal layout flag rather than forcing system orientation on iOS; macOS/tvOS ignore.
- Controls
  - Primary: Start/Stop/Resume, Lap, Reset. Place as bottom toolbar (iOS/iPadOS), titlebar toolbar (macOS), ornament/floating controls (visionOS), and focused buttons (tvOS).
  - Optional: Toggle layout (1/2 columns), Keep Awake, Theme, Text Color, Orientation behavior in a Settings sheet/panel.
- Theming
  - Appearance: System / Light / Dark.
  - Text color: Spectrum `ColorPicker`; store as RGBA in preferences. Provide a quick‑pick for high‑contrast presets.
  - Background: Adaptive neutral background per appearance, with strong contrast ratios for the time digits.
- Accessibility
  - Support Dynamic Type / content size categories (scale the clock responsibly).
  - VoiceOver: Speak elapsed time and announce lap additions.
  - High contrast and sufficient tap targets.

Data Model
- Stopwatch
  - state: idle|running|paused
  - startInstant: monotonic reference when running
  - accumulated: Duration gathered while paused
  - laps: [Lap]
  - lastLapInstant: monotonic instant for delta
- Lap
  - index: Int (1-based)
  - atTotal: Duration since first start
  - deltaFromPrev: Duration since previous lap or start

Preferences (persisted)
- `appearanceMode`: system|light|dark
- `customTextColor`: RGBA (e.g., 4 floats 0…1) or hex
- `layoutMode`: single|double
- `followDeviceRotation`: Bool
- `fixedLayoutOrientation`: portrait|landscape (used when followDeviceRotation == false)
- `keepAwake`: Bool (default true)

Platform Notes
- Keep‑awake
  - iOS/iPadOS/tvOS/visionOS: `UIApplication.shared.isIdleTimerDisabled = true` while active (guard with `#if !os(macOS)` and availability checks).
  - macOS: `ProcessInfo.processInfo.beginActivity(options: [.idleSystemSleepDisabled], reason: "Live timing")`; hold a token and end on app deactivate.
- Display tick
  - iOS/tvOS/visionOS: `CADisplayLink` into the main runloop; update `now` and derive elapsed.
  - macOS: `Timer` at 1/60 sec; consider throttling when paused.
- Orientation
  - iOS: Do not fight system orientation; implement a view‑level layout lock (render as portrait or landscape grid) independent of device rotation.
  - iPadOS/macOS: Size classes and window resizing will reflow; keep layout responsive.
  - tvOS/visionOS: Orientation lock ignored; always use best layout for scene.

Formatting Utilities
- Provide `TimeFormatter.format(_ duration: Duration) -> String` returning `HH:MM:SS.mmm`.
- Avoid allocations: Reuse `DateComponents` or use integer math; pad with `String(format:)` or a custom buffer builder.

Persistence Strategy
- Use `@AppStorage` for simple preferences across all Apple platforms.
- Optionally mirror to a tiny `PreferencesStore` to validate and migrate values.
- Session data (laps) is ephemeral; do not persist across launches in v1.

Navigation & Scenes
- SwiftUI `App` with one window per platform.
- macOS: add a Settings scene for preferences; toolbar for quick actions.
- visionOS: a volumetric‑friendly single window; controls via ornaments.
- tvOS: a single full‑screen scene with focusable controls.

Testing
- Unit tests
  - Time formatting edge cases (sub‑second rounding, hour rollover).
  - Stopwatch transitions (start/pause/resume/reset) and lap deltas.
- UI tests
  - Smoke test start/stop/lap/reset and theme toggles on iOS.

Implementation Roadmap
1) Core stopwatch engine + formatter + minimal UI (single column, start/stop/lap/reset).
2) Two‑column layout with lap list; responsive split.
3) Preferences: appearance, text color, keep‑awake.
4) Orientation behavior toggle (follow vs fixed portrait/landscape) at the layout level.
5) Platform polish: macOS/tvOS/visionOS specific tweaks and accessibility.

File/Code Organization
- Sources
  - `App/` SwiftUI App entry, scenes, app life‑cycle hooks.
  - `Core/Timing/` Stopwatch engine and time utilities.
  - `Core/Preferences/` Preference models and storage.
  - `UI/Views/` Reusable components (ClockView, LapListView, ControlsView).
  - `UI/Screens/` SingleColumnScreen, TwoColumnScreen, Settings.
  - `Platform/` Platform shims (idle timer, display link, ornaments).
- Naming
  - Types: UpperCamelCase. Methods/properties: lowerCamelCase. Enums singular.
  - Keep files small and focused; avoid one‑letter names.

Design Guidelines for Contributors (Agent Rules)
- Avoid third‑party dependencies unless explicitly approved.
- Keep changes minimal and focused on the task at hand.
- Prioritize readability and determinism over micro‑optimizations.
- Follow the roadmap; do not expand scope without request.
- Ensure all platform conditionals are correct and compiled across targets.

Open Questions (to confirm with owner)
- Should laps list be newest‑first or oldest‑first by default? (Assume newest‑first.)
- Persist last session’s laps across launches? (Assume no for v1.)
- Minimum OS versions per platform? (Assume iOS/iPadOS 16+, macOS 13+, tvOS 16+, visionOS 1.0+.)
