import SwiftUI

struct HomeReturnView: View {
    @ObservedObject var viewModel: GameViewModel

    var body: some View {
        ZStack {
            Color.orange.opacity(0.10).ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                // 母子
                HStack(spacing: -20) {
                    Text("🐹")
                        .font(.system(size: 90))
                        .offset(y: 10)
                    Text("🐻")
                        .font(.system(size: 80))
                }
                .padding(.bottom, 28)

                // セリフ
                VStack(spacing: 20) {
                    dialogBubble(
                        speaker: "マーモットの子",
                        text: "おかあちゃん！\nせんべいが \(viewModel.senbeiCount)枚 もらえたよ！",
                        color: .orange
                    )
                    dialogBubble(
                        speaker: "母マーモット",
                        text: "よくやった！\nさあ、食べよう！",
                        color: .brown
                    )
                }
                .padding(.horizontal, 24)

                Spacer()

                Button {
                    viewModel.goToMogmog()
                } label: {
                    Text("もぐもぐタイムへ 🍘")
                        .font(.title3).fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20)
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(16)
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 48)
            }
        }
    }

    private func dialogBubble(speaker: String, text: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(speaker)
                .font(.caption).fontWeight(.semibold).foregroundColor(color)
            Text(text)
                .font(.title3).fontWeight(.bold)
                .multilineTextAlignment(.leading)
                .padding(.horizontal, 16).padding(.vertical, 12)
                .background(Color(.systemBackground))
                .cornerRadius(14)
                .shadow(color: .black.opacity(0.05), radius: 4, y: 2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
