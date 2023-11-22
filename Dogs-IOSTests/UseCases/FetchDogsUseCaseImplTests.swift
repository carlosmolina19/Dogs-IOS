import Combine
import Foundation
import Mockingbird
import XCTest

@testable import Dogs_IOS

final class FetchDogsUseCaseImplTests: XCTestCase {
    
    // MARK: - Private Typealias
    
    private typealias SUT = FetchDogsUseCaseImpl
    
    // MARK: - Private Properties
    
    private var sut: SUT!
    private var mockLocalDogRepository: LocalDogRepositoryMock!
    private var mockRemoteDogRepository: RemoteDogRepositoryMock!
    private var tasks: Set<AnyCancellable>!
    
    // MARK: - Lifecycle
    
    override func setUp() {
        super.setUp()
        
        tasks = .init()
        mockLocalDogRepository = mock(LocalDogRepository.self)
        mockRemoteDogRepository = mock(RemoteDogRepository.self)
        
        sut = SUT(remoteDogRepository: mockRemoteDogRepository,
                  localDogRepository: mockLocalDogRepository)
    }
    
    override func tearDown() {
        super.tearDown()
        
        sut = nil
        mockLocalDogRepository = nil
        mockRemoteDogRepository = nil
        tasks = nil
        
    }
    
    // MARK: - Tests
    
    func test_execute_shouldCallToLocalRepository() throws {
        guard let asset = NSDataAsset(name: "DogResponse")
        else {
            XCTFail("Init Error")
            return
        }
        
        let dogsModel = try JSONDecoder().decode([DogModel].self,
                                                 from: asset.data)
        let expectation = XCTestExpectation(
            description: "test_execute_shouldCallToLocalRepository")
        let publisher = Just(dogsModel)
            .setFailureType(to: DogsError.self)
            .eraseToAnyPublisher()
        
        given(mockLocalDogRepository.fetch()).willReturn(publisher)
        
        sut.execute().sink {
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
        verify(mockLocalDogRepository.fetch()).wasCalled()
        verify(mockRemoteDogRepository.fetch()).wasNeverCalled()
        tasks.removeAll()
    }
    
    func test_execute_whenLocalRepositoryReturnAnEmptyArray_shouldCallToRemoteRepository() {
        let expectation = XCTestExpectation(
            description: "test_execute")
        let publisher = Just([DogModel]())
            .setFailureType(to: DogsError.self)
            .eraseToAnyPublisher()
        
        given(mockLocalDogRepository.fetch()).willReturn(publisher)
        given(mockRemoteDogRepository.fetch()).willReturn(publisher)
        
        sut.execute().sink {
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
        verify(mockLocalDogRepository.fetch()).wasCalled()
        verify(mockRemoteDogRepository.fetch()).wasCalled()
        tasks.removeAll()
    }
    
    func test_execute_whenLocalRepositoryReturnAnError_shouldCallToRemoteRepository() {
        let expectation = XCTestExpectation(
            description: "test_execute")
        let errorPublisher = Fail<[DogModel], DogsError>(error:DogsError.invalidFormat).eraseToAnyPublisher()
        let publisher = Just([DogModel]())
            .setFailureType(to: DogsError.self)
            .eraseToAnyPublisher()
        
        given(mockLocalDogRepository.fetch()).willReturn(errorPublisher)
        given(mockRemoteDogRepository.fetch()).willReturn(publisher)
        
        sut.execute().sink {
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
        verify(mockLocalDogRepository.fetch()).wasCalled()
        verify(mockRemoteDogRepository.fetch()).wasCalled()
        tasks.removeAll()
    }
    
    func test_execute_whenRemoteRepositoryReturnAnError_shouldNotBeNil() {
        let expectation = XCTestExpectation(
            description: "test_execute")
        let errorPublisher = Fail<[DogModel], DogsError>(error:DogsError.invalidFormat).eraseToAnyPublisher()
        
        given(mockLocalDogRepository.fetch()).willReturn(errorPublisher)
        given(mockRemoteDogRepository.fetch()).willReturn(errorPublisher)
        
        sut.execute().sink {
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
        verify(mockLocalDogRepository.fetch()).wasCalled()
        verify(mockRemoteDogRepository.fetch()).wasCalled()
        tasks.removeAll()
    }
}
