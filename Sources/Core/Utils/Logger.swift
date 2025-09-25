import Logging

public enum LiveClockLogger {
    public static let app = Logger(label: "io.ngs.LiveClock.App")
    public static let platform = Logger(label: "io.ngs.LiveClock.Platform")
    public static let ui = Logger(label: "io.ngs.LiveClock.UI")
    public static let core = Logger(label: "io.ngs.LiveClock.Core")
}
