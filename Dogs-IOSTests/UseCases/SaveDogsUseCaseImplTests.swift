import Combine
import Foundation
import Mockingbird
import XCTest

@testable import Dogs_IOS

final class SaveDogsUseCaseImplTests: XCTestCase {
    
    // MARK: - Private Typealias
    
    private typealias SUT = SaveDogsUseCaseImpl
    
    // MARK: - Private Properties
    
    private var sut: SUT!
    private var mockLocalDogRepository: LocalDogRepositoryMock!
    private var tasks: Set<AnyCancellable>!
    
    // MARK: - Lifecycle
    
    override func setUp() {
        super.setUp()
        
        tasks = .init()
        mockLocalDogRepository = mock(LocalDogRepository.self)
        sut = SUT(localDogRepository: mockLocalDogRepository)
    }
    
    override func tearDown() {
        super.tearDown()
        
        sut = nil
        mockLocalDogRepository = nil
        tasks = nil
        
    }
    
    // MARK: - Tests
    
    func test_execute_shouldcallToLocalRepository() {
        let expectation = XCTestExpectation(
            description: "test_fetch_shouldReturnValues")
        let publisher = Just(())
            .setFailureType(to: DogsError.self)
            .eraseToAnyPublisher()
        
        given(mockLocalDogRepository.save(from: any())).willReturn(publisher)
        
        sut.execute(models: []).sink {
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
        verify(mockLocalDogRepository.save(from: any())).wasCalled()
        tasks.removeAll()
    }
    
    func test_execute_whenRepositoryReturnAnError_shouldNotBeNil() {
        let expectation = XCTestExpectation(
            description: "test_fetch_shouldReturnValues")
        let errorPublisher = Fail<Void, DogsError>(error:DogsError.invalidFormat).eraseToAnyPublisher()

        
        given(mockLocalDogRepository.save(from: any())).willReturn(errorPublisher)
        
        sut.execute(models: []).sink {
            switch $0 {
            case .failure(let error):
                XCTAssertNotNil(error)
            case .finished:
                break
            }
            expectation.fulfill()
        } receiveValue: { _ in
        }.store(in: &tasks)
        
        wait(for: [expectation], timeout: 1.0)
        verify(mockLocalDogRepository.save(from: any())).wasCalled()
        tasks.removeAll()
    }
}
