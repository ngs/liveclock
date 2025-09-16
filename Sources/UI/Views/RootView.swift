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
            if UIDevice.current.userInterfaceIdiom == .phone && (UIDevice.current.orientation == .portrait || UIDevice.current.orientation == .portraitUpsideDown) {
                SingleColumnScreen()
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Button {
                                app.showSettings = true
                            } label: {
                                Label(String(localized: "Settings", bundle: .module), systemImage: "gearshape")
                            }
                        }
                        ToolbarItem(placement: .topBarTrailing) {
                            ExportButton()
                        }
                    }
            } else {
                SplitViewScreen()
            }
#else
            SplitViewScreen()
#endif
        }
#if os(iOS)
        .statusBarHidden(true)
        .persistentSystemOverlays(.hidden)
        .sheet(isPresented: $app.showSettings) {
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
            }
        }
        .sheet(isPresented: $app.showExporter) {
            ActivityExporter(items: [temporaryCSVURL(for: app.stopwatch.laps)])
        }
#endif
        .onAppear {
            let newTicker = Ticker()
            newTicker.delegate = app
            newTicker.start()
            ticker = newTicker
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
