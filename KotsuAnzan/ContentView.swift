import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = GameViewModel()

    var body: some View {
        Group {
            switch viewModel.gameState {
            case .home:
                HomeView(viewModel: viewModel)
            case .playing:
                GameView(viewModel: viewModel)
            case .result:
                ResultView(viewModel: viewModel)
            }
        }
        .animation(.easeInOut(duration: 0.25), value: viewModel.gameState)
    }
}
