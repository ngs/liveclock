import SwiftUI
#if os(macOS)
import AppKit
#endif
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
        .commands {
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
                try? data.write(to: url)
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
