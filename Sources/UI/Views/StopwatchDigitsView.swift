import SwiftUI
import LiveClockCore

struct StopwatchDigitsView: View {
    @EnvironmentObject var app: AppState

    var body: some View {
        let time = TimeFormatter.hmsms(app.stopwatch.elapsed)
        let lapTime = TimeFormatter.hmsms(app.stopwatch.currentLapTime)

        let colonOpacity: Double
        let dotOpacity: Double
        if app.stopwatch.state == .running {
            let timeInterval = app.now.timeIntervalSinceReferenceDate
            let frac = timeInterval - floor(timeInterval)
            let tri = frac < 0.5 ? (frac / 0.5) : ((1.0 - frac) / 0.5)
            colonOpacity = 0.2 + 0.6 * tri
            dotOpacity = colonOpacity  // Dot blinks with the same pattern as colons
        } else {
            colonOpacity = 0.5
            dotOpacity = 0.5
        }

        return VStack(spacing: 4) {
            BlinkingTimeText(time, colonOpacity: colonOpacity, dotOpacity: dotOpacity)
                .font(.system(size: 32, weight: .semibold, design: .monospaced))
                .monospacedDigit()
                .foregroundStyle(app.preferences.textColor)
                .lineLimit(1)
                .minimumScaleFactor(0.2)
                .padding(.horizontal)
                .dynamicTypeSize(...DynamicTypeSize.accessibility2)
                .accessibilityLabel(String(localized: "Elapsed time", bundle: .module))
                .accessibilityValue(voiceOverTime(app.stopwatch.elapsed))
                .accessibilityAddTraits(.updatesFrequently)

                HStack(spacing: 8) {
                    Text("LAP \(app.stopwatch.currentLapNumber)")
                        .font(.system(size: 12, weight: .medium, design: .default))
                        .foregroundStyle(.secondary)
                    
                    BlinkingTimeText(lapTime, colonOpacity: colonOpacity, dotOpacity: dotOpacity)
                        .font(.system(size: 20, weight: .semibold, design: .monospaced))
                        .monospacedDigit()
                        .foregroundStyle(app.preferences.textColor.opacity(0.8))
                }
                .padding(.horizontal)
                .accessibilityLabel(String(localized: "Current lap", bundle: .module))
                .accessibilityValue("Lap \(app.stopwatch.currentLapNumber), \(voiceOverTime(app.stopwatch.currentLapTime))")
                .accessibilityAddTraits(.updatesFrequently)
        }
    }
    
    private func voiceOverTime(_ time: TimeInterval) -> String {
        let totalSeconds = Int(time)
        let hours = totalSeconds / 3_600
        let minutes = (totalSeconds % 3_600) / 60
        let seconds = totalSeconds % 60
        let milliseconds = Int((time.truncatingRemainder(dividingBy: 1)) * 1_000)
        
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

#Preview("Running") {
    let appState = AppState()
    appState.stopwatch.start()
    
    return StopwatchDigitsView()
        .environmentObject(appState)
        .frame(height: 100)
}

#Preview("Paused") {
    let appState = AppState()
    appState.stopwatch.start()
    Thread.sleep(forTimeInterval: 2.5)
    appState.stopwatch.pause()
    
    return StopwatchDigitsView()
        .environmentObject(appState)
        .frame(height: 100)
}

#Preview("Idle") {
    StopwatchDigitsView()
        .environmentObject(AppState())
        .frame(height: 100)
}
