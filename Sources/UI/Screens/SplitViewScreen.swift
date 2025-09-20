import LiveClockCore
import SwiftUI

@available(iOS 17.0, macOS 13.0, *)
struct SplitViewScreen: View {
    @EnvironmentObject var app: AppState
    @State private var preferredCompactColumn: NavigationSplitViewColumn = .detail
    @State private var columnVisibility: NavigationSplitViewVisibility = .all
    
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
                    #endif
                }
        } detail: {
            DetailTimerView()
                .toolbar {
                    if UIDevice.current.userInterfaceIdiom == .phone {
                        ToolbarItem(placement: .topBarLeading) {
                            Button {
                                app.showLaps = true
                            } label: {
                                Label(
                                    String(localized: "Laps", bundle: .module),
                                    systemImage: "list.bullet")
                            }
                        }
                    }
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
                .navigationBarBackButtonHidden(UIDevice.current.userInterfaceIdiom == .phone)
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

@available(iOS 17.0, macOS 13.0, *)
#Preview {
    SplitViewScreen()
        .environmentObject(AppState())
}
