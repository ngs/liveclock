Project Setup — LiveClock The Gig Timer

Targets and Platforms
- Product Name: LiveClock The Gig Timer
- Bundle Identifier: io.ngs.LiveClock
- Platforms: iOS, iPadOS, macOS, visionOS
- Interface: SwiftUI, Language: Swift

Using Package.swift in Xcode (recommended)
1) Open Xcode 15 or newer.
2) File > Open… and select the `Package.swift` at the repo root.
3) Xcode loads the package with targets: LiveClockCore, LiveClockPlatform, LiveClockUI, LiveClockApp.
4) Create a new iOS (or Multiplatform) App target in the same workspace:
   - File > New > Target… > App (iOS or Multiplatform)
   - Product Name: LiveClock The Gig Timer
   - Bundle Identifier: io.ngs.LiveClock
5) In the new app target’s General > Frameworks, Libraries, and Embedded Content, add the following package products:
   - LiveClockCore, LiveClockPlatform, LiveClockUI
6) Set the app target’s entry point to use the SwiftUI `@main` in `Sources/App` by either:
   - Adding the package target `LiveClockApp`’s sources to the app target (File Inspector > Target Membership), or
   - Copying `Sources/App/LiveClockApp.swift` into the app target (kept as a thin wrapper) and importing `LiveClockCore` and `LiveClockUI`.
7) Build and run for each platform. The package manages code and configurations; the Xcode app target handles bundling/signing.

Using Tuist (preferred by you)
1) Install Tuist (see tuist.io): `curl -Ls https://install.tuist.io | bash` or via Homebrew.
2) From the repo root, run: `tuist generate`.
3) Open the generated workspace in Xcode.
4) Select a scheme LiveClock and run.
5) The app targets include the `Sources/App` entry and link to the Swift package products (Core/UI/Platform) automatically.
6) To add a visionOS app target, update `Project.swift` (uncomment the sample target) if your Tuist version supports `.visionOS`.

Minimum OS (suggested)
- iOS/iPadOS 16+, macOS 13+, tvOS 16+, visionOS 1.0+

Capabilities and settings
- Keep Awake: No extra entitlement needed.
- App Icons/Assets: Add in Xcode’s Asset Catalog later.

Notes
- The package defines modules similar to Point-Free’s style (separate Core/UI/Platform targets).
- The code uses conditional compilation for platform‑specific parts (display link, idle timer).
- Theme switching uses `preferredColorScheme` based on the selected appearance.
- Orientation behavior is implemented at the layout level (HStack/VStack) rather than forcing device orientation.

Next Steps (optional)
- Add app icons per platform.
- Add unit tests for `Stopwatch` and `TimeFormatter`.
- Polish tvOS/visionOS controls (focus/ornament styling).
