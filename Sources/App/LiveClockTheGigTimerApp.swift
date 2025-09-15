import SwiftUI
import LiveClockCore
import LiveClockUI

@main
struct LiveClockTheGigTimerApp: App {
    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(appState)
                .preferredColorScheme(appState.preferences.colorScheme)
                .onAppear { appState.applyKeepAwake() }
        }
        #if os(macOS)
        Settings {
            PreferencesView()
                .environmentObject(appState)
                .frame(minWidth: 420, minHeight: 320)
        }
        #endif
    }
}
