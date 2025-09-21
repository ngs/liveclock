import LiveClockCore
import SwiftUI

struct ExportButton: View {
    @EnvironmentObject var app: AppState

    var body: some View {
        Button {
            app.showExporter = true
        } label: {
            Label(String(localized: "Export", bundle: .module), systemImage: "square.and.arrow.up")
        }
        .disabled(app.stopwatch.laps.isEmpty)
    }
}

#Preview {
    let appState = AppState()
    appState.stopwatch.start()
    Thread.sleep(forTimeInterval: 0.1)
    appState.stopwatch.lap()
    Thread.sleep(forTimeInterval: 0.15)
    appState.stopwatch.lap()

    return ExportButton()
        .environmentObject(appState)
}
