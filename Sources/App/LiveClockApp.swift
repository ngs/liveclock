import SwiftUI
#if os(macOS)
import AppKit
#endif
import LiveClockCore
import LiveClockUI

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
                Button("Export Laps as RTF/CSV") {
                    exportOnMac()
                }.keyboardShortcut("e", modifiers: [.command, .shift])
            }
        }
        #endif
        #if os(macOS)
        Settings {
            PreferencesView()
                .environmentObject(appState)
                .frame(minWidth: 420, minHeight: 320)
                .preferredColorScheme(appState.preferences.colorScheme)
        }
        #endif
    }

    #if os(macOS)
    private func exportOnMac() {
        guard let scene = NSApp.keyWindow else { return }
        let panel = NSSavePanel()
        if #available(macOS 12.0, *) {
            panel.allowedContentTypes = [.rtf, .commaSeparatedText]
        } else {
            panel.allowedFileTypes = ["rtf", "csv"]
        }
        panel.allowsOtherFileTypes = false
        panel.nameFieldStringValue = exportFileName(ext: "csv")
        panel.beginSheetModal(for: scene) { response in
            guard response == .OK, let url = panel.url else { return }
            let laps = appState.stopwatch.laps
            let data: Data?
            if url.pathExtension.lowercased() == "rtf" {
                data = ExportFormatter.rtf(from: laps)
            } else {
                data = ExportFormatter.csv(from: laps)
            }
            if let data {
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
