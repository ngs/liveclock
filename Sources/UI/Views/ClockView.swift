import SwiftUI
import LiveClockCore

struct ClockView: View {
    @EnvironmentObject var app: AppState

    var body: some View {
        let time = TimeFormatter.timeOfDay(app.now)
        let t = app.now.timeIntervalSinceReferenceDate
        let frac = t - floor(t)
        let tri = frac < 0.5 ? (frac / 0.5) : ((1.0 - frac) / 0.5)
        let colonOpacity = 0.2 + 0.6 * tri

        return BlinkingTimeText(time, colonOpacity: colonOpacity, dotOpacity: 0.5)
            .font(.system(size: 96, weight: .bold, design: .monospaced))
            .minimumScaleFactor(0.2)
            .lineLimit(1)
            .foregroundStyle(app.preferences.textColor)
            .monospacedDigit()
            .padding(.horizontal)
    }
}
