#if os(macOS)
import SwiftUI
import LiveClockCore
import LiveClockPlatform

public struct MenuBarView: View {
    @EnvironmentObject var appState: AppState
    @State private var ticker: Ticker?
    @Environment(\.openWindow)
    private var openWindow

    public init() {}

    public var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button {
                    openWindow(id: "liveclock.main")
                    NSApp.activate(ignoringOtherApps: true)
                } label: {
                    Image(systemName: "macwindow")
                        .imageScale(.medium)
                        .foregroundColor(.primary)
                }
                .buttonStyle(.plain)
                .help(String(localized: "Show LiveClock Window", bundle: .module))

                Spacer()

                Menu {
                    Button(String(localized: "About LiveClock", bundle: .module)) {
                        if let url = URL(string: String(localized: "https://liveclock.ngs.io", bundle: .module)) {
                            NSWorkspace.shared.open(url)
                        }
                    }

                    Divider()

                    Button(String(localized: "Quit LiveClock", bundle: .module)) {
                        NSApplication.shared.terminate(nil)
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .imageScale(.medium)
                        .foregroundColor(.primary)
                }
                .buttonStyle(.plain)
                .menuStyle(.borderlessButton)
                .fixedSize()
                .help(String(localized: "More Options", bundle: .module))
            }
            .padding(.horizontal)
            .padding(.top, 12)
            .padding(.bottom, 8)

            VStack(spacing: 16) {
                ClockView()
                    .environmentObject(appState)

                StopwatchDigitsView()
                    .environmentObject(appState)

                ControlsView()
                    .environmentObject(appState)
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .frame(width: 320)
        .onAppear {
            let newTicker = Ticker()
            newTicker.delegate = appState
            newTicker.start()
            ticker = newTicker
        }
        .onDisappear {
            ticker?.stop()
            ticker = nil
        }
    }
}
#endif
