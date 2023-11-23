import Combine
import Foundation

final class LocalDogRepositoryImpl: LocalDogRepository {
    
    // MARK: - Private Properties
    
    private let localProvider: LocalProvider
    
    // MARK: - Initialization
    
    init(localProvider: LocalProvider) {
        self.localProvider = localProvider
    }
    
    // MARK: - Internal Methods
    
    func fetch() -> AnyPublisher<[DogModel], DogsError> {
        localProvider.fetch(entityType: Dog.self)
            .map { entities in
               let array =  entities.compactMap { entity in
                    DogModel(dogEntity: entity)
                }
                return array
            }
            .mapError {
                guard let error = $0 as? DogsError
                else {
                    return DogsError.genericError($0)
                }
                return error
            }
            .eraseToAnyPublisher()
    }
    
    func save(from models: [DogModel]) -> AnyPublisher<Void, DogsError> {
        localProvider.save(models.map {
            Dog(model: $0,
                context: localProvider.context)
        }).mapError {
            guard let error = $0 as? DogsError
            else {
                return DogsError.genericError($0)
            }
            return error
        }
        .eraseToAnyPublisher()
    }
}
