import Foundation

protocol DogItemViewModel {
    var id: String { get}
    var name: String { get }
    var description: String { get }
    var age: String { get }
    var url: URL { get }
}
