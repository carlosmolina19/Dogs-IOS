import Combine
import CoreData
import Foundation
import XCTest

@testable import Dogs_IOS

final class CoreDataProviderImplTests: XCTestCase {
    
    // MARK: - Private Typealias
    
    private typealias SUT = CoreDataProviderImpl
    
    // MARK: - Private Properties
    
    private var sut: SUT!
    private var mockPersistentContainer: NSPersistentContainer!
    private var tasks: Set<AnyCancellable>!
    
    // MARK: - Lifecycle
    
    override func setUp() {
        super.setUp()
        
        tasks = .init()
        mockPersistentContainer = NSPersistentContainer.mockPersistentContainer()
        sut = SUT(persistentContainer: mockPersistentContainer)
        
    }
    
    override func tearDown() {
        super.tearDown()
        
        sut = nil
        mockPersistentContainer = nil
        tasks = nil
    }
    
    // MARK: - Tests
    
    func test_context_shouldBeEqual() {
        XCTAssertEqual(sut.context, mockPersistentContainer.viewContext)
    }
    
    func test_fetch_shouldFulFill() {
        let expectation = expectation(description: "test_fetch_shouldFulFill")
        
        sut.fetch(entityType: Dog.self)
            .sink { _ in
            } receiveValue: { _ in
                expectation.fulfill()
            }.store(in: &tasks)
        
        
        waitForExpectations(timeout: 1.0)
        tasks.removeAll()
    }
    
    func test_save_shouldFulFill() throws {
        
        let dog = Dog(context: mockPersistentContainer.viewContext)
        dog.id = UUID()
        dog.name = "name"
        dog.dogDescription = "description"
        dog.age = 1
        dog.url = "https://test.com"
        expectation(forNotification: .NSManagedObjectContextDidSave,
                                      object: mockPersistentContainer.viewContext)
        
        sut.save([dog]).sink { _ in
        } receiveValue: { _ in
        }.store(in: &tasks)
        
        waitForExpectations(timeout: 1.0) { error in
            XCTAssertNil(error, "Save did not occur")
        }
        tasks.removeAll()
    }
}
