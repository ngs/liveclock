import SwiftUI
import LiveClockCore

@available(iOS 16.0, *)
struct SplitViewScreen: View {
    @EnvironmentObject var app: AppState

    var body: some View {
        NavigationSplitView {
            SidebarLapsView()
        } detail: {
            DetailTimerView()
        }
        .navigationSplitViewStyle(.balanced)
    }
}

@available(iOS 16.0, *)
private struct SidebarLapsView: View {
    @EnvironmentObject var app: AppState
    var body: some View {
        List {
            Section(String(localized: "Laps", bundle: .module)) {
                ForEach(app.stopwatch.laps) { lap in
                    HStack {
                        Text("#\(lap.index)")
                            .foregroundStyle(.secondary)
                            .frame(width: 44, alignment: .trailing)
                        Text(TimeFormatter.hmsms(lap.deltaFromPrev))
                            .font(.system(.body, design: .monospaced))
                        Spacer()
                        Text(TimeFormatter.timeOfDay(lap.capturedDate))
                            .font(.system(.footnote, design: .monospaced))
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        #if os(iOS)
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                Button(String(localized: "Lap", bundle: .module), action: app.stopwatch.lap)
                Button(String(localized: "Reset", bundle: .module), role: .destructive, action: app.stopwatch.reset)
            }
        }
        #endif
        .navigationTitle(String(localized: "Laps", bundle: .module))
    }
}

@available(iOS 16.0, *)
private struct DetailTimerView: View {
    var body: some View {
        VStack(spacing: 24) {
            ClockView()
            StopwatchDigitsView()
            ControlsView(showsLapButton: false)
        }
        .padding()
        .navigationTitle(String(localized: "Timer", bundle: .module))
    }
}

#if os(iOS)
@available(iOS 16.0, *)
#Preview {
    SplitViewScreen()
        .environmentObject(AppState())
}
#endif
