import Foundation

public protocol TickerDelegate: AnyObject {
    func tickerDidTick()
}

public final class Ticker {
    public weak var delegate: TickerDelegate?
    public init() {}

    #if os(iOS) || os(tvOS) || os(visionOS)
    private var link: CADisplayLink?
    #else
    private var timer: Timer?
    #endif

    public func start() {
        stop()
        #if os(iOS) || os(tvOS) || os(visionOS)
        let link = CADisplayLink(target: DisplayLinkProxy(self), selector: #selector(DisplayLinkProxy.step))
        link.add(to: .main, forMode: .common)
        self.link = link
        #else
        timer = Timer.scheduledTimer(withTimeInterval: 1.0/60.0, repeats: true) { [weak self] _ in
            self?.delegate?.tickerDidTick()
        }
        #endif
    }

    public func stop() {
        #if os(iOS) || os(tvOS) || os(visionOS)
        link?.invalidate(); link = nil
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
    @objc func step() { owner?.delegate?.tickerDidTick() }
}
#endif
