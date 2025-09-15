import SwiftUI
import LiveClockCore
import LiveClockPlatform
#if os(iOS)
import UIKit
#endif

public struct RootView: View {
    @EnvironmentObject var app: AppState
    @State private var ticker: Ticker?
    #if os(iOS)
    @State private var showSettings = false
    #endif

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
        .navigationBarHidden(true)
        .statusBarHidden(true)
        .persistentSystemOverlays(.hidden)
        .toolbar(.hidden, for: .navigationBar)
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                Button {
                    showSettings = true
                } label: {
                    Label(String(localized: "Settings", bundle: .module), systemImage: "gearshape")
                }
                Spacer()
                ExportButton()
            }
        }
        .toolbarBackground(.visible, for: .bottomBar)
        .sheet(isPresented: $showSettings) {
            PreferencesView()
                .environmentObject(app)
                .presentationDetents([.medium, .large])
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

#Preview {
    RootView()
        .environmentObject(AppState())
}
