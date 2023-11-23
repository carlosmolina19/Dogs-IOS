import Foundation

final class DogListViewModelPreview: DogListViewModel {
    
    // MARK: - Internal Properties
    
    var items: [DogItemViewModel] = [DogItemViewModelPreview(),
                                     DogItemViewModelPreview(),
                                     DogItemViewModelPreview(),
                                     DogItemViewModelPreview()]
    
    // MARK: - Internal Methods

    func loadItems() {}
}
