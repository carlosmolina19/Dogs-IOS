import Combine
import Foundation

protocol SaveDogsUseCase {
    func execute(models: [DogModel]) -> AnyPublisher<Void, DogsError>
}
