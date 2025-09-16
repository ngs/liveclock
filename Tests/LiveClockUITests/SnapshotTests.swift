import XCTest
import SwiftUI
@testable import LiveClockUI
@testable import LiveClockCore
#if os(iOS)
import UIKit
#endif

final class SnapshotTests: XCTestCase {
    
    func testStopwatchDigitsView() {
        let appState = AppState()
        appState.stopwatch.start()
        
        let view = StopwatchDigitsView()
            .environmentObject(appState)
            .frame(width: 390, height: 200)
        
        assertSnapshot(matching: view, as: .image)
    }
    
    func testControlsViewIdle() {
        let appState = AppState()
        
        let view = ControlsView()
            .environmentObject(appState)
            .frame(width: 390, height: 100)
        
        assertSnapshot(matching: view, as: .image)
    }
    
    func testControlsViewRunning() {
        let appState = AppState()
        appState.stopwatch.start()
        
        let view = ControlsView()
            .environmentObject(appState)
            .frame(width: 390, height: 100)
        
        assertSnapshot(matching: view, as: .image)
    }
    
    func testControlsViewPaused() {
        let appState = AppState()
        appState.stopwatch.start()
        appState.stopwatch.pause()
        
        let view = ControlsView()
            .environmentObject(appState)
            .frame(width: 390, height: 100)
        
        assertSnapshot(matching: view, as: .image)
    }
    
    func testLapListViewEmpty() {
        let appState = AppState()
        
        let view = LapListView()
            .environmentObject(appState)
            .frame(width: 390, height: 400)
        
        assertSnapshot(matching: view, as: .image)
    }
    
    func testLapListViewWithLaps() {
        let appState = AppState()
        appState.stopwatch.start()
        Thread.sleep(forTimeInterval: 0.1)
        appState.stopwatch.lap()
        Thread.sleep(forTimeInterval: 0.15)
        appState.stopwatch.lap()
        Thread.sleep(forTimeInterval: 0.2)
        appState.stopwatch.lap()
        
        let view = LapListView()
            .environmentObject(appState)
            .frame(width: 390, height: 400)
        
        assertSnapshot(matching: view, as: .image)
    }
    
    func testSingleColumnScreen() {
        let appState = AppState()
        
        let view = SingleColumnScreen()
            .environmentObject(appState)
            .frame(width: 390, height: 844)
        
        assertSnapshot(matching: view, as: .image)
    }
    
    func testTwoColumnScreen() {
        let appState = AppState()
        appState.stopwatch.start()
        
        let view = TwoColumnScreen()
            .environmentObject(appState)
            .frame(width: 834, height: 1194)
        
        assertSnapshot(matching: view, as: .image)
    }
}

#if os(iOS)
private func assertSnapshot<V: View>(
    matching view: V,
    as format: SnapshotFormat,
    file: StaticString = #file,
    testName: String = #function,
    line: UInt = #line
) {
    let controller = UIHostingController(rootView: view)
    controller.view.layoutIfNeeded()
    
    let renderer = UIGraphicsImageRenderer(bounds: controller.view.bounds)
    let image = renderer.image { context in
        controller.view.layer.render(in: context.cgContext)
    }
    
    let snapshotDirectory = URL(fileURLWithPath: String(describing: file))
        .deletingLastPathComponent()
        .appendingPathComponent("__Snapshots__")
        .appendingPathComponent(URL(fileURLWithPath: String(describing: file)).lastPathComponent)
    
    try? FileManager.default.createDirectory(at: snapshotDirectory, withIntermediateDirectories: true)
    
    let snapshotPath = snapshotDirectory
        .appendingPathComponent("\(testName).png")
    
    if FileManager.default.fileExists(atPath: snapshotPath.path) {
        guard let referenceImage = UIImage(contentsOfFile: snapshotPath.path),
              let referenceData = referenceImage.pngData(),
              let newData = image.pngData() else {
            XCTFail("Failed to compare images", file: file, line: line)
            return
        }
        
        if referenceData != newData {
            let failurePath = snapshotPath
                .deletingPathExtension()
                .appendingPathExtension("failure.png")
            try? newData.write(to: failurePath)
            
            XCTFail("Snapshot does not match reference. New snapshot saved to: \(failurePath.path)", file: file, line: line)
        }
    } else {
        guard let data = image.pngData() else {
            XCTFail("Failed to generate snapshot", file: file, line: line)
            return
        }
        
        try? data.write(to: snapshotPath)
        XCTFail("Reference snapshot not found. New snapshot saved to: \(snapshotPath.path)", file: file, line: line)
    }
}
#else
private func assertSnapshot<V: View>(
    matching view: V,
    as format: SnapshotFormat,
    file: StaticString = #file,
    testName: String = #function,
    line: UInt = #line
) {
    // Snapshot testing not available on macOS in this implementation
    XCTSkip("Snapshot testing not available on this platform")
}
#endif

private enum SnapshotFormat {
    case image
}
