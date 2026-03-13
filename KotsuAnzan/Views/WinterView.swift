import SwiftUI

struct WinterView: View {
    @ObservedObject var viewModel: GameViewModel

    var body: some View {
        ZStack {
            Color.indigo.opacity(0.15).ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                Text("❄️")
                    .font(.system(size: 80))
                    .padding(.bottom, 8)

                Text("冬将軍がやってきた！")
                    .font(.title).fontWeight(.bold)
                    .padding(.bottom, 4)

                Text("マーモットは冬眠に入った…")
                    .font(.title3)
                    .foregroundColor(.secondary)
                    .padding(.bottom, 40)

                // 睡眠中マーモット
                Text("😴🐹💤")
                    .font(.system(size: 60))
                    .padding(.bottom, 40)

                // 生存チェック
                survivalCard
                    .padding(.horizontal, 32)

                Spacer()

                Button {
                    viewModel.goToResult()
                } label: {
                    Text("春になった…")
                        .font(.title3).fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20)
                        .background(Color.indigo)
                        .foregroundColor(.white)
                        .cornerRadius(16)
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 48)
            }
        }
    }

    private var survivalCard: some View {
        VStack(spacing: 16) {
            Text("冬眠に必要な脂肪")
                .font(.headline)
                .foregroundColor(.secondary)

            HStack(spacing: 20) {
                statBox(label: "蓄えた脂肪", value: "\(viewModel.senbeiCount)", emoji: "💪",
                        color: viewModel.survived ? .green : .red)
                Text("vs")
                    .font(.title2).fontWeight(.bold).foregroundColor(.secondary)
                statBox(label: "必要な脂肪", value: "\(viewModel.requiredMetabo)", emoji: "🌨️",
                        color: .indigo)
            }

            Text(viewModel.survived ? "足りてる！🌸" : "足りない…😢")
                .font(.title3).fontWeight(.bold)
                .foregroundColor(viewModel.survived ? .green : .red)
        }
        .padding(20)
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.06), radius: 8, y: 4)
    }

    private func statBox(label: String, value: String, emoji: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Text(emoji).font(.title2)
            Text(value)
                .font(.system(size: 36, weight: .bold, design: .rounded))
                .foregroundColor(color)
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}
