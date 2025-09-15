Project Setup — Live Clock The Gig Timer

Targets and Platforms
- Product Name: Live Clock The Gig Timer
- Bundle Identifier: io.ngs.LiveClock
- Platforms: iOS, iPadOS, macOS, tvOS, visionOS
- Interface: SwiftUI, Language: Swift

How to create the Xcode project
1) Open Xcode 15 or newer.
2) File > New > Project…
3) Choose “Multiplatform” > “App”.
4) Set Product Name to “Live Clock The Gig Timer”.
5) Set Organization Identifier to “io.ngs”. Xcode derives Bundle ID as io.ngs.LiveClock. Confirm it matches.
6) Uncheck “Include Tests” (you can add later).
7) Create the project.
8) In the new Xcode project, delete the auto‑generated content files if desired.
9) Drag the `Sources` folder from this repository into the Xcode project navigator (choose “Create folder references” or “Create groups” as you prefer). Ensure it’s added to the app target.

Minimum OS (suggested)
- iOS/iPadOS 16+, macOS 13+, tvOS 16+, visionOS 1.0+

Capabilities and settings
- Keep Awake: No extra entitlement needed.
- App Icons/Assets: Add in Xcode’s Asset Catalog later.

Notes
- The code uses conditional compilation for platform‑specific parts (display link, idle timer).
- Theme switching uses `preferredColorScheme` based on the selected appearance.
- Orientation behavior is implemented at the layout level (HStack/VStack) rather than forcing device orientation.

Next Steps (optional)
- Add app icons per platform.
- Add unit tests for `Stopwatch` and `TimeFormatter`.
- Polish tvOS/visionOS controls (focus/ornament styling).

