import Foundation

protocol DogListViewModel: ObservableObject {
    var items: [any DogItemViewModel] { get }
    
    func loadItems()
}
