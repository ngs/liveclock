import SwiftUI
#if os(iOS) || os(visionOS)
import UIKit
import LiveClockCore
import Logging

struct ActivityExporter: UIViewControllerRepresentable {
    let items: [Any]
    func makeUIViewController(context _: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }
    func updateUIViewController(_: UIActivityViewController, context _: Context) {}
}

func temporaryCSVURL(for laps: [Lap]) -> URL {
    let filename = defaultExportFileName(ext: "csv")
    let url = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(filename)
    let data = ExportFormatter.csv(from: laps)
    do {
        try data.write(to: url, options: .atomic)
        LiveClockLogger.ui.debug("Created temporary CSV file: \(url.lastPathComponent)")
    } catch {
        LiveClockLogger.ui.error("Failed to create temporary CSV file: \(error)")
    }
    return url
}

private func defaultExportFileName(ext: String) -> String {
    let df = DateFormatter()
    df.locale = Locale(identifier: "en_US_POSIX")
    df.timeZone = .current
    df.dateFormat = "yyyyMMdd-HHmmss"
    return "Laps-\(df.string(from: Date())).\(ext)"
}
#endif
