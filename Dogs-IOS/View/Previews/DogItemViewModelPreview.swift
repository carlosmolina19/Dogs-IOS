import Foundation

final class DogItemViewModelPreview: DogItemViewModel {
    
    // MARK: - Internal Computed Properties
    
    var id: String {
        UUID().uuidString
    }
    
    var name: String {
        "Spots"
    }
    
    var description: String {
        "He is much more passive and is the first to suggest to rescue and not eat The Little Pilot"
    }
    
    var age: String {
        "Almost 2 years"
    }
    
    var url: URL {
        URL(string: "https://static.wikia.nocookie.net/isle-of-dogs/images/6/6b/Spots.jpg/revision/latest/scale-to-width-down/666?cb=20180624191101")!
    }
}
