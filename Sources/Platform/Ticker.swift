import Foundation

public protocol TickerDelegate: AnyObject {
    func tickerDidTick()
}

public enum TickerFrequency {
    case displayLink
    case custom(fps: Int)

    var timeInterval: TimeInterval {
        switch self {
        case .displayLink:
            return 1.0 / 60.0
        case .custom(let fps):
            return 1.0 / Double(max(1, min(120, fps)))
        }
    }
}

@MainActor
public final class Ticker {
    public weak var delegate: TickerDelegate?
    public var frequency: TickerFrequency

    public init(frequency: TickerFrequency = .displayLink) {
        self.frequency = frequency
    }

    #if os(iOS) || os(tvOS) || os(visionOS)
    private var link: CADisplayLink?
    private var timer: Timer?
    #else
    private var timer: Timer?
    #endif

    public func start() {
        stop()
        #if os(iOS) || os(tvOS) || os(visionOS)
        if case .displayLink = frequency {
            let link = CADisplayLink(target: DisplayLinkProxy(self), selector: #selector(DisplayLinkProxy.step))
            link.add(to: .main, forMode: .common)
            self.link = link
        } else {
            timer = Timer.scheduledTimer(withTimeInterval: frequency.timeInterval, repeats: true) { [weak self] _ in
                Task { @MainActor in
                    self?.delegate?.tickerDidTick()
                }
            }
        }
        #else
        timer = Timer.scheduledTimer(withTimeInterval: frequency.timeInterval, repeats: true) { [weak self] _ in
            Task { @MainActor in
                  self?.delegate?.tickerDidTick()
            }
        }
        #endif
    }

    public func stop() {
        #if os(iOS) || os(tvOS) || os(visionOS)
        link?.invalidate(); link = nil
        timer?.invalidate(); timer = nil
        #else
        timer?.invalidate(); timer = nil
        #endif
    }
}

#if os(iOS) || os(tvOS) || os(visionOS)
import QuartzCore
private final class DisplayLinkProxy: NSObject {
    weak var owner: Ticker?
    init(_ owner: Ticker) { self.owner = owner }

    @objc
    @MainActor
    func step() {
        owner?.delegate?.tickerDidTick()
    }
}
#endif
