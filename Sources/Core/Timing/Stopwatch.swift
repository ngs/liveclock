import Foundation
#if canImport(QuartzCore)
import QuartzCore
#endif

public enum StopwatchState {
    case idle
    case running
    case paused
}

public struct Lap: Identifiable, Hashable {
    public let id: UUID
    public let index: Int
    public let atTotal: TimeInterval
    public let deltaFromPrev: TimeInterval
    public let capturedDate: Date
}

public final class Stopwatch: ObservableObject {
    @Published public private(set) var state: StopwatchState = .idle
    @Published public private(set) var elapsed: TimeInterval = 0
    @Published public private(set) var laps: [Lap] = []
    @Published public private(set) var currentLapTime: TimeInterval = 0

    private var startReference: TimeInterval? // monotonic base
    private var accumulated: TimeInterval = 0
    private var lastLapReference: TimeInterval?
    
    public init() {}

    public func start() {
        guard state != .running else { return }
        let now = monotonic()
        if state == .idle {
            laps.removeAll()
            accumulated = 0
            currentLapTime = 0
            lastLapReference = now
            let baseLap = Lap(
                id: UUID(),
                index: 0,
                atTotal: 0,
                deltaFromPrev: 0,
                capturedDate: Date()
            )
            laps.insert(baseLap, at: 0)
        }
        startReference = now
        state = .running
    }

    public func pause() {
        guard state == .running, let start = startReference else { return }
        let now = monotonic()
        accumulated += now - start
        startReference = nil
        state = .paused
        elapsed = accumulated

        if let lastLap = lastLapReference {
            currentLapTime = now - lastLap
        } else {
            currentLapTime = elapsed
        }
    }

    public func reset() {
        state = .idle
        elapsed = 0
        currentLapTime = 0
        startReference = nil
        accumulated = 0
        lastLapReference = nil
        laps.removeAll()
    }

    public func lap() {
        guard state == .running else { return }
        let now = monotonic()
        let total = currentElapsed(now: now)
        let delta: TimeInterval
        if let lastLap = lastLapReference {
            delta = now - lastLap
        } else if let start = startReference {
            delta = now - start
        } else {
            delta = total
        }
        lastLapReference = now
        let index = (laps.first?.index ?? 0) + 1
        let lap = Lap(id: UUID(), index: index, atTotal: total, deltaFromPrev: delta, capturedDate: Date())
        laps.insert(lap, at: 0)
        currentLapTime = 0
    }

    public func tick() {
        guard state == .running else { return }
        let now = monotonic()
        elapsed = currentElapsed(now: now)

        if let lastLap = lastLapReference {
            currentLapTime = now - lastLap
        } else if let start = startReference {
            currentLapTime = now - start + accumulated
        } else {
            currentLapTime = elapsed
        }
    }
    
    public var currentLapNumber: Int { (laps.first?.index ?? 0) + 1 }

    private func currentElapsed(now: TimeInterval) -> TimeInterval {
        guard let start = startReference else { return accumulated }
        return accumulated + (now - start)
    }

    private func monotonic() -> TimeInterval {
        #if canImport(QuartzCore)
        return CACurrentMediaTime()
        #else
        return ProcessInfo.processInfo.systemUptime
        #endif
    }
}
