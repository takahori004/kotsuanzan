import SwiftUI

struct ResultView: View {
    @ObservedObject var viewModel: GameViewModel

    var body: some View {
        ZStack {
            (viewModel.survived ? Color.green : Color.red).opacity(0.08).ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                // 結果
                Text(viewModel.survived ? "🌸" : "😢")
                    .font(.system(size: 100))
                    .padding(.bottom, 12)

                Text(viewModel.survived ? "春まで生き延びた！" : "おなかがへってしまった…")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .padding(.bottom, 8)

                Text(viewModel.survived
                     ? "コツを使ってうまく解けたね！"
                     : "コツを覚えてもう一度チャレンジ！")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.bottom, 40)

                // スコアカード
                scoreCard
                    .padding(.horizontal, 32)

                Spacer()

                // ボタン
                VStack(spacing: 12) {
                    Button {
                        viewModel.startStory()
                    } label: {
                        Text("もう一度チャレンジ！")
                            .font(.title3).fontWeight(.bold)
                            .frame(maxWidth: .infinity).padding(.vertical, 18)
                            .background(Color.brown)
                            .foregroundColor(.white).cornerRadius(16)
                    }

                    Button {
                        viewModel.goToTitle()
                    } label: {
                        Text("タイトルに戻る")
                            .font(.title3).fontWeight(.bold)
                            .frame(maxWidth: .infinity).padding(.vertical, 18)
                            .background(Color(.secondarySystemBackground))
                            .foregroundColor(.primary).cornerRadius(16)
                    }
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 48)
            }
        }
    }

    private var scoreCard: some View {
        VStack(spacing: 20) {
            HStack(spacing: 0) {
                scoreItem(emoji: "🍘", label: "せんべい", value: "\(viewModel.senbeiCount)枚")
                Divider().frame(height: 48)
                scoreItem(emoji: "🌨️", label: "必要な脂肪", value: "\(viewModel.requiredMetabo)")
                Divider().frame(height: 48)
                scoreItem(
                    emoji: viewModel.survived ? "✅" : "❌",
                    label: "判定",
                    value: viewModel.survived ? "生存" : "失敗"
                )
            }

            // コツ一覧ヒント
            VStack(alignment: .leading, spacing: 8) {
                Text("今回出たコツ").font(.caption).fontWeight(.semibold).foregroundColor(.secondary)
                ForEach(TrickType.allCases, id: \.self) { trick in
                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "lightbulb.fill").foregroundColor(.orange).font(.caption)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(trick.shortName).font(.caption).fontWeight(.bold)
                            Text(trick.hint).font(.caption2).foregroundColor(.secondary)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(14)
            .background(Color.orange.opacity(0.08))
            .cornerRadius(12)
        }
        .padding(20)
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.06), radius: 8, y: 4)
    }

    private func scoreItem(emoji: String, label: String, value: String) -> some View {
        VStack(spacing: 4) {
            Text(emoji).font(.title2)
            Text(value).font(.headline).fontWeight(.bold)
            Text(label).font(.caption).foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}
