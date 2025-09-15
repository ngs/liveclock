import Foundation
#if canImport(QuartzCore)
import QuartzCore
#endif

enum StopwatchState {
    case idle
    case running
    case paused
}

struct Lap: Identifiable, Hashable {
    let id: UUID
    let index: Int
    let atTotal: TimeInterval
    let deltaFromPrev: TimeInterval
}

final class Stopwatch: ObservableObject {
    @Published private(set) var state: StopwatchState = .idle
    @Published private(set) var elapsed: TimeInterval = 0
    @Published private(set) var laps: [Lap] = []

    private var startReference: TimeInterval? // monotonic base
    private var accumulated: TimeInterval = 0
    private var lastLapReference: TimeInterval?

    func start() {
        guard state != .running else { return }
        let now = monotonic()
        if state == .idle {
            laps.removeAll()
            accumulated = 0
            lastLapReference = now
        }
        startReference = now
        state = .running
    }

    func pause() {
        guard state == .running, let start = startReference else { return }
        let now = monotonic()
        accumulated += now - start
        startReference = nil
        state = .paused
        elapsed = accumulated
    }

    func reset() {
        state = .idle
        elapsed = 0
        startReference = nil
        accumulated = 0
        lastLapReference = nil
        laps.removeAll()
    }

    func lap() {
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
        let lap = Lap(id: UUID(), index: index, atTotal: total, deltaFromPrev: delta)
        laps.insert(lap, at: 0)
    }

    func tick() {
        guard state == .running else { return }
        elapsed = currentElapsed(now: monotonic())
    }

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
