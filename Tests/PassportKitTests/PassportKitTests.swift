import XCTest
@testable import PassportKit

final class PassportKitTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(PassportKit().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
