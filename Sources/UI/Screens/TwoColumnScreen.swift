import SwiftUI
import LiveClockCore

struct TwoColumnScreen: View {
    @EnvironmentObject var app: AppState

    var body: some View {
        GeometryReader { proxy in
            let isPortraitLike = proxy.size.height >= proxy.size.width
            let useVStack = (!app.preferences.followDeviceRotation && app.preferences.fixedLayoutOrientation == .portrait) || (app.preferences.followDeviceRotation && isPortraitLike)

            Group {
                if useVStack {
                    VStack(spacing: 16) {
                        ClockView()
                        ControlsView()
                        LapListView()
                    }
                } else {
                    HStack(spacing: 16) {
                        VStack(spacing: 16) {
                            ClockView()
                            ControlsView()
                        }
                        Divider()
                        LapListView()
                    }
                }
            }
            .padding()
        }
    }
}
