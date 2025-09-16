import Foundation
#if os(macOS)
import AppKit
#else
import UIKit
#endif

public enum ExportFormatter {
    public static func csv(from laps: [Lap]) -> Data {
        var rows: [String] = []
        rows.append("Lap,Delta (ms),Delta (h:m:s.ms),Captured (ISO8601)")
        let iso = ISO8601DateFormatter()
        iso.formatOptions = [.withInternetDateTime, .withTimeZone, .withColonSeparatorInTimeZone]
        for lap in laps.reversed() { // oldest first for reading order
            let deltaMs = Int((lap.deltaFromPrev * 1000.0).rounded())
            let deltaHMS = TimeFormatter.hmsms(lap.deltaFromPrev)
            let isoStr = iso.string(from: lap.capturedDate)
            rows.append("\(lap.index),\(deltaMs),\(deltaHMS),\(isoStr)")
        }
        let csv = rows.joined(separator: "\n") + "\n"
        return Data(csv.utf8)
    }

    public static func rtf(from laps: [Lap]) -> Data? {
        // Simple tabular rich text using tab stops and monospaced digits.
        let header = "Lap\tDelta\tCaptured\n"
        let body = laps.reversed().map { lap in
            "#\(lap.index)\t\(TimeFormatter.hmsms(lap.deltaFromPrev))\t\(DateFormatterCache.shared.timeOfDay(lap.capturedDate))"
        }.joined(separator: "\n") + "\n"
        let full = header + body

        let style = NSMutableParagraphStyle()
        style.tabStops = [
            NSTextTab(textAlignment: .left, location: 50, options: [:]),
            NSTextTab(textAlignment: .left, location: 200, options: [:]),
            NSTextTab(textAlignment: .left, location: 360, options: [:])
        ]
        style.defaultTabInterval = 120

        let attrs: [NSAttributedString.Key: Any] = [
            .font: monospacedFont(),
            .paragraphStyle: style
        ]
        let attr = NSAttributedString(string: full, attributes: attrs)
        let range = NSRange(location: 0, length: attr.length)
        let options: [NSAttributedString.DocumentAttributeKey: Any] = [
            .documentType: NSAttributedString.DocumentType.rtf
        ]
        return try? attr.data(from: range, documentAttributes: options)
    }

    private static func monospacedFont() -> Any {
        #if os(macOS)
        return NSFont.monospacedSystemFont(ofSize: 12, weight: .regular)
        #else
        return UIFont.monospacedSystemFont(ofSize: 12, weight: .regular)
        #endif
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
