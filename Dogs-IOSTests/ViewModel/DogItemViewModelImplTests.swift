import Foundation
import XCTest

@testable import Dogs_IOS

final class DogItemViewModelImplTests: XCTestCase {

    // MARK: - Typealias

    private typealias SUT = DogItemViewModelImpl

    // MARK: - Private Properties

    private var sut: SUT!

    // MARK: - Lifecycle

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
        sut = nil
    }

    // MARK: - Tests

    func test_init_shouldReturnValues() throws {
        let asset = try XCTUnwrap(NSDataAsset(name: "DogResponse"))
        let dogModel = try XCTUnwrap(JSONDecoder().decode([DogModel].self,
                                                          from: asset.data).first)
        
        sut = SUT(model: dogModel)

        XCTAssertEqual(dogModel.id.uuidString, sut.id)
        XCTAssertEqual(dogModel.name, sut.name)
        XCTAssertEqual(dogModel.description, sut.description)
        XCTAssertEqual(String("Almost \(dogModel.age) years"), sut.age)
        XCTAssertEqual(dogModel.url.absoluteString, sut.url.absoluteString)
    }
}
