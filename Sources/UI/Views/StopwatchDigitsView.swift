import SwiftUI
import LiveClockCore

struct StopwatchDigitsView: View {
    @EnvironmentObject var app: AppState

    var body: some View {
        let time = TimeFormatter.hmsms(app.stopwatch.elapsed)
        let colonOpacity: Double
        if app.stopwatch.state == .running {
            let t = app.now.timeIntervalSinceReferenceDate
            let frac = t - floor(t)
            let tri = frac < 0.5 ? (frac / 0.5) : ((1.0 - frac) / 0.5)
            colonOpacity = 0.2 + 0.6 * tri
        } else {
            colonOpacity = 0.8
        }

        return BlinkingTimeText(time, colonOpacity: colonOpacity, dotOpacity: 0.8)
            .font(.system(size: 64, weight: .semibold, design: .monospaced))
            .monospacedDigit()
            .foregroundStyle(app.preferences.textColor)
            .lineLimit(1)
            .minimumScaleFactor(0.2)
            .padding(.horizontal)
    }
}
