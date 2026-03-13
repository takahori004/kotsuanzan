import SwiftUI

struct GameView: View {
    @ObservedObject var viewModel: GameViewModel

    var body: some View {
        VStack(spacing: 0) {
            header
                .padding(.horizontal)
                .padding(.top, 12)

            Spacer()

            if let problem = viewModel.currentProblem {
                problemCard(problem)
                    .padding(.horizontal)
            }

            Spacer()

            feedbackArea
                .padding(.horizontal)
                .frame(height: 52)

            Spacer(minLength: 8)

            numberPad
                .padding(.horizontal)
                .padding(.bottom, 24)
        }
    }

    // MARK: - Header (タイマー + せんべいカウント)

    private var header: some View {
        HStack(alignment: .top, spacing: 12) {
            // タイマー
            VStack(alignment: .leading, spacing: 4) {
                Text(String(format: "%.1f", viewModel.timeRemaining))
                    .font(.system(size: 42, weight: .bold, design: .monospaced))
                    .foregroundColor(timerColor)
                    .animation(.none, value: viewModel.timeRemaining)
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule().fill(Color(.systemGray5)).frame(height: 6)
                        Capsule()
                            .fill(timerColor)
                            .frame(width: geo.size.width * viewModel.timeRatio, height: 6)
                            .animation(.linear(duration: 0.1), value: viewModel.timeRatio)
                    }
                }
                .frame(height: 6)
            }

            Spacer()

            // せんべいカウント
            VStack(alignment: .trailing, spacing: 2) {
                Text("🍘")
                    .font(.system(size: 36))
                Text("×  \(viewModel.senbeiCount)")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundColor(.brown)
            }
        }
    }

    private var timerColor: Color {
        if viewModel.timeRemaining > 20 { return .green }
        if viewModel.timeRemaining > 10 { return .orange }
        return .red
    }

    // MARK: - Problem Card

    private func problemCard(_ problem: Problem) -> some View {
        VStack(spacing: 12) {
            // コツバッジ
            HStack(spacing: 4) {
                Image(systemName: "lightbulb.fill").font(.caption2)
                Text(problem.trick.shortName).font(.caption).fontWeight(.semibold)
            }
            .padding(.horizontal, 12).padding(.vertical, 6)
            .background(Color.orange.opacity(0.15))
            .foregroundColor(.orange)
            .clipShape(Capsule())

            // 問題式
            Text(problem.displayString)
                .font(.system(size: 52, weight: .bold, design: .rounded))
                .minimumScaleFactor(0.6)
                .lineLimit(1)

            // 入力表示
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.tertiarySystemBackground))
                    .frame(height: 64)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(.systemGray4), lineWidth: 1)
                    )
                if viewModel.userInput.isEmpty {
                    Text("？").font(.system(size: 36, weight: .bold)).foregroundColor(.secondary)
                } else {
                    Text(viewModel.userInput)
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                }
            }
            .padding(.horizontal, 40)
        }
        .padding(.vertical, 24)
        .padding(.horizontal, 16)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(20)
    }

    // MARK: - Feedback Area

    private var feedbackArea: some View {
        Group {
            switch viewModel.feedback {
            case .none:
                Color.clear
            case .correct(let trickName):
                HStack(spacing: 8) {
                    Image(systemName: "checkmark.circle.fill").foregroundColor(.green)
                    Text("正解！").fontWeight(.bold).foregroundColor(.green)
                    Text("🍘 +1")
                    Text("コツ：\(trickName)").font(.caption).foregroundColor(.secondary)
                }
                .font(.subheadline)
                .transition(.scale.combined(with: .opacity))
            case .wrong(let ans):
                HStack(spacing: 8) {
                    Image(systemName: "xmark.circle.fill").foregroundColor(.red)
                    Text("不正解").fontWeight(.bold).foregroundColor(.red)
                    Text("正解は \(ans)").font(.subheadline)
                }
                .font(.subheadline)
                .transition(.scale.combined(with: .opacity))
            }
        }
        .animation(.spring(response: 0.3), value: feedbackKey)
    }

    private var feedbackKey: Int {
        switch viewModel.feedback {
        case .none: return 0
        case .correct: return 1
        case .wrong: return 2
        }
    }

    // MARK: - Number Pad

    private var numberPad: some View {
        VStack(spacing: 8) {
            ForEach([[7, 8, 9], [4, 5, 6], [1, 2, 3]], id: \.self) { row in
                HStack(spacing: 8) {
                    ForEach(row, id: \.self) { d in digitKey(String(d)) }
                }
            }
            HStack(spacing: 8) {
                actionKey(label: "C", color: .red.opacity(0.12), fg: .red) { viewModel.clearInput() }
                digitKey("0")
                actionKey(label: "⌫", color: Color(.secondarySystemBackground), fg: .primary) { viewModel.deleteDigit() }
            }

            // 決定ボタン
            Button { viewModel.submitAnswer() } label: {
                Text("決定")
                    .font(.title2).fontWeight(.bold)
                    .frame(maxWidth: .infinity).frame(height: 60)
                    .background(viewModel.userInput.isEmpty || viewModel.isInputDisabled
                                ? Color.gray.opacity(0.3) : Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(14)
            }
            .disabled(viewModel.userInput.isEmpty || viewModel.isInputDisabled)
        }
    }

    private func digitKey(_ digit: String) -> some View {
        Button { viewModel.appendDigit(digit) } label: {
            Text(digit)
                .font(.system(size: 24, weight: .semibold, design: .rounded))
                .frame(maxWidth: .infinity).frame(height: 60)
                .background(Color(.secondarySystemBackground))
                .foregroundColor(.primary)
                .cornerRadius(14)
        }
    }

    private func actionKey(label: String, color: Color, fg: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(label)
                .font(.title3).fontWeight(.semibold)
                .frame(maxWidth: .infinity).frame(height: 60)
                .background(color)
                .foregroundColor(fg)
                .cornerRadius(14)
        }
    }
}
