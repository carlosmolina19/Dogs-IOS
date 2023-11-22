import Combine
import Foundation
import Mockingbird
import XCTest

@testable import Dogs_IOS

final class DogListViewModelImplTests: XCTestCase {

    // MARK: - Typealias

    private typealias SUT = DogListViewModelImpl

    // MARK: - Private Properties

    private var sut: SUT!
    private var mockFetchDogsUseCase: FetchDogsUseCaseMock!
    private var mockSaveDogsUseCase: SaveDogsUseCaseMock!
    private var mockDogItemViewModelFactory: DogItemViewModelFactoryMock!
    private var mockDogItemViewModel: DogItemViewModelMock!

    // MARK: - Lifecycle

    override func setUp() {
        super.setUp()
        
        mockFetchDogsUseCase = mock(FetchDogsUseCase.self)
        mockSaveDogsUseCase = mock(SaveDogsUseCase.self)
        mockDogItemViewModelFactory = mock(DogItemViewModelFactory.self)
        mockDogItemViewModel = mock(DogItemViewModel.self)
        
        sut = SUT(fetchDogUseCase: mockFetchDogsUseCase,
                  saveDogsUseCase: mockSaveDogsUseCase,
                  dogItemViewModelFactory: mockDogItemViewModelFactory)
    }

    override func tearDown() {
        super.tearDown()
        
        sut = nil
        mockFetchDogsUseCase = nil
        mockSaveDogsUseCase = nil
        mockDogItemViewModelFactory = nil
        mockDogItemViewModel = nil
    }

    // MARK: - Tests

    func test_loadItems_shouldReturnValues() throws {
        let asset = try XCTUnwrap(NSDataAsset(name: "DogResponse"))
        let dogsModel = try XCTUnwrap(JSONDecoder().decode([DogModel].self,
                                                           from: asset.data))
        
        let expectation = XCTestExpectation(description: "loadItems")
        let publisherFetch = Just(dogsModel)
            .setFailureType(to: DogsError.self)
            .eraseToAnyPublisher()
        
        let publisherSave = Just(())
            .setFailureType(to: DogsError.self)
            .eraseToAnyPublisher()
        
        given(mockFetchDogsUseCase.execute()).willReturn(publisherFetch)
        given(mockSaveDogsUseCase.execute(models: any())).willReturn(publisherSave)
        given(mockDogItemViewModelFactory.createDogItemViewModel(from: any())).willReturn(mockDogItemViewModel)
        
        sut.loadItems()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            verify(self.mockSaveDogsUseCase.execute(models: any())).wasCalled()
             expectation.fulfill()
         }
        
         wait(for: [expectation], timeout: 1)
        XCTAssertEqual(sut.items.count, 1)
        
    }
}
