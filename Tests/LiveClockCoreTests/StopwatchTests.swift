import XCTest
@testable import LiveClockCore

final class StopwatchTests: XCTestCase {
    private var stopwatch: Stopwatch!
    
    override func setUp() {
        super.setUp()
        stopwatch = Stopwatch()
    }
    
    override func tearDown() {
        stopwatch = nil
        super.tearDown()
    }
    
    func testInitialState() {
        XCTAssertEqual(stopwatch.state, .idle)
        XCTAssertEqual(stopwatch.elapsed, 0)
        XCTAssertTrue(stopwatch.laps.isEmpty)
    }
    
    func testStart() {
        stopwatch.start()
        XCTAssertEqual(stopwatch.state, .running)
        XCTAssertEqual(stopwatch.laps.count, 1)
        XCTAssertEqual(stopwatch.laps.first?.index, 0)
        XCTAssertEqual(stopwatch.laps.first?.atTotal, 0)
    }
    
    func testPause() {
        stopwatch.start()
        Thread.sleep(forTimeInterval: 0.1)
        stopwatch.pause()
        
        XCTAssertEqual(stopwatch.state, .paused)
        let elapsed1 = stopwatch.elapsed
        
        Thread.sleep(forTimeInterval: 0.1)
        let elapsed2 = stopwatch.elapsed
        
        XCTAssertEqual(elapsed1, elapsed2, "Elapsed time should not change when paused")
    }
    
    func testResume() {
        stopwatch.start()
        Thread.sleep(forTimeInterval: 0.1)
        stopwatch.pause()
        
        let pausedElapsed = stopwatch.elapsed
        
        stopwatch.start()
        XCTAssertEqual(stopwatch.state, .running)
        
        Thread.sleep(forTimeInterval: 0.1)
        stopwatch.tick()
        
        XCTAssertGreaterThan(stopwatch.elapsed, pausedElapsed)
    }
    
    func testReset() {
        stopwatch.start()
        Thread.sleep(forTimeInterval: 0.1)
        stopwatch.lap()
        stopwatch.pause()
        stopwatch.reset()
        
        XCTAssertEqual(stopwatch.state, .idle)
        XCTAssertEqual(stopwatch.elapsed, 0)
        XCTAssertTrue(stopwatch.laps.isEmpty)
    }
    
    func testLap() {
        stopwatch.start()
        
        Thread.sleep(forTimeInterval: 0.1)
        stopwatch.lap()
        XCTAssertEqual(stopwatch.laps.count, 2)
        XCTAssertEqual(stopwatch.laps.first?.index, 1)
        
        Thread.sleep(forTimeInterval: 0.1)
        stopwatch.lap()
        XCTAssertEqual(stopwatch.laps.count, 3)
        XCTAssertEqual(stopwatch.laps.first?.index, 2)
        
        let secondLap = stopwatch.laps[0]
        let firstLap = stopwatch.laps[1]
        XCTAssertGreaterThan(secondLap.atTotal, firstLap.atTotal)
    }
    
    func testLapOnlyWhenRunning() {
        stopwatch.lap()
        XCTAssertTrue(stopwatch.laps.isEmpty)
        
        stopwatch.start()
        stopwatch.pause()
        stopwatch.lap()
        XCTAssertEqual(stopwatch.laps.count, 1)
    }
    
    func testTick() {
        stopwatch.start()
        let initial = stopwatch.elapsed
        
        Thread.sleep(forTimeInterval: 0.05)
        stopwatch.tick()
        
        XCTAssertGreaterThan(stopwatch.elapsed, initial)
    }
    
    func testTickOnlyWhenRunning() {
        let initial = stopwatch.elapsed
        stopwatch.tick()
        XCTAssertEqual(stopwatch.elapsed, initial)
        
        stopwatch.start()
        stopwatch.pause()
        let paused = stopwatch.elapsed
        stopwatch.tick()
        XCTAssertEqual(stopwatch.elapsed, paused)
    }
    
    func testMultipleStartCalls() {
        stopwatch.start()
        let lapsCount = stopwatch.laps.count
        
        stopwatch.start()
        XCTAssertEqual(stopwatch.laps.count, lapsCount, "Multiple start calls should not affect laps")
    }
    
    func testLapDeltaCalculation() {
        stopwatch.start()
        
        Thread.sleep(forTimeInterval: 0.1)
        stopwatch.lap()
        
        Thread.sleep(forTimeInterval: 0.15)
        stopwatch.lap()
        
        let latestLap = stopwatch.laps.first!
        XCTAssertGreaterThan(latestLap.deltaFromPrev, 0.14)
        XCTAssertLessThan(latestLap.deltaFromPrev, 0.2)
    }
}
