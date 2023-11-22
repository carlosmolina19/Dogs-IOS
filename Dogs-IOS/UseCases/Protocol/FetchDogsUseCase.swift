import Combine
import Foundation

protocol FetchDogsUseCase {
    func execute() -> AnyPublisher<[DogModel], DogsError>
}
