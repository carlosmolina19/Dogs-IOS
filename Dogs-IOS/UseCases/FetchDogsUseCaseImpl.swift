import Combine
import Foundation

final class FetchDogsUseCaseImpl: FetchDogsUseCase {
    
    // MARK: - Private Properties
    
    private let remoteDogRepository: RemoteDogRepository
    private let localDogRepository: LocalDogRepository
    
    // MARK: - Initialization
    
    init(remoteDogRepository: RemoteDogRepository,
         localDogRepository: LocalDogRepository) {
        
        self.remoteDogRepository = remoteDogRepository
        self.localDogRepository = localDogRepository
    }
    
    // MARK: - Internal Methods
    
    func execute() -> AnyPublisher<[DogModel], DogsError> {
        localDogRepository.fetch()
            .flatMap { [weak self] dogs in
                guard let self
                else {
                    return Just([DogModel]()).setFailureType(to: DogsError.self).eraseToAnyPublisher()
                }
                return dogs.isEmpty ? self.remoteDogRepository.fetch() : Just(dogs).setFailureType(to: DogsError.self).eraseToAnyPublisher()
            }
            .catch { [weak self] error in
                guard let self = self else {
                    return Just([DogModel]()).setFailureType(to: DogsError.self).eraseToAnyPublisher()
                }
                return self.remoteDogRepository.fetch()
            }
            .eraseToAnyPublisher()
    }
}
