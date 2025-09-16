import SwiftUI
import LiveClockCore

@available(iOS 16.0, macOS 13.0, *)
struct SplitViewScreen: View {
    @EnvironmentObject var app: AppState
    
    var body: some View {
        NavigationSplitView {
            SidebarLapsView()
                .toolbar {
#if os(iOS)
                    ToolbarItem(placement: .topBarTrailing) {
                        ExportButton()
                    }
#endif
                }
        } detail: {
            DetailTimerView()
                .toolbar {
#if os(iOS)
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            app.showSettings = true
                        } label: {
                            Label(String(localized: "Settings", bundle: .module), systemImage: "gearshape")
                        }
                    }
#endif
                }
        }
        .navigationSplitViewStyle(.balanced)
    }
}

@available(iOS 16.0, macOS 13.0, *)
private struct SidebarLapsView: View {
    @EnvironmentObject var app: AppState
    var body: some View {
        LapListView()
            .navigationTitle(String(localized: "Laps", bundle: .module))
    }
}

@available(iOS 16.0, macOS 13.0, *)
private struct DetailTimerView: View {
    var body: some View {
        VStack(spacing: 24) {
            ClockView()
            StopwatchDigitsView()
            ControlsView()
        }
        .padding()
        .navigationTitle("")
    }
}

@available(iOS 16.0, macOS 13.0, *)
#Preview {
    SplitViewScreen()
        .environmentObject(AppState())
}
