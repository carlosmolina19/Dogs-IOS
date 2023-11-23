import SwiftUI

struct DogsListView<T: DogListViewModel>: View {
    
    // MARK: - Private Properties
    
    @ObservedObject private var viewModel: T
    
    init(viewModel: T) {
        self.viewModel = viewModel
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.primaryDog]
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.tertiaryDog.edgesIgnoringSafeArea(.all)
                ScrollView {
                    ForEach(viewModel.items, id: \.id) { item in
                        DogItemView(viewModel: item).padding(EdgeInsets(top: 0, leading: 16, bottom: 20, trailing: 16))
                    }
                }
                .navigationTitle("Dogs We Love").font(.title)
                .navigationBarTitleDisplayMode(.inline)
            }
        }.onAppear(perform: {
            viewModel.loadItems()
        })
    }
}

// MARK: - Preview

#Preview {
    DogsListView(viewModel: DogListViewModelPreview())
}
