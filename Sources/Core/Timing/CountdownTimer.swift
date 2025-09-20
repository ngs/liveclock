import Foundation
#if canImport(QuartzCore)
import QuartzCore
#endif

public enum CountdownState {
    case idle
    case running
    case paused
    case finished
}

public final class CountdownTimer: ObservableObject {
    @Published public private(set) var state: CountdownState = .idle
    @Published public private(set) var remaining: TimeInterval = 0
    @Published public var duration: TimeInterval = 60

    private var startReference: TimeInterval?
    private var pausedRemaining: TimeInterval = 0

    public init(duration: TimeInterval = 60) {
        self.duration = duration
    }

    public func start() {
        guard state != .running else { return }

        if state == .idle || state == .finished {
            remaining = duration
            pausedRemaining = duration
        }

        startReference = monotonic()
        state = .running
    }

    public func pause() {
        guard state == .running else { return }
        pausedRemaining = remaining
        startReference = nil
        state = .paused
    }

    public func reset() {
        state = .idle
        remaining = 0
        startReference = nil
        pausedRemaining = 0
    }

    public func tick() {
        guard state == .running, let start = startReference else { return }
        let elapsed = monotonic() - start
        remaining = max(0, pausedRemaining - elapsed)

        if remaining <= 0 {
            state = .finished
            startReference = nil
        }
    }

    public func setDuration(_ newDuration: TimeInterval) {
        guard state == .idle else { return }
        duration = max(1, newDuration)
    }

    private func monotonic() -> TimeInterval {
        #if canImport(QuartzCore)
        return CACurrentMediaTime()
        #else
        return ProcessInfo.processInfo.systemUptime
        #endif
    }
}
