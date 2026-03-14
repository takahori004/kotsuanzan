import SwiftUI

struct StoryView: View {
    @ObservedObject var viewModel: GameViewModel

    private let bgColors: [Color] = [
        Color.orange.opacity(0.15),
        Color.brown.opacity(0.12),
        Color.brown.opacity(0.12),
        Color.brown.opacity(0.12),
        Color.brown.opacity(0.12),
        Color.blue.opacity(0.10),
        Color.blue.opacity(0.10),
        Color.blue.opacity(0.10),
        Color.blue.opacity(0.10),
        Color.blue.opacity(0.10),
        Color.yellow.opacity(0.20),
    ]

    var body: some View {
        let page = viewModel.storyPage
        let panel = viewModel.storyPanels[page]
        let bg = bgColors[min(page, bgColors.count - 1)]

        ZStack {
            bg.ignoresSafeArea()

            VStack(spacing: 0) {
                // ページ番号
                HStack {
                    Text("\(page + 1) / \(viewModel.storyPanels.count)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 16)

                Spacer()

                // キャラクター絵
                Text(panel.emoji)
                    .font(.system(size: 120))
                    .padding(.bottom, 24)

                // 吹き出し
                VStack(spacing: 8) {
                    Text(panel.character)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)

                    Text(panel.text)
                        .font(.title2)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 20)
                        .background(Color(.systemBackground))
                        .cornerRadius(20)
                        .shadow(color: .black.opacity(0.06), radius: 8, y: 4)
                }
                .padding(.horizontal, 24)

                Spacer()

                // 次へボタン
                Button {
                    viewModel.advanceStory()
                } label: {
                    let isLast = page == viewModel.storyPanels.count - 1
                    Text(isLast ? "よし！やってみる！" : "つぎへ →")
                        .font(.title3)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20)
                        .background(isLast ? Color.orange : Color.brown)
                        .foregroundColor(.white)
                        .cornerRadius(16)
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 48)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: page)
    }
}
