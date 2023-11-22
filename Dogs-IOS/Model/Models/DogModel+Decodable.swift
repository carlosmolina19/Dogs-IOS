import Foundation

extension DogModel: Decodable {

    // MARK: - Decodable

    enum CodingKeys: String, CodingKey {
        case name = "dogName"
        case description
        case age
        case url = "image"
    }

    // MARK: - Initialization

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = UUID()
        name = try container.decode(String.self, forKey: .name)
        description = try container.decode(String.self, forKey: .description)
        age = try container.decode(Int.self, forKey: .age)
        url = try container.decode(URL.self, forKey: .url)
    }
}
