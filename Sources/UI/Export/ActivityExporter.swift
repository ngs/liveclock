import SwiftUI
#if os(iOS)
import UIKit
import LiveClockCore

struct ActivityExporter: UIViewControllerRepresentable {
    let items: [Any]
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }
    func updateUIViewController(_ vc: UIActivityViewController, context: Context) {}
}

func temporaryCSVURL(for laps: [Lap]) -> URL {
    let filename = defaultExportFileName(ext: "csv")
    let url = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(filename)
    let data = ExportFormatter.csv(from: laps)
    try? data.write(to: url, options: .atomic)
    return url
}

private func defaultExportFileName(ext: String) -> String {
    let df = DateFormatter()
    df.locale = Locale(identifier: "en_US_POSIX")
    df.timeZone = .current
    df.dateFormat = "Laps-yyyyMMdd-HHmmss.\(ext)"
    return df.string(from: Date())
}
#endif

