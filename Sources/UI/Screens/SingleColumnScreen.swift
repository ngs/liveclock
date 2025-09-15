import SwiftUI
import LiveClockCore

struct SingleColumnScreen: View {
    @EnvironmentObject var app: AppState

    var body: some View {
        VStack(spacing: 24) {
            ClockView()
            StopwatchDigitsView()
            ControlsView(showsLapButton: true)
            Divider()
            LapListView()
        }
        .padding()
    }
}
