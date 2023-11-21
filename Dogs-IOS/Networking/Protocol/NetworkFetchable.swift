import Combine
import Foundation

protocol NetworkFetchable {
    func fetch(from url: URL) -> AnyPublisher<Data, Error>
}
