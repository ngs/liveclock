import SwiftUI
import LiveClockCore
import LiveClockPlatform

struct RootView: View {
    @EnvironmentObject var app: AppState
    @State private var ticker = Ticker()

    var body: some View {
        NavigationStack {
            if app.preferences.layoutModeRaw == LayoutMode.single.rawValue {
                SingleColumnScreen()
            } else {
                TwoColumnScreen()
            }
        }
        #if os(iOS)
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                NavigationLink("Settings") { PreferencesView() }
            }
        }
        #endif
        .onAppear {
            ticker.delegate = app
            ticker.start()
        }
        .onDisappear { ticker.stop() }
    }
}

extension AppState: TickerDelegate {
    public func tickerDidTick() {
        stopwatch.tick()
    }
}
