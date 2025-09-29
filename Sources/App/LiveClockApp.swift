import LiveClockCore
import LiveClockUI
import LiveClockPlatform
import SwiftUI
import Logging

@main
struct LiveClockApp: App {
    @StateObject private var appState = AppState()

    var body: some Scene {
#if os(macOS)
        Window("LiveClock", id: "liveclock.main") {
            RootView()
                .environmentObject(appState)
                .preferredColorScheme(appState.preferences.colorScheme)
                .onAppear {
                    FeedbackManager.shared.setPreferences(appState.preferences)
                    appState.applyKeepAwake()
                }
        }
        .windowResizability(.contentMinSize)
        .commands {
            CommandMenu("Stopwatch") {
                Button("Start/Resume") { appState.stopwatch.start() }
                    .disabled(appState.stopwatch.state == .running)
                    .keyboardShortcut("s", modifiers: [.command])
                Button("Stop") { appState.stopwatch.pause() }
                    .disabled(appState.stopwatch.state != .running)
                    .keyboardShortcut("s", modifiers: [.command, .shift])
                Button("Lap") { appState.stopwatch.lap() }
                    .disabled(appState.stopwatch.state != .running)
                    .keyboardShortcut("l", modifiers: [.command])
                Button("Reset") { appState.stopwatch.reset() }
                    .disabled(appState.stopwatch.state != .paused)
                    .keyboardShortcut("r", modifiers: [.command])
            }
            CommandMenu("Export") {
                Button("Export Laps as CSV") {
                    exportOnMac()
                }
                .keyboardShortcut("e", modifiers: [.command, .shift])
                .disabled(appState.stopwatch.laps.isEmpty)
            }
            CommandGroup(replacing: .help) {
                Button("LiveClock Help") {
                    if let url = URL(string: String(localized: "https://liveclock.ngs.io")) {
                        NSWorkspace.shared.open(url)
                    }
                }
            }
        }
        Settings {
            MacPreferencesView()
                .environmentObject(appState)
                .preferredColorScheme(appState.preferences.colorScheme)
        }
        MenuBarExtra("LiveClock", systemImage: "stopwatch") {
            MenuBarView()
                .environmentObject(appState)
        }
        .menuBarExtraStyle(.window)
#else
        WindowGroup("LiveClock", id: "liveclock.main") {
            RootView()
                .environmentObject(appState)
                .preferredColorScheme(appState.preferences.colorScheme)
                .onAppear {
                    FeedbackManager.shared.setPreferences(appState.preferences)
                    appState.applyKeepAwake()
                }
        }
        .windowResizability(.contentMinSize)
#endif
    }

#if os(macOS)
    private func exportOnMac() {
        guard let scene = NSApp.keyWindow else { return }
        let panel = NSSavePanel()
        if #available(macOS 12.0, *) {
            panel.allowedContentTypes = [.commaSeparatedText]
        } else {
            panel.allowedFileTypes = ["csv"]
        }
        panel.allowsOtherFileTypes = false
        panel.nameFieldStringValue = exportFileName(ext: "csv")
        panel.beginSheetModal(for: scene) { response in
            guard response == .OK, let url = panel.url else { return }
            let laps = appState.stopwatch.laps
            let data = ExportFormatter.csv(from: laps)
            do {
                try data.write(to: url)
                LiveClockLogger.app.info("Successfully exported CSV to: \(url.path)")
            } catch {
                LiveClockLogger.app.error("Failed to export CSV: \(error)")
                let alert = NSAlert()
                alert.messageText = "Export Failed"
                alert.informativeText = "Unable to save the file: \(error.localizedDescription)"
                alert.alertStyle = .warning
                alert.addButton(withTitle: "OK")
                alert.runModal()
            }
        }
    }

    private func exportFileName(ext: String) -> String {
        let df = DateFormatter()
        df.locale = Locale(identifier: "en_US_POSIX")
        df.calendar = Calendar(identifier: .gregorian)
        df.timeZone = .current
        df.dateFormat = "yyyyMMdd-HHmmss"
        return "Laps-\(df.string(from: Date())).\(ext)"
    }
#endif
}
