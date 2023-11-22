import CoreData
import Foundation

extension DogModel {
    
    // MARK: - Initialization
    
    init?(dogEntity: Dog) {
        guard let id = dogEntity.id,
              let name = dogEntity.name,
              let description = dogEntity.dogDescription,
              let url = URL(string: dogEntity.url ?? "")
        else {
            return nil
        }
        
        self.id = id
        self.name = name
        self.description = description
        self.url = url
        self.age = Int(dogEntity.age)
    }
}
