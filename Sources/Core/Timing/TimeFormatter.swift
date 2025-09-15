import Foundation

enum TimeFormatter {
    static func hmsms(_ seconds: TimeInterval) -> String {
        let totalMilliseconds = Int((seconds * 1000.0).rounded(.down))
        let ms = totalMilliseconds % 1000
        let totalSeconds = totalMilliseconds / 1000
        let s = totalSeconds % 60
        let totalMinutes = totalSeconds / 60
        let m = totalMinutes % 60
        let h = totalMinutes / 60
        return String(format: "%02d:%02d:%02d.%03d", h, m, s, ms)
    }
}

