import SwiftUI

struct MogmogView: View {
    @ObservedObject var viewModel: GameViewModel
    @State private var metaboVisible: Int = 0

    var body: some View {
        ZStack {
            Color.yellow.opacity(0.12).ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                Text("🐹")
                    .font(.system(size: 100))
                    .padding(.bottom, 4)

                Text("もぐもぐ…")
                    .font(.title).fontWeight(.bold)
                    .padding(.bottom, 32)

                // せんべいグリッド
                senbeiGrid
                    .padding(.horizontal, 32)
                    .padding(.bottom, 32)

                // メタボメーター
                metaboMeter
                    .padding(.horizontal, 32)

                Spacer()

                Button {
                    viewModel.goToWinter()
                } label: {
                    Text("冬将軍が来る前に準備！")
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
        .onAppear {
            withAnimation(.easeInOut(duration: 1.2)) {
                metaboVisible = viewModel.senbeiCount
            }
        }
    }

    // せんべいアイコン一覧
    private var senbeiGrid: some View {
        let count = viewModel.senbeiCount
        let cols = min(count, 10)
        return VStack(alignment: .center, spacing: 4) {
            if count == 0 {
                Text("せんべい0枚…")
                    .foregroundColor(.secondary)
            } else {
                let rows = (count + cols - 1) / cols
                ForEach(0..<rows, id: \.self) { row in
                    HStack(spacing: 4) {
                        ForEach(0..<cols, id: \.self) { col in
                            let idx = row * cols + col
                            if idx < count {
                                Text("🍘").font(.title2)
                            }
                        }
                    }
                }
            }
        }
    }

    // メタボメーター
    private var metaboMeter: some View {
        VStack(spacing: 8) {
            HStack {
                Text("メタボメーター")
                    .font(.headline)
                Spacer()
                Text("\(metaboVisible) / \(viewModel.requiredMetabo) 必要")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule().fill(Color(.systemGray5)).frame(height: 28)
                    Capsule()
                        .fill(metaboColor)
                        .frame(
                            width: min(geo.size.width * Double(metaboVisible) / Double(max(viewModel.requiredMetabo, 1)), geo.size.width),
                            height: 28
                        )
                    Text("💪".repeated(min(metaboVisible / 2 + 1, 5)))
                        .font(.caption)
                        .padding(.leading, 8)
                }
            }
            .frame(height: 28)
        }
    }

    private var metaboColor: Color {
        if metaboVisible >= viewModel.requiredMetabo { return .green }
        if metaboVisible >= viewModel.requiredMetabo / 2 { return .orange }
        return .red
    }
}

private extension String {
    func repeated(_ times: Int) -> String {
        String(repeating: self, count: max(0, times))
    }
}
