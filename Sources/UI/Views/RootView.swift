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
        ZStack(alignment: .leading) {
            // Main content
            timerBody
                .disabled(app.showLaps) // prevent interactions when sidebar is open

            // Scrim to dismiss sidebar
            if app.showLaps {
                Color.black.opacity(0.1)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.easeInOut) { app.showLaps = false }
                    }
            }

            // Sidebar content
            if app.showLaps {
                GeometryReader { proxy in
                    // Sidebar container
                    VStack(spacing: 0) {
                        // Header with right-aligned Export button
                        HStack {
                            Spacer()
                            ExportButton()
                                .labelStyle(.iconOnly)
                                .buttonStyle(.borderless)
                                .controlSize(.regular)
                                .font(.title3)
                        }
                        .padding(.horizontal, 12)
                        .padding(.top, 12)
                        .padding(.bottom, 8)

                        // Content with top/bottom padding to avoid clipping
                        LapListView()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)

                        Spacer(minLength: 0)
                    }
                    .frame(
                        width: max(420, min(proxy.size.width * 0.5, 680))
                    )
                    .background(.ultraThinMaterial)
                    .ignoresSafeArea(edges: .vertical)
                    .transition(.move(edge: .leading))
                    .zIndex(1)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            }
        }
        .animation(.easeInOut, value: app.showLaps)
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
#if os(iOS)
        .onChange(of: horizontalSizeClass) { _, _ in
            if app.showLaps {
                withAnimation(.easeInOut) { app.showLaps = false }
            }
        }
        .onChange(of: verticalSizeClass) { _, _ in
            if app.showLaps {
                withAnimation(.easeInOut) { app.showLaps = false }
            }
        }
#endif
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
