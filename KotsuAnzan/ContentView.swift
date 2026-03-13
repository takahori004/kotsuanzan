import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = GameViewModel()

    var body: some View {
        Group {
            switch viewModel.appState {
            case .title:
                HomeView(viewModel: viewModel)
            case .story:
                StoryView(viewModel: viewModel)
            case .playing:
                GameView(viewModel: viewModel)
            case .gameEnd:
                GameEndView(viewModel: viewModel)
            case .homeReturn:
                HomeReturnView(viewModel: viewModel)
            case .mogmog:
                MogmogView(viewModel: viewModel)
            case .winter:
                WinterView(viewModel: viewModel)
            case .result:
                ResultView(viewModel: viewModel)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: viewModel.appState)
    }
}
