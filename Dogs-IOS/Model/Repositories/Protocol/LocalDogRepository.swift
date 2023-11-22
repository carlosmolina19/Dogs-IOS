import Combine
import Foundation

protocol LocalDogRepository {

    func fetch() -> AnyPublisher<[DogModel], DogsError>
    func save(from models:[DogModel]) -> AnyPublisher<Void, DogsError>
}
