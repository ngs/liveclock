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
            .dynamicTypeSize(...DynamicTypeSize.accessibility2)
            .accessibilityLabel("Elapsed time")
            .accessibilityValue(voiceOverTime(app.stopwatch.elapsed))
            .accessibilityAddTraits(.updatesFrequently)
    }
    
    private func voiceOverTime(_ time: TimeInterval) -> String {
        let totalSeconds = Int(time)
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60
        let milliseconds = Int((time.truncatingRemainder(dividingBy: 1)) * 1000)
        
        var components: [String] = []
        if hours > 0 {
            components.append("\(hours) \(hours == 1 ? "hour" : "hours")")
        }
        if minutes > 0 {
            components.append("\(minutes) \(minutes == 1 ? "minute" : "minutes")")
        }
        if seconds > 0 || components.isEmpty {
            components.append("\(seconds) \(seconds == 1 ? "second" : "seconds")")
        }
        if milliseconds > 0 {
            components.append("\(milliseconds) milliseconds")
        }
        
        return components.joined(separator: ", ")
    }
}
