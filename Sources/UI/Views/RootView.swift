import SwiftUI

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
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                NavigationLink("Settings") { PreferencesView() }
            }
        }
        .onAppear {
            ticker.delegate = app
            ticker.start()
        }
        .onDisappear { ticker.stop() }
    }
}

extension AppState: TickerDelegate {
    func tickerDidTick() {
        stopwatch.tick()
    }
}
