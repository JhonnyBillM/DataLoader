import XCTest
@testable import DataLoader

final class DataLoaderTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(DataLoader().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
