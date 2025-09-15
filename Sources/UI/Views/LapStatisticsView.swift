import SwiftUI
import LiveClockCore

public struct LapStatisticsView: View {
    let laps: [Lap]
    
    public init(laps: [Lap]) {
        self.laps = laps
    }
    
    public var body: some View {
        if laps.count > 1 {
            VStack(alignment: .leading, spacing: 12) {
                Text("Statistics", bundle: .module)
                    .font(.headline)
                    .padding(.horizontal)
                
                HStack(spacing: 20) {
                    StatItem(
                        title: String(localized: "Average", bundle: .module),
                        value: TimeFormatter.formatCompact(averageLapTime),
                        color: .blue
                    )
                    
                    StatItem(
                        title: String(localized: "Fastest", bundle: .module),
                        value: TimeFormatter.formatCompact(fastestLapTime ?? 0),
                        color: .green
                    )
                    
                    StatItem(
                        title: String(localized: "Slowest", bundle: .module),
                        value: TimeFormatter.formatCompact(slowestLapTime ?? 0),
                        color: .orange
                    )
                }
                .padding(.horizontal)
                
                Divider()
            }
            .accessibilityElement(children: .combine)
        }
    }
    
    private var averageLapTime: TimeInterval {
        let validLaps = laps.filter { $0.index > 0 }
        guard !validLaps.isEmpty else { return 0 }
        let total = validLaps.reduce(0) { $0 + $1.deltaFromPrev }
        return total / Double(validLaps.count)
    }
    
    private var fastestLapTime: TimeInterval? {
        laps.filter { $0.index > 0 }.map { $0.deltaFromPrev }.min()
    }
    
    private var slowestLapTime: TimeInterval? {
        laps.filter { $0.index > 0 }.map { $0.deltaFromPrev }.max()
    }
}

struct StatItem: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .center, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(value)
                .font(.system(.body, design: .monospaced))
                .foregroundColor(color)
                .bold()
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    struct PreviewContainer: View {
        let laps: [Lap]
        
        init() {
            let stopwatch = Stopwatch()
            stopwatch.start()
            Thread.sleep(forTimeInterval: 0.105)
            stopwatch.lap()
            Thread.sleep(forTimeInterval: 0.118)
            stopwatch.lap()
            Thread.sleep(forTimeInterval: 0.089)
            stopwatch.lap()
            Thread.sleep(forTimeInterval: 0.145)
            stopwatch.lap()
            self.laps = stopwatch.laps
        }
        
        var body: some View {
            LapStatisticsView(laps: laps)
                .padding()
        }
    }
    
    return PreviewContainer()
}
