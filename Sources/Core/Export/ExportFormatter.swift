import Foundation

public enum ExportFormatter {
    public static func csv(from laps: [Lap]) -> Data {
        var rows: [String] = []
        rows.append("Lap,Delta (ms),Delta (h:m:s.ms),Captured (ISO8601)")
        let iso = ISO8601DateFormatter()
        iso.formatOptions = [.withInternetDateTime, .withTimeZone, .withColonSeparatorInTimeZone]
        for lap in laps.reversed() { // oldest first for reading order
            let deltaMs = Int((lap.deltaFromPrev * 1_000.0).rounded())
            let deltaHMS = TimeFormatter.hmsms(lap.deltaFromPrev)
            let isoStr = iso.string(from: lap.capturedDate)
            rows.append("\(lap.index),\(deltaMs),\(deltaHMS),\(isoStr)")
        }
        let csv = rows.joined(separator: "\n") + "\n"
        return Data(csv.utf8)
    }
}

final class DateFormatterCache {
    static let shared = DateFormatterCache()
    private let time: DateFormatter
    private init() {
        let df = DateFormatter()
        df.locale = Locale.current
        df.timeZone = .current
        df.dateFormat = "HH:mm:ss.SSS"
        self.time = df
    }
    func timeOfDay(_ date: Date) -> String { time.string(from: date) }
}
