import SwiftUI
import LiveClockCore

#if os(iOS)
struct ExportButton: View {
    @EnvironmentObject var app: AppState
    @State private var showExporter = false
    var body: some View {
        Button {
            showExporter = true
        } label: {
            Label("Export", systemImage: "square.and.arrow.up")
        }
        .sheet(isPresented: $showExporter) {
            ActivityExporter(items: [temporaryCSVURL(for: app.stopwatch.laps)])
        }
    }
}
#else
struct ExportButton: View { var body: some View { EmptyView() } }
#endif

#if os(iOS)
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
#endif
