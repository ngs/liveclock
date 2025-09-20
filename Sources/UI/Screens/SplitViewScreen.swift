import LiveClockCore
import SwiftUI

@available(iOS 17.0, macOS 14.0, *)
struct SplitViewScreen: View {
    @EnvironmentObject var app: AppState

    @State private var preferredCompactColumn: NavigationSplitViewColumn = .detail
    @State private var columnVisibility: NavigationSplitViewVisibility = .all

    @Environment(\.dismiss)
    private var dismiss
    @Environment(\.horizontalSizeClass)
    private var horizontalSizeClass
    @Environment(\.verticalSizeClass)
    private var verticalSizeClass

    var body: some View {
        NavigationSplitView(preferredCompactColumn: $preferredCompactColumn) {
            SidebarLapsView()
                .toolbar {
                    #if os(iOS)
                        ToolbarItem(placement: .topBarTrailing) {
                            ExportButton()
                        }
                        if horizontalSizeClass == .compact {
                            ToolbarItem(placement: .topBarTrailing) {
                                Button("Back", systemImage: "chevron.right") {
                                    preferredCompactColumn = .detail
                                }
                            }
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
                                Label(
                                    String(localized: "Settings", bundle: .module),
                                    systemImage: "gearshape")
                            }
                        }
                    #endif
                }
        }
        .navigationSplitViewStyle(.balanced)
    }
}

@available(iOS 17.0, macOS 14.0, *)
private struct SidebarLapsView: View {
    @EnvironmentObject var app: AppState
    var body: some View {
        if app.stopwatch.laps.isEmpty {
            VStack {
                Text(String(localized: "Stopwatch is not running.", bundle: .module))
                    .foregroundStyle(.secondary)
                Text(String(localized: "Start stopwatch to see it here.", bundle: .module))
                    .foregroundStyle(.secondary)
            }
            .navigationTitle(String(localized: "Laps", bundle: .module))
        } else {
            LapListView()
                .navigationTitle(String(localized: "Laps", bundle: .module))
        }
    }
}

@available(iOS 17.0, macOS 14.0, *)
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

@available(iOS 17.0, macOS 14.0, *)
#Preview {
    SplitViewScreen()
        .environmentObject(AppState())
}
