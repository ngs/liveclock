import XCTest
@testable import LiveClockCore

final class TimeFormatterTests: XCTestCase {
    func testFormatZero() {
        XCTAssertEqual(TimeFormatter.format(0), "00:00:00.000")
    }

    func testFormatMilliseconds() {
        XCTAssertEqual(TimeFormatter.format(0.123), "00:00:00.123")
        XCTAssertEqual(TimeFormatter.format(0.999), "00:00:00.999")
    }

    func testFormatSeconds() {
        XCTAssertEqual(TimeFormatter.format(1.0), "00:00:01.000")
        XCTAssertEqual(TimeFormatter.format(59.999), "00:00:59.999")
    }

    func testFormatMinutes() {
        XCTAssertEqual(TimeFormatter.format(60.0), "00:01:00.000")
        XCTAssertEqual(TimeFormatter.format(119.5), "00:01:59.500")
        XCTAssertEqual(TimeFormatter.format(3_599.999), "00:59:59.999")
    }

    func testFormatHours() {
        XCTAssertEqual(TimeFormatter.format(3_600.0), "01:00:00.000")
        XCTAssertEqual(TimeFormatter.format(7_200.123), "02:00:00.123")
        XCTAssertEqual(TimeFormatter.format(359_999.999), "99:59:59.999")
    }

    func testFormatOverflow() {
        XCTAssertEqual(TimeFormatter.format(360_000.0), "99:59:59.999")
        XCTAssertEqual(TimeFormatter.format(999_999.999), "99:59:59.999")
    }

    func testFormatNegative() {
        XCTAssertEqual(TimeFormatter.format(-1.0), "00:00:00.000")
        XCTAssertEqual(TimeFormatter.format(-999.999), "00:00:00.000")
    }

    func testFormatPrecision() {
        XCTAssertEqual(TimeFormatter.format(1.1234), "00:00:01.123")
        XCTAssertEqual(TimeFormatter.format(1.9999), "00:00:01.999")
    }

    func testFormatCompactZero() {
        XCTAssertEqual(TimeFormatter.formatCompact(0), "0.000")
    }

    func testFormatCompactMilliseconds() {
        XCTAssertEqual(TimeFormatter.formatCompact(0.123), "0.123")
        XCTAssertEqual(TimeFormatter.formatCompact(0.999), "0.999")
    }

    func testFormatCompactSeconds() {
        XCTAssertEqual(TimeFormatter.formatCompact(1.0), "1.000")
        XCTAssertEqual(TimeFormatter.formatCompact(59.999), "59.999")
    }

    func testFormatCompactMinutes() {
        XCTAssertEqual(TimeFormatter.formatCompact(60.0), "1:00.000")
        XCTAssertEqual(TimeFormatter.formatCompact(119.5), "1:59.500")
        XCTAssertEqual(TimeFormatter.formatCompact(3_599.999), "59:59.999")
    }

    func testFormatCompactHours() {
        XCTAssertEqual(TimeFormatter.formatCompact(3_600.0), "1:00:00.000")
        XCTAssertEqual(TimeFormatter.formatCompact(7_200.123), "2:00:00.123")
    }
}
