import Combine
import Foundation

final class SaveDogsUseCaseImpl: SaveDogsUseCase {
    
    // MARK: - Private Properties
    
    private let localDogRepository: LocalDogRepository
    
    // MARK: - Initialization
    
    init(localDogRepository: LocalDogRepository) {
        self.localDogRepository = localDogRepository
    }
    
    // MARK: - Internal Methods
    
    func execute(models: [DogModel]) -> AnyPublisher<Void, DogsError> {
        localDogRepository.save(from: models)
    }
}
