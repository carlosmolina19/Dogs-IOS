import CoreData
import Combine
import Foundation
import Mockingbird
import XCTest

@testable import Dogs_IOS

final class LocalDogRepositoryImplTests: XCTestCase {
    
    // MARK: - Private Typealias
    
    private typealias SUT = LocalDogRepositoryImpl
    
    // MARK: - Private Properties
    
    private var sut: SUT!
    private var mockLocalProvider: LocalProviderMock!
    private var mockPersistentContainer: NSPersistentContainer!
    private var tasks: Set<AnyCancellable>!
    
    // MARK: - Lifecycle
    
    override func setUp() {
        super.setUp()
        
        tasks = .init()
        mockLocalProvider = mock(LocalProvider.self)
        sut = SUT(localProvider: mockLocalProvider)
        mockPersistentContainer = NSPersistentContainer.mockPersistentContainer()
        given(mockLocalProvider.context).willReturn(mockPersistentContainer.viewContext)
    }
    
    override func tearDown() {
        super.tearDown()
        
        sut = nil
        mockLocalProvider = nil
        mockPersistentContainer = nil
        tasks = nil
        
    }
    
    // MARK: - Tests
    
    func test_fetch_shouldReturnValues() {
        let dogObject = Dog(context: mockLocalProvider.context)
        dogObject.id = UUID()
        dogObject.name = "name"
        dogObject.dogDescription = "description"
        dogObject.url = "https://tests.com"
        dogObject.age = 1
        
        let expectation = XCTestExpectation(
            description: "test_fetch_shouldReturnValues")
        let publisher = Just([dogObject])
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        
        given(mockLocalProvider.fetch(entityType: Dog.self)).willReturn(publisher)
        
        sut.fetch().sink {
            switch $0 {
            case .failure(let error):
                XCTFail("Error: \(error.localizedDescription)")
            case .finished:
                break
            }
            expectation.fulfill()
        } receiveValue: {
            XCTAssertEqual($0.count, 1)
        }.store(in: &tasks)
        
        wait(for: [expectation], timeout: 1.0)
        verify(mockLocalProvider.fetch(entityType: Dog.self)).wasCalled()
        tasks.removeAll()
    }
    
    func test_fetch_whenSomeValueIsNil_shouldReturnEmptyArray() {
        let dogObject = Dog(context: mockLocalProvider.context)
        
        let expectation = XCTestExpectation(
            description: "test_fetch_shouldReturnValues")
        let publisher = Just([dogObject])
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        
        given(mockLocalProvider.fetch(entityType: Dog.self)).willReturn(publisher)
        
        sut.fetch().sink {
            switch $0 {
            case .failure(let error):
                XCTFail("Error: \(error.localizedDescription)")
            case .finished:
                break
            }
            expectation.fulfill()
        } receiveValue: {
            XCTAssertEqual($0.count, 0)
        }.store(in: &tasks)
        
        wait(for: [expectation], timeout: 1.0)
        verify(mockLocalProvider.fetch(entityType: Dog.self)).wasCalled()
        tasks.removeAll()
    }
    
    func test_save_shouldBeCalled() throws {
        guard let asset = NSDataAsset(name: "DogResponse"),
              let dogModel = try JSONDecoder().decode([DogModel].self,
                                                      from: asset.data).first
        else {
            XCTFail("Init Error")
            return
        }
                        
        let expectation = XCTestExpectation(
            description: "test_fetch_shouldReturnValues")
        let publisher = Just(())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        
        given(mockLocalProvider.save(any())).willReturn(publisher)
        
        sut.save(from: [dogModel]).sink {
            switch $0 {
            case .failure(let error):
                XCTFail("Error: \(error.localizedDescription)")
            case .finished:
                break
            }
            expectation.fulfill()
        } receiveValue: { _ in
        }.store(in: &tasks)
        
        wait(for: [expectation], timeout: 1.0)
        verify(mockLocalProvider.save(any())).wasCalled()
        tasks.removeAll()
    }
}
