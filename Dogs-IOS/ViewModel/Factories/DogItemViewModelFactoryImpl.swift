import Foundation

final class DogItemViewModelFactoryImpl: DogItemViewModelFactory {
    
    func createDogItemViewModel(from model: DogModel) -> any DogItemViewModel {
        DogItemViewModelImpl(model: model)
    }
}
