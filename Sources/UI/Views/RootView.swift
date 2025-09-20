import SwiftUI
import LiveClockCore
import LiveClockPlatform

public struct RootView: View {
    @EnvironmentObject var app: AppState
    @State private var ticker: Ticker?

    @Environment(\.horizontalSizeClass)
    private var horizontalSizeClass
    @Environment(\.verticalSizeClass)
    private var verticalSizeClass

    public init() {}

    private var shouldUseCompactLayout: Bool {
        #if os(iOS)
        // Use SingleColumnScreen only when width is compact and height is regular (typically iPhone portrait)
        // This ensures SplitViewScreen is used for landscape orientations and iPads
        return horizontalSizeClass == .compact && verticalSizeClass == .regular
        #else
        return false
        #endif
    }
    
    private var timerBody: some View {
        if shouldUseCompactLayout {
            return AnyView(SingleColumnScreen())
        }

        return AnyView(SplitViewScreen())
    }

    public var body: some View {
        SplitViewScreen()
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
