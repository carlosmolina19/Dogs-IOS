import Combine
import Foundation

final class DogListViewModelImpl: DogListViewModel {
    
    // MARK: - Internal Properties
    
    @Published var items = [any DogItemViewModel]()
    
    // MARK: - Private Properties
    
    private var fetchDogsUseCase: FetchDogsUseCase
    private var saveDogsUseCase: SaveDogsUseCase
    private var dogItemViewModelFactory: DogItemViewModelFactory
    
    // MARK: - Initialization
    
    init(fetchDogUseCase: FetchDogsUseCase,
         saveDogsUseCase: SaveDogsUseCase,
         dogItemViewModelFactory: DogItemViewModelFactory) {
        
        self.fetchDogsUseCase = fetchDogUseCase
        self.saveDogsUseCase = saveDogsUseCase
        self.dogItemViewModelFactory = dogItemViewModelFactory
        
    }
    
    // MARK: - Internal Methods
    
    func loadItems() {
        fetchDogsUseCase.execute()
            .flatMap { [weak self] dogs -> AnyPublisher<[any DogItemViewModel], DogsError> in
                guard let self
                else {
                    return Fail(error: DogsError.deallocated).eraseToAnyPublisher()
                }
                
                let viewModels = dogs.map { self.dogItemViewModelFactory.createDogItemViewModel(from: $0) }
                return self.saveDogsUseCase.execute(models: dogs)
                    .map { viewModels }
                    .catch { error -> AnyPublisher<[any DogItemViewModel], DogsError> in
                        return Just(viewModels).setFailureType(to: DogsError.self).eraseToAnyPublisher()
                    }
                    .eraseToAnyPublisher()
            }
            .replaceError(with: [])
            .receive(on: RunLoop.main)
            .assign(to: &$items)
    }
}
