import Combine
import CoreData
import Foundation

protocol LocalProvider {
    var context: NSManagedObjectContext { get }
    
    func fetch<T: NSManagedObject>(entityType: T.Type) -> AnyPublisher<[T], Error>
    func save<T: NSManagedObject>(_ entities: [T]) -> AnyPublisher<Void, Error>
}
