import SwiftUI
import LiveClockCore
import LiveClockPlatform

public struct RootView: View {
    @EnvironmentObject var app: AppState
    @State private var ticker: Ticker?

    public init() {}

    public var body: some View {
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
            let t = Ticker()
            t.delegate = app
            t.start()
            ticker = t
        }
        .onDisappear {
            ticker?.stop()
            ticker = nil
        }
    }
}

extension AppState: TickerDelegate {
    public func tickerDidTick() {
        now = Date()
        stopwatch.tick()
    }
}
