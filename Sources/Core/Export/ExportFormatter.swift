import Foundation

public enum ExportFormatter {
    public static func csv(from laps: [Lap], timeZone: TimeZone = .current) -> Data {
        var rows: [String] = []
        rows.append("Lap,Delta (ms),Delta (h:m:s.ms),Captured (ISO8601)")
        let iso = ISO8601DateFormatter()
        iso.formatOptions = [.withInternetDateTime, .withTimeZone, .withColonSeparatorInTimeZone]
        iso.timeZone = timeZone
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
