import XCTest
@testable import LiveClockCore

final class ExportFormatterTests: XCTestCase {
    // MARK: - CSV Export Tests
    
    func testCSVExportWithNoLaps() {
        let laps: [Lap] = []
        let csvData = ExportFormatter.csv(from: laps)
        let csvString = String(data: csvData, encoding: .utf8)!
        
        let expectedHeader = "Lap,Delta (ms),Delta (h:m:s.ms),Captured (ISO8601)\n"
        XCTAssertEqual(csvString, expectedHeader)
    }
    
    func testCSVExportWithSingleLap() {
        let stopwatch = Stopwatch()
        stopwatch.start()
        Thread.sleep(forTimeInterval: 0.1)
        stopwatch.lap()
        
        let csvData = ExportFormatter.csv(from: stopwatch.laps)
        let csvString = String(data: csvData, encoding: .utf8)!
        
        let lines = csvString.split(separator: "\n")
        XCTAssertEqual(lines.count, 3, "Should have header and two data rows (base lap + actual lap)")
        XCTAssertEqual(lines[0], "Lap,Delta (ms),Delta (h:m:s.ms),Captured (ISO8601)")
        
        // Check base lap (index 0)
        let firstDataRow = lines[1].split(separator: ",")
        XCTAssertEqual(firstDataRow.count, 4, "Data row should have 4 columns")
        XCTAssertEqual(firstDataRow[0], "0", "Base lap should be index 0")
        
        // Check actual lap (index 1)
        let secondDataRow = lines[2].split(separator: ",")
        XCTAssertEqual(secondDataRow[0], "1", "Actual lap should be index 1")
    }
    
    func testCSVExportWithMultipleLaps() {
        let stopwatch = Stopwatch()
        stopwatch.start()
        Thread.sleep(forTimeInterval: 0.05)
        stopwatch.lap()
        Thread.sleep(forTimeInterval: 0.1)
        stopwatch.lap()
        Thread.sleep(forTimeInterval: 0.08)
        stopwatch.lap()
        
        let csvData = ExportFormatter.csv(from: stopwatch.laps)
        let csvString = String(data: csvData, encoding: .utf8)!
        
        let lines = csvString.split(separator: "\n")
        XCTAssertEqual(lines.count, 5, "Should have header and four data rows (base + 3 laps)")
        
        // Check order is reversed (oldest first)
        let firstDataRow = lines[1].split(separator: ",")
        let lastDataRow = lines[4].split(separator: ",")
        XCTAssertEqual(firstDataRow[0], "0", "First row should be lap 0")
        XCTAssertEqual(lastDataRow[0], "3", "Last row should be lap 3")
    }
    
    func testCSVExportDeltaTimeFormatting() {
        let stopwatch = Stopwatch()
        stopwatch.start()
        Thread.sleep(forTimeInterval: 0.123456)
        stopwatch.lap()
        
        let csvData = ExportFormatter.csv(from: stopwatch.laps)
        let csvString = String(data: csvData, encoding: .utf8)!
        
        let lines = csvString.split(separator: "\n")
        // Get the actual lap row (not the base lap)
        let dataRow = lines[2].split(separator: ",")
        
        // Delta in milliseconds should be around 123
        let deltaMs = Int(dataRow[1])!
        XCTAssertGreaterThan(deltaMs, 100)
        XCTAssertLessThan(deltaMs, 300)  // Increased tolerance for CI
        
        // Check h:m:s.ms format exists
        let deltaHMS = dataRow[2]
        XCTAssertTrue(deltaHMS.contains(":"), "Delta HMS should contain colons")
        XCTAssertTrue(deltaHMS.contains("."), "Delta HMS should contain decimal point")
    }
    
    func testCSVExportISO8601DateFormat() {
        let stopwatch = Stopwatch()
        stopwatch.start()
        stopwatch.lap()
        
        let csvData = ExportFormatter.csv(from: stopwatch.laps)
        let csvString = String(data: csvData, encoding: .utf8)!
        
        let lines = csvString.split(separator: "\n")
        let dataRow = lines[1].split(separator: ",")
        let isoDate = String(dataRow[3])
        
        // Verify ISO8601 format
        let iso8601Formatter = ISO8601DateFormatter()
        let parsedDate = iso8601Formatter.date(from: isoDate)
        XCTAssertNotNil(parsedDate, "Should be valid ISO8601 date")
    }
    
    // MARK: - DateFormatterCache Tests
    
    func testDateFormatterCacheTimeOfDay() {
        let date = Date()
        let formatted = DateFormatterCache.shared.timeOfDay(date)
        
        // Should be in HH:mm:ss.SSS format
        let components = formatted.split(separator: ":")
        XCTAssertEqual(components.count, 3, "Should have hour:minute:second format")
        
        let lastComponent = components[2]
        XCTAssertTrue(lastComponent.contains("."), "Should include milliseconds")
        
        // Verify format with regex
        do {
            let regex = try NSRegularExpression(pattern: "^\\d{2}:\\d{2}:\\d{2}\\.\\d{3}$")
            let range = NSRange(location: 0, length: formatted.utf16.count)
            let matches = regex.matches(in: formatted, range: range)
            XCTAssertEqual(matches.count, 1, "Should match HH:mm:ss.SSS format")
        } catch {
            XCTFail("Failed to create regex: \(error)")
        }
    }
    
    func testDateFormatterCacheSingleton() {
        let cache1 = DateFormatterCache.shared
        let cache2 = DateFormatterCache.shared
        XCTAssertIdentical(cache1, cache2, "Should be singleton instance")
    }
    
    // MARK: - Performance Tests
    
    func testCSVExportPerformanceWithManyLaps() {
        let stopwatch = Stopwatch()
        stopwatch.start()
        
        // Create 1000 laps
        for _ in 0..<1_000 {
            Thread.sleep(forTimeInterval: 0.001)
            stopwatch.lap()
        }
        
        measure {
            _ = ExportFormatter.csv(from: stopwatch.laps)
        }
    }
}
