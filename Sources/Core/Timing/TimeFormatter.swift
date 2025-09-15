import Foundation

public enum TimeFormatter {
    public static func format(_ seconds: TimeInterval) -> String {
        return hmsms(seconds)
    }
    
    public static func formatCompact(_ seconds: TimeInterval) -> String {
        guard seconds >= 0 else { return "0.000" }
        
        let totalMilliseconds = Int((seconds * 1000.0).rounded(.down))
        let ms = totalMilliseconds % 1000
        let totalSeconds = totalMilliseconds / 1000
        let s = totalSeconds % 60
        let totalMinutes = totalSeconds / 60
        let m = totalMinutes % 60
        let h = totalMinutes / 60
        
        if h > 0 {
            return String(format: "%d:%02d:%02d.%03d", h, m, s, ms)
        } else if m > 0 {
            return String(format: "%d:%02d.%03d", m, s, ms)
        } else {
            return String(format: "%d.%03d", s, ms)
        }
    }
    
    public static func hmsms(_ seconds: TimeInterval) -> String {
        guard seconds >= 0 else { return "00:00:00.000" }
        
        let maxSeconds: TimeInterval = 359999.999
        let clampedSeconds = min(seconds, maxSeconds)
        
        let totalMilliseconds = Int((clampedSeconds * 1000.0).rounded(.down))
        let ms = totalMilliseconds % 1000
        let totalSeconds = totalMilliseconds / 1000
        let s = totalSeconds % 60
        let totalMinutes = totalSeconds / 60
        let m = totalMinutes % 60
        let h = min(totalMinutes / 60, 99)
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
