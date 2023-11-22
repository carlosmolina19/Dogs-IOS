import NukeUI
import SwiftUI

struct DogItemView: View {
    
    // MARK: - Private Properties
    
    private let viewModel: DogItemViewModel
    
    // MARK: - Initialization
    
    init(viewModel: DogItemViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Body
    
    var body: some View {
        ZStack(alignment: .leading) {
            HStack (alignment: .bottom, spacing: 0) {
                AsyncImage(url: viewModel.url) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 180)
                        .cornerRadius(10)
                } placeholder: {
                    ProgressView()
                        .frame(width: 120, height: 180)
                }
                
                VStack(alignment: .leading) {
                    
                    Text(viewModel.name)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundStyle(.primaryDog)
                        .padding(EdgeInsets(top: 0, leading: 16, bottom: 5, trailing: 16))
                    
                    Text(viewModel.description)
                        .font(.callout)
                        .foregroundStyle(.secondaryDog)
                        .padding(EdgeInsets(top: 0, leading: 16, bottom: 5, trailing: 16))
                    
                    Text(viewModel.age)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.primaryDog)
                        .padding(EdgeInsets(top: 0, leading: 16, bottom: 5, trailing: 16))
                }
                .frame(maxWidth: .infinity)
                .frame(height: 150)
                .background(.white)
                .cornerRadius(10)
                
            }
        }
        .frame(height: 180)
    }
}

// MARK: - Preview

#Preview {
    DogItemView(viewModel: DogItemViewModelPreview())
}
