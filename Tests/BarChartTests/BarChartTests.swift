import XCTest
@testable import BarChart

final class BarChartTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(BarChart().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
