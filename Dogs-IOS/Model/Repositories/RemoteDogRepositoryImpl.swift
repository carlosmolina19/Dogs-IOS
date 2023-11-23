import Combine
import Foundation

final class RemoteDogRepositoryImpl: RemoteDogRepository {

    // MARK: - Private Properties

    private let networkProvider: NetworkProvider

    // MARK: - Initialization

    init(networkProvider: NetworkProvider) {
        self.networkProvider = networkProvider
    }

    // MARK: - Internal Methods

    func fetch() -> AnyPublisher<[DogModel], DogsError> {
        guard let url = URL(string: "https://jsonblob.com/api/1151549092634943488")
        else {
            fatalError("Can't initialize URL")
        }
        return networkProvider.fetch(from: url).tryMap {
            guard let dogs: [DogModel] = try? JSONDecoder().decode([DogModel].self, from: $0)
            else {
                throw DogsError.invalidFormat
            }
            return dogs
        }.mapError {
            guard let error = $0 as? DogsError
            else {
                return DogsError.genericError($0)
            }
            return error
        }
        .eraseToAnyPublisher()
    }
}
