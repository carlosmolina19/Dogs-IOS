import Combine
import Foundation

protocol RemoteDogRepository {

    func fetch() -> AnyPublisher<[DogModel], DogsError>
}
