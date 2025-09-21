import LiveClockCore
import SwiftUI

@available(iOS 18.0, macOS 15.0, visionOS 2.0, *)
struct SplitViewScreen: View {
    @EnvironmentObject var app: AppState

    @State private var preferredCompactColumn: NavigationSplitViewColumn = .detail

    @Environment(\.horizontalSizeClass)
    private var horizontalSizeClass

    var body: some View {
        NavigationSplitView(preferredCompactColumn: $preferredCompactColumn) {
            SidebarLapsView()
                .toolbar {
#if os(iOS)
                    ToolbarItem(placement: .topBarTrailing) {
                        ExportButton()
                            .popover(isPresented: Binding(
                                get: {
                                    (horizontalSizeClass == .regular) ? app.showExporter : false
                                },
                                set: { newValue in
                                    app.showExporter = newValue
                                }
                            ), arrowEdge: .top) {
                                ActivityExporter(items: [temporaryCSVURL(for: app.stopwatch.laps)])
                            }
                    }
                    if horizontalSizeClass == .compact {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button("Back", systemImage: "chevron.right") {
                                preferredCompactColumn = .detail
                            }.accessibility(identifier: "BackButton")
                        }
                    }
#endif
                }
                .navigationSplitViewColumnWidth(min: 160, ideal: 400, max: 400)
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
                        }.popover(isPresented: Binding(
                            get: {
                                (horizontalSizeClass == .regular) ? app.showSettings : false
                            },
                            set: { newValue in
                                app.showSettings = newValue
                            }
                        )) {
                            NavigationStack {
                                PreferencesView()
                                    .environmentObject(app)
                                    .toolbar {
                                        ToolbarItem(placement: .navigationBarTrailing) {
                                            Button(String(localized: "Done", bundle: .module)) {
                                                app.showSettings = false
                                            }.bold()
                                        }
                                    }
                                    .frame(minWidth: 320, idealWidth: 420, minHeight: 320, idealHeight: 500)
                            }
                        }
                    }
#endif
                }
        }
        .navigationSplitViewStyle(.balanced)
    }
}

@available(iOS 18.0, macOS 15.0, visionOS 2.0, *)
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
                .accessibility(identifier: "LapListView")
        }
    }
}

@available(iOS 18.0, macOS 15.0, visionOS 2.0, *)
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

@available(iOS 18.0, macOS 15.0, visionOS 2.0, *)
#Preview {
    SplitViewScreen()
        .environmentObject(AppState())
}
