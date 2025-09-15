import SwiftUI
import LiveClockCore

struct StopwatchDigitsView: View {
    @EnvironmentObject var app: AppState

    var body: some View {
        Text(TimeFormatter.hmsms(app.stopwatch.elapsed))
            .font(.system(size: 64, weight: .semibold, design: .rounded))
            .monospacedDigit()
            .foregroundStyle(app.preferences.textColor)
            .lineLimit(1)
            .minimumScaleFactor(0.2)
            .padding(.horizontal)
    }
}

