import SwiftUI
import LiveClockCore

struct TwoColumnScreen: View {
    var body: some View {
        HStack(spacing: 16) {
            VStack(spacing: 16) {
                ClockView()
                StopwatchDigitsView()
                ControlsView(showsLapButton: true)
            }
            Divider()
            LapListView()
        }
        .padding()
    }
}
