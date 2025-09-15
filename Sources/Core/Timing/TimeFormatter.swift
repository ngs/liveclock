import Foundation

public enum TimeFormatter {
    public static func hmsms(_ seconds: TimeInterval) -> String {
        let totalMilliseconds = Int((seconds * 1000.0).rounded(.down))
        let ms = totalMilliseconds % 1000
        let totalSeconds = totalMilliseconds / 1000
        let s = totalSeconds % 60
        let totalMinutes = totalSeconds / 60
        let m = totalMinutes % 60
        let h = totalMinutes / 60
        return String(format: "%02d:%02d:%02d.%03d", h, m, s, ms)
    }

    public static func timeOfDay(_ date: Date) -> String {
        // Local time using Calendar.current (respects user time zone and DST)
        let cal = Calendar.current
        let comps = cal.dateComponents([.hour, .minute, .second, .nanosecond], from: date)
        let h = comps.hour ?? 0
        let m = comps.minute ?? 0
        let s = comps.second ?? 0
        let ns = comps.nanosecond ?? 0
        let ms = ns / 1_000_000
        return String(format: "%02d:%02d:%02d.%03d", h, m, s, ms)
    }
}
