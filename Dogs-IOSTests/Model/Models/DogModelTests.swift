import Foundation
import XCTest

@testable import Dogs_IOS

final class DogModelTests: XCTestCase {

    // MARK: - Typealias

    private typealias SUT = DogModel

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

    func test_init_valuesShouldBeEqual() {
        let uuid = UUID()
        let name = "foo.name"
        let description = "foo.description"
        let age = 5
        guard let url = URL(string: "https://example.com/data") else {
            XCTFail("")
            return
        }
        
        sut = SUT(id: uuid, name: name, description: description, age: age, url: url)
        
        XCTAssertEqual(sut.id.uuidString, uuid.uuidString)
        XCTAssertEqual(sut.name, name)
        XCTAssertEqual(sut.description, description)
        XCTAssertEqual(sut.age, age)
        XCTAssertEqual(sut.url.absoluteString, url.absoluteString)
    }
    
    func test_initFromDecode_valuesShouldBeEqual() throws {
        guard let asset = NSDataAsset(name: "DogResponse")
        else {
            XCTFail("Init Error")
            return
        }
        
        sut = try JSONDecoder().decode([SUT].self, from: asset.data).first
        
        XCTAssertNotNil(sut.id)
        XCTAssertEqual(sut.name, "dog.name")
        XCTAssertEqual(sut.description, "dog.description")
        XCTAssertEqual(sut.age, 1)
        XCTAssertEqual(sut.url.absoluteString, "https://test.dog.com")
    }
}
