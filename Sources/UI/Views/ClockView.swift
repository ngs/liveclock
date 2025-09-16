import SwiftUI
import LiveClockCore

struct ClockView: View {
    @EnvironmentObject var app: AppState

    var body: some View {
        let time = TimeFormatter.timeOfDay(app.now)
        let timeInterval = app.now.timeIntervalSinceReferenceDate
        let frac = timeInterval - floor(timeInterval)
        let tri = frac < 0.5 ? (frac / 0.5) : ((1.0 - frac) / 0.5)
        let colonOpacity = 0.2 + 0.6 * tri
        let dotOpacity = colonOpacity  // Make dot and milliseconds blink with same pattern

        return BlinkingTimeText(time, colonOpacity: colonOpacity, dotOpacity: dotOpacity)
            .font(.system(size: 96, weight: .bold, design: .monospaced))
            .minimumScaleFactor(0.2)
            .lineLimit(1)
            .foregroundStyle(app.preferences.textColor)
            .monospacedDigit()
            .padding(.horizontal)
    }
}

#Preview {
    ClockView()
        .environmentObject(AppState())
        .frame(height: 120)
        .padding()
}
