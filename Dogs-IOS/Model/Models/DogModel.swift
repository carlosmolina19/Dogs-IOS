import Foundation

struct DogModel: Identifiable {

    // MARK: - Internal Properties

    let id: UUID
    let name: String
    let description: String
    let age: Int
    let url: URL
}
