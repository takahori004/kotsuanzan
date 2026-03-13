import SwiftUI

// タイトル画面（旧HomeViewをTitleViewとして流用）
struct HomeView: View {
    @ObservedObject var viewModel: GameViewModel

    var body: some View {
        ZStack {
            Color(.systemBackground).ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                // キャラクター
                Text("🐹")
                    .font(.system(size: 100))
                    .padding(.bottom, 8)

                // タイトル
                VStack(spacing: 6) {
                    Text("マーモット")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundColor(.brown)
                    Text("コツ暗算")
                        .font(.system(size: 52, weight: .bold, design: .rounded))
                    Text("工夫して計算しよう！")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.top, 4)
                }
                .padding(.bottom, 16)

                // せんべいアイコン
                HStack(spacing: 4) {
                    ForEach(0..<5) { _ in Text("🍘").font(.title3) }
                }
                .padding(.bottom, 48)

                Spacer()

                // スタートボタン
                Button {
                    viewModel.startStory()
                } label: {
                    Text("はじめる！")
                        .font(.title2)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 22)
                        .background(Color.brown)
                        .foregroundColor(.white)
                        .cornerRadius(18)
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 48)
            }
        }
    }
}
