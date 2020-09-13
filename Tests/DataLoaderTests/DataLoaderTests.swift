import XCTest
@testable import DataLoader

final class DataLoaderTests: XCTestCase {

	// MARK: - Disclaimer.
	// I understand that we should mock the network in order to make our tests faster and deterministic,
	// but due to time constraints I will test making network requests and using XCTestExpectation.
	// We can later refactor this to inject a mock networking service to simulate the request and only test the `RemoteLoader` logic itself.

	/// Test the download of an image.
	func testDownloadData() {
		let expectation = XCTestExpectation(description: "Download image")
		let url = URL(string: "https://source.unsplash.com/random/20x20")!

		RemoteLoader.shared.downloadData(from: url) { (result) in
			XCTAssertNotNil(try? result.get(), "Failed to download data.")
			expectation.fulfill()
		}

		wait(for: [expectation], timeout: 10.0)
	}

	/// Test downloading the same image multiple times. This test our sharing handlers logic,
	/// which make the test pass under the defined timeout, if we remove the handlers dictionary, this test will exceed the timeout.
	func testDownloadSameDataMultipleTimes() {
		let expectation1 = XCTestExpectation(description: "Download image 1")
		let expectation2 = XCTestExpectation(description: "Download image 2")
		let expectation3 = XCTestExpectation(description: "Download image 3")
		let expectation4 = XCTestExpectation(description: "Download image 4")

		let url = URL(string: "https://images.unsplash.com/photo-1598104997625-3200382e57e4?crop=entropy&cs=tinysrgb&fit=crop&fm=jpg&h=20&ixlib=rb-1.2.1&q=80&w=20")!

		RemoteLoader.shared.downloadData(from: url) { (result) in
			XCTAssertNotNil(try? result.get(), "Failed to download data.")
			expectation1.fulfill()
		}

		RemoteLoader.shared.downloadData(from: url) { (result) in
			XCTAssertNotNil(try? result.get(), "Failed to download data 2.")
			expectation2.fulfill()
		}

		RemoteLoader.shared.downloadData(from: url) { (result) in
			XCTAssertNotNil(try? result.get(), "Failed to download data 3.")
			expectation3.fulfill()
		}

		RemoteLoader.shared.downloadData(from: url) { (result) in
			XCTAssertNotNil(try? result.get(), "Failed to download data 4.")
			expectation4.fulfill()
		}

		wait(for: [expectation1, expectation2, expectation3, expectation4], timeout: 10.0)
	}

	func testDownloadDataFromMultipleThreads() {
		let url = URL(string: "https://images.unsplash.com/photo-1598104997625-3200382e57e4?crop=entropy&cs=tinysrgb&fit=crop&fm=jpg&h=20&ixlib=rb-1.2.1&q=80&w=20")!

		let queue1 = DispatchQueue(label: "queue1", attributes: .concurrent)
		let queue2 = DispatchQueue(label: "queue2", attributes: .concurrent)
		let queue3 = DispatchQueue(label: "queue3", attributes: .concurrent)
		let queue4 = DispatchQueue(label: "queue4", attributes: .concurrent)

		let expectation1 = XCTestExpectation(description: "Download image 1")
		let expectation2 = XCTestExpectation(description: "Download image 2")
		let expectation3 = XCTestExpectation(description: "Download image 3")
		let expectation4 = XCTestExpectation(description: "Download image 4")

		queue1.async {
			RemoteLoader.shared.downloadData(from: url) { (result) in
				XCTAssertNotNil(try? result.get(), "Failed to download data.")
				expectation1.fulfill()
			}
		}

		queue2.async {
			RemoteLoader.shared.downloadData(from: url) { (result) in
				XCTAssertNotNil(try? result.get(), "Failed to download data 2.")
				expectation2.fulfill()
			}
		}

		queue3.async {
			RemoteLoader.shared.downloadData(from: url) { (result) in
				XCTAssertNotNil(try? result.get(), "Failed to download data 3.")
				expectation3.fulfill()
			}
		}

		queue4.async {
			RemoteLoader.shared.downloadData(from: url) { (result) in
				XCTAssertNotNil(try? result.get(), "Failed to download data 4.")
				expectation4.fulfill()
			}
		}

		wait(for: [expectation1, expectation2, expectation3, expectation4], timeout: 10.0)
	}

	static var allTests = [
		("testDownloadData", testDownloadData),
		("testDownloadSameDataMultipleTimes", testDownloadSameDataMultipleTimes)
	]
}
