import SwiftUI
import LiveClockCore
import LiveClockPlatform
#if os(iOS)
import UIKit
#endif

public struct RootView: View {
    @EnvironmentObject var app: AppState
    @State private var ticker: Ticker?

    public init() {}

    public var body: some View {
        NavigationStack {
            #if os(iOS)
            if UIDevice.current.userInterfaceIdiom == .pad, #available(iOS 16.0, *) {
                SplitViewScreen()
            } else {
                if app.preferences.layoutModeRaw == LayoutMode.single.rawValue {
                    SingleColumnScreen()
                } else {
                    TwoColumnScreen()
                }
            }
            #else
            if app.preferences.layoutModeRaw == LayoutMode.single.rawValue {
                SingleColumnScreen()
            } else {
                TwoColumnScreen()
            }
            #endif
        }
        #if os(iOS)
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                NavigationLink("Settings") { PreferencesView() }
                Spacer()
                ExportButton()
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
