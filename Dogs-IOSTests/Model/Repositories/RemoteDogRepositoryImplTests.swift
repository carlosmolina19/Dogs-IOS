import Combine
import Foundation
import Mockingbird
import XCTest

@testable import Dogs_IOS

final class RemoteDogRepositoryImplTests: XCTestCase {
    
    // MARK: - Private Typealias
    
    private typealias SUT = RemoteDogRepositoryImpl
    
    // MARK: - Private Properties
    
    private var sut: SUT!
    private var mockNetworkProvider: NetworkProviderMock!
    private var tasks: Set<AnyCancellable>!
    
    // MARK: - Lifecycle
    
    override func setUp() {
        super.setUp()
        
        tasks = .init()
        mockNetworkProvider = mock(NetworkProvider.self)
        sut = SUT(networkProvider: mockNetworkProvider)
    }
    
    override func tearDown() {
        super.tearDown()
        
        sut = nil
        mockNetworkProvider = nil
        tasks = nil
        
    }
    
    // MARK: - Tests
    
    func test_fetch_shouldReturnValues() {
        guard let asset = NSDataAsset(name: "DogListResponse"),
              let url = URL(string: "https://jsonblob.com/api/1151549092634943488")
        else {
            XCTFail("Init Error")
            return
        }
        
        let expectation = XCTestExpectation(
            description: "test_fetch_shouldReturnValues")
        let publisher = Just(asset.data)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        
        given(mockNetworkProvider.fetch(from: url)).willReturn(publisher)
        
        sut.fetch().sink {
            switch $0 {
            case .failure(let error):
                XCTFail("Error: \(error.localizedDescription)")
            case .finished:
                break
            }
            expectation.fulfill()
        } receiveValue: {
            XCTAssertEqual($0.count, 2)
        }.store(in: &tasks)
        
        wait(for: [expectation], timeout: 1.0)
        verify(mockNetworkProvider.fetch(from: url)).wasCalled()
        tasks.removeAll()
    }
    
    func test_fetch_whenErrorIsReceived_errorShouldNotBeNil() {
        guard let url = URL(string: "https://jsonblob.com/api/1151549092634943488")
        else {
            XCTFail("Init Error")
            return
        }
        
        let expectation = XCTestExpectation(
            description: "test_fetch_whenErrorIsReceived_errorShouldNotBeNil")
        let publisher = Fail<Data, Error>(error: NSError(domain: "test.domain",
                                                         code: -1))
            .eraseToAnyPublisher()
        
        given(mockNetworkProvider.fetch(from: url)).willReturn(publisher)
        
        sut.fetch().sink {
            switch $0 {
            case .failure(let error):
                XCTAssertNotNil(error)
            case .finished:
                break
            }
            expectation.fulfill()
        } receiveValue: { _ in
            XCTFail("Error was sent")
        }.store(in: &tasks)
        
        wait(for: [expectation], timeout: 1.0)
        
        verify(mockNetworkProvider.fetch(from: url)).wasCalled()
        tasks.removeAll()
    }
    
    func test_fetch_whenBadDataIsReceived_errorShouldNotBeNil() {
        guard let data = "bad data".data(using: .utf8),
              let url = URL(string: "https://jsonblob.com/api/1151549092634943488")
        else {
            XCTFail("Init Error")
            return
        }
        
        let expectation = XCTestExpectation(
            description: "test_fetch_whenBadDataIsReceived_shouldNotBeNil")
        let publisher = Just(data)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        
        given(mockNetworkProvider.fetch(from: url)).willReturn(publisher)
        
        sut.fetch().sink {
            switch $0 {
            case .failure(let error):
                XCTAssertNotNil(error)
            case .finished:
                break
            }
            expectation.fulfill()
        } receiveValue: { _ in
            XCTFail("Bad Data was sent")
        }.store(in: &tasks)
        
        wait(for: [expectation], timeout: 1.0)
        verify(mockNetworkProvider.fetch(from: url)).wasCalled()
        tasks.removeAll()
    }
}
