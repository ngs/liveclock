import SwiftUI
import LiveClockCore

struct ClockView: View {
    @EnvironmentObject var app: AppState

    var body: some View {
        Text(TimeFormatter.hmsms(app.stopwatch.elapsed))
            .font(.system(size: 96, weight: .bold, design: .rounded))
            .minimumScaleFactor(0.2)
            .lineLimit(1)
            .foregroundStyle(app.preferences.textColor)
            .monospacedDigit()
            .padding(.horizontal)
    }
}
