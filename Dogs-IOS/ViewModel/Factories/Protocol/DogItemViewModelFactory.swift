import Foundation

protocol DogItemViewModelFactory {
    func createDogItemViewModel(from model: DogModel) -> any DogItemViewModel
}
