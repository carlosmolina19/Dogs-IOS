import CoreData
import Foundation

final class DogsSceneBuilder {
    
    func build(persistentContainer: NSPersistentContainer) -> DogsListView<DogListViewModelImpl> {
        let networkProvider = NetworkProviderImpl(session: .shared)
        let coreDataProvider = CoreDataProviderImpl(persistentContainer: persistentContainer)
        let remoteRepository = RemoteDogRepositoryImpl(networkProvider: networkProvider)
        let localRepository = LocalDogRepositoryImpl(localProvider: coreDataProvider)
        let fetchDogsUseCase = FetchDogsUseCaseImpl(remoteDogRepository: remoteRepository,
                                                    localDogRepository: localRepository)
        
        let saveDogsUseCase = SaveDogsUseCaseImpl(localDogRepository: localRepository)
        let dogItemViewModelFactory = DogItemViewModelFactoryImpl()
        let viewModel = DogListViewModelImpl(fetchDogUseCase: fetchDogsUseCase,
                                             saveDogsUseCase: saveDogsUseCase,
                                             dogItemViewModelFactory: dogItemViewModelFactory)
        
        return DogsListView(viewModel: viewModel)
    }
}
