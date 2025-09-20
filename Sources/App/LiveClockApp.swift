import LiveClockCore
import LiveClockUI
import SwiftUI

#if os(macOS)
    import AppKit
#endif

@main
struct LiveClockApp: App {
    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(appState)
                .preferredColorScheme(appState.preferences.colorScheme)
                .onAppear {
                    appState.applyKeepAwake()
                }
        }
        #if os(macOS) || os(visionOS)
            .windowResizability(.contentMinSize)
        #endif
        #if os(macOS)
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
            }
        #endif
        #if os(macOS)
            Settings {
                MacPreferencesView()
                    .environmentObject(appState)
                    .preferredColorScheme(appState.preferences.colorScheme)
            }
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
                } catch {
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
