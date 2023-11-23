import Foundation

final class DogItemViewModelImpl: DogItemViewModel {
    
    // MARK: - Internal Computed Properties
    
    var id: String {
        model.id.uuidString
    }
    
    var name: String {
        model.name
    }
    
    var description: String {
        model.description
    }
    
    var age: String {
        String("Almost \(model.age) years")
    }
    
    var url: URL {
        model.url
    }

    // MARK: - Private Properties
    
    private let model: DogModel

    // MARK: - Initialization

    init(model: DogModel) {
        self.model = model
    }
}
