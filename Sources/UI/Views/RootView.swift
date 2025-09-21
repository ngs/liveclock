import SwiftUI
import LiveClockCore
import LiveClockPlatform

public struct RootView: View {
    @EnvironmentObject var app: AppState
    @State private var ticker: Ticker?

    @Environment(\.horizontalSizeClass)
    private var horizontalSizeClass

    public init() {}

    public var body: some View {
        SplitViewScreen()
#if os(iOS)
            .statusBarHidden(true)
            .persistentSystemOverlays(.hidden)
            .sheet(isPresented: Binding(
                get: {
                    horizontalSizeClass == .compact && app.showSettings
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
                }
            }
            .sheet(isPresented: Binding(
                get: {
                    horizontalSizeClass == .compact && app.showExporter
                },
                set: { newValue in
                    app.showExporter = newValue
                }
            )) {
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
            .onGeometryChange(for: CGSize.self) {
                $0.size
            } action: {_, _ in
                app.showExporter = false
                app.showSettings = false
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
