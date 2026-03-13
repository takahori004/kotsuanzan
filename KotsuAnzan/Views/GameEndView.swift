import SwiftUI

struct GameEndView: View {
    @ObservedObject var viewModel: GameViewModel

    var body: some View {
        ZStack {
            Color.blue.opacity(0.08).ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                Text("👴")
                    .font(.system(size: 100))
                    .padding(.bottom, 24)

                VStack(spacing: 12) {
                    Text("「まあいいだろう。")
                        .font(.title2).fontWeight(.bold)
                    Text("せんべいを持っていきな！」")
                        .font(.title2).fontWeight(.bold)
                }
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .padding(.bottom, 40)

                // せんべい枚数
                VStack(spacing: 8) {
                    Text("🍘 × \(viewModel.senbeiCount)")
                        .font(.system(size: 64, weight: .bold, design: .rounded))
                        .foregroundColor(.brown)
                    Text("枚もらえた！")
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 28)
                .padding(.horizontal, 40)
                .background(Color(.systemBackground))
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.06), radius: 8, y: 4)
                .padding(.horizontal, 32)

                Spacer()

                Button {
                    viewModel.goToHomeReturn()
                } label: {
                    Text("家に帰ろう！")
                        .font(.title3).fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20)
                        .background(Color.brown)
                        .foregroundColor(.white)
                        .cornerRadius(16)
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 48)
            }
        }
    }
}
