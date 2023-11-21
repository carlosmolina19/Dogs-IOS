import Combine
import Foundation
import Mockingbird
import XCTest

@testable import Dogs_IOS

final class NetworkingProviderTests: XCTestCase {
    
    // MARK: - Private Typealias
    
    private typealias SUT = NetworkingProvider
    
    // MARK: - Private Properties
    
    private var sut: SUT!
    private var mockSession: URLSession!
    private var tasks: Set<AnyCancellable>!
    
    // MARK: - Lifecycle
    
    override func setUp() {
        super.setUp()
        
        tasks = .init()
    }
    
    override func tearDown() {
        super.tearDown()
        
        sut = nil
        mockSession = nil
        tasks = nil
        
    }
    
    // MARK: - Tests
    
    func test_fetch_shouldReturnValues() throws {
        guard let url = URL(string: "https://tests.com"),
              let data = "{\"someJsonKey\": \"someJsonData\"}".data(using: .utf8)
        else {
            XCTFail("Init error")
            return
        }
        let response = HTTPURLResponse()

        URLProtocolMock.mockURLs = [url: (nil, data, response)]
        
        let sessionConfiguration = URLSessionConfiguration.ephemeral
        sessionConfiguration.protocolClasses = [URLProtocolMock.self]
        mockSession = URLSession(configuration: sessionConfiguration)
        
        sut = SUT(session: mockSession)
        
        let expectation = XCTestExpectation(description: "test_fetch_shouldReturnValues")
        
        sut.fetch(from: url)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    XCTFail("Error: \(error.localizedDescription)")
                case .finished:
                    break
                }
                expectation.fulfill()
            }, receiveValue: { dataResponse in
                XCTAssertEqual(data, dataResponse)
            })
            .store(in: &tasks)
        
        
        wait(for: [expectation], timeout: 1.0)
        tasks.removeAll()
    }
    
    func test_fetch_whenErrorIsReceived_shouldNotBeNil() throws {
        guard let url = URL(string: "https://example.com")
        else {
            XCTFail("Init error")
            return
        }
        
        let error = NSError(domain: "test.domain", code: -1)
        
        let response = HTTPURLResponse()

        URLProtocolMock.mockURLs = [url: (error, nil, response)]
        
        let sessionConfiguration = URLSessionConfiguration.ephemeral
        sessionConfiguration.protocolClasses = [URLProtocolMock.self]
        mockSession = URLSession(configuration: sessionConfiguration)
        
        sut = SUT(session: mockSession)
        
        let expectation = XCTestExpectation(
            description: "test_fetch_whenErrorIsReceived_shouldBeEqual")
        
        sut.fetch(from: url)
            .sink(receiveCompletion: { completion in
                switch completion {
                    
                case .failure(let errorResponse):
                    XCTAssertNotNil(errorResponse)
                    
                case .finished:
                    break
                }
                expectation.fulfill()
            }, receiveValue: { dataResponse in
                XCTFail("Data wasn't sent")
            })
            .store(in: &tasks)
        
        
        wait(for: [expectation], timeout: 1.0)
        tasks.removeAll()
    }
}
