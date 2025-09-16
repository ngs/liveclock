import SwiftUI
import UniformTypeIdentifiers
import LiveClockCore

struct LapsExport: Transferable {
    let laps: [Lap]

    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(exportedContentType: .rtf) { item in
            if let data = ExportFormatter.rtf(from: item.laps) {
                return data
            }
            return ExportFormatter.csv(from: item.laps) // fallback
        }
        .suggestedFileName(defaultFileName())

        DataRepresentation(exportedContentType: .commaSeparatedText) { item in
            ExportFormatter.csv(from: item.laps)
        }
        .suggestedFileName(defaultFileName())
    }

    private static func defaultFileName() -> String {
        let df = DateFormatter()
        df.locale = Locale(identifier: "en_US_POSIX")
        df.timeZone = .current
        df.dateFormat = "yyyyMMdd-HHmmss"
        return "Laps-\(df.string(from: Date()))"
    }
}
