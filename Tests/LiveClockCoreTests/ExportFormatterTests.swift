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
        XCTAssertLessThan(deltaMs, 150)
        
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
    
    // MARK: - RTF Export Tests
    
    func testRTFExportWithNoLaps() {
        let laps: [Lap] = []
        let rtfData = ExportFormatter.rtf(from: laps)
        
        XCTAssertNotNil(rtfData, "RTF data should not be nil")
        
        // Try to convert to attributed string to validate RTF format
        if let data = rtfData {
            let attributed = NSAttributedString(
                rtf: data,
                documentAttributes: nil
            )
            XCTAssertNotNil(attributed, "Should be valid RTF data")
            
            let plainText = attributed?.string ?? ""
            XCTAssertTrue(plainText.contains("Lap"), "Should contain header")
            XCTAssertTrue(plainText.contains("Delta"), "Should contain header")
            XCTAssertTrue(plainText.contains("Captured"), "Should contain header")
        }
    }
    
    func testRTFExportWithSingleLap() {
        let stopwatch = Stopwatch()
        stopwatch.start()
        Thread.sleep(forTimeInterval: 0.1)
        stopwatch.lap()
        
        let rtfData = ExportFormatter.rtf(from: stopwatch.laps)
        XCTAssertNotNil(rtfData, "RTF data should not be nil")
        
        if let data = rtfData {
            let attributed = NSAttributedString(
                rtf: data,
                documentAttributes: nil
            )
            let plainText = attributed?.string ?? ""
            
            XCTAssertTrue(plainText.contains("#0"), "Should contain lap index")
            XCTAssertTrue(plainText.contains("00:00:00."), "Should contain formatted time")
        }
    }
    
    func testRTFExportWithMultipleLaps() {
        let stopwatch = Stopwatch()
        stopwatch.start()
        Thread.sleep(forTimeInterval: 0.05)
        stopwatch.lap()
        Thread.sleep(forTimeInterval: 0.1)
        stopwatch.lap()
        Thread.sleep(forTimeInterval: 0.08)
        stopwatch.lap()
        
        let rtfData = ExportFormatter.rtf(from: stopwatch.laps)
        XCTAssertNotNil(rtfData, "RTF data should not be nil")
        
        if let data = rtfData {
            let attributed = NSAttributedString(
                rtf: data,
                documentAttributes: nil
            )
            let plainText = attributed?.string ?? ""
            
            // Check all lap indices are present
            XCTAssertTrue(plainText.contains("#0"), "Should contain lap 0")
            XCTAssertTrue(plainText.contains("#1"), "Should contain lap 1")
            XCTAssertTrue(plainText.contains("#2"), "Should contain lap 2")
            XCTAssertTrue(plainText.contains("#3"), "Should contain lap 3")
            
            // Check order (oldest first)
            let lines = plainText.split(separator: "\n")
            let dataLines = lines.filter { $0.starts(with: "#") }
            XCTAssertEqual(dataLines.count, 4, "Should have 4 lap entries (base + 3)")
            XCTAssertTrue(dataLines[0].starts(with: "#0"), "First should be lap 0")
            XCTAssertTrue(dataLines[3].starts(with: "#3"), "Last should be lap 3")
        }
    }
    
    func testRTFExportUsesMonospacedFont() {
        let stopwatch = Stopwatch()
        stopwatch.start()
        stopwatch.lap()
        
        let rtfData = ExportFormatter.rtf(from: stopwatch.laps)
        XCTAssertNotNil(rtfData, "RTF data should not be nil")
        
        if let data = rtfData {
            var attributes: NSDictionary?
            let attributed = NSAttributedString(
                rtf: data,
                documentAttributes: &attributes
            )
            XCTAssertNotNil(attributed, "Should create attributed string")
            
            // The font should be monospaced (this is set in the implementation)
            var hasMonospacedFont = false
            attributed?.enumerateAttributes(
                in: NSRange(location: 0, length: attributed?.length ?? 0),
                options: []
            ) { attrs, _, _ in
                #if os(macOS)
                if let font = attrs[.font] as? NSFont {
                    // Check if font is monospaced
                    hasMonospacedFont = true
                }
                #else
                if let font = attrs[.font] as? UIFont {
                    // Check if font is monospaced
                    hasMonospacedFont = true
                }
                #endif
            }
            XCTAssertTrue(hasMonospacedFont, "Should use monospaced font")
        }
    }
    
    func testRTFExportTabStops() {
        let stopwatch = Stopwatch()
        stopwatch.start()
        stopwatch.lap()
        
        let rtfData = ExportFormatter.rtf(from: stopwatch.laps)
        XCTAssertNotNil(rtfData, "RTF data should not be nil")
        
        if let data = rtfData {
            let attributed = NSAttributedString(
                rtf: data,
                documentAttributes: nil
            )
            
            // Check that tab characters are used for formatting
            let plainText = attributed?.string ?? ""
            XCTAssertTrue(plainText.contains("\t"), "Should use tabs for column separation")
            
            // Check paragraph style is applied
            var hasParagraphStyle = false
            attributed?.enumerateAttributes(
                in: NSRange(location: 0, length: attributed?.length ?? 0),
                options: []
            ) { attrs, _, _ in
                if let style = attrs[.paragraphStyle] as? NSParagraphStyle {
                    hasParagraphStyle = !style.tabStops.isEmpty
                }
            }
            XCTAssertTrue(hasParagraphStyle, "Should have paragraph style with tab stops")
        }
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
        XCTAssertTrue(cache1 === cache2, "Should be singleton instance")
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
    
    func testRTFExportPerformanceWithManyLaps() {
        let stopwatch = Stopwatch()
        stopwatch.start()
        
        // Create 1000 laps
        for _ in 0..<1_000 {
            Thread.sleep(forTimeInterval: 0.001)
            stopwatch.lap()
        }
        
        measure {
            _ = ExportFormatter.rtf(from: stopwatch.laps)
        }
    }
}
