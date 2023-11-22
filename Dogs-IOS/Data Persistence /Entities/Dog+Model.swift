import CoreData
import Foundation

extension Dog {
    
    // MARK: - Initialization

    convenience init(model: DogModel, 
                     context: NSManagedObjectContext) {
        
        self.init(context: context)
        
        id = model.id
        name = model.name
        dogDescription = model.description
        age = Int16(model.age)
        url = model.url.absoluteString
    }
}
