import Combine
import CoreData
import Foundation

final class CoreDataProviderImpl: LocalProvider {
    
    // MARK: - Internal Computed Properties

    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    // MARK: - Private Properties

    private let persistentContainer: NSPersistentContainer

    // MARK: - Initialization

    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }

    // MARK: - Internal Methods

    func fetch<T: NSManagedObject>(entityType: T.Type) -> AnyPublisher<[T], Error> {
        Future<[T], Error> { [weak self] promise in
            guard let self
            else {
                return
            }

            let fetchRequest = NSFetchRequest<T>(entityName: String(describing: entityType))

            self.persistentContainer.viewContext.perform {
                do {
                    let result = try self.persistentContainer.viewContext.fetch(fetchRequest)
                    promise(.success(result))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func save<T: NSManagedObject>(_ entities: [T]) -> AnyPublisher<Void, Error> {
        Future<Void, Error> { [weak self] promise in
            guard let self
            else {
                return
            }
            
            persistentContainer.viewContext.perform {
                do {
                    try self.persistentContainer.viewContext.save()
                    promise(.success(()))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
