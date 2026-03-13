import SwiftUI

struct ResultView: View {
    @ObservedObject var viewModel: GameViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                scoreHeader
                timeRow
                Divider()
                problemList
                actionButtons
            }
            .padding()
        }
    }

    // MARK: - Score Header

    private var scoreHeader: some View {
        VStack(spacing: 12) {
            Text(scoreEmoji)
                .font(.system(size: 80))

            Text("\(viewModel.correctCount) / \(viewModel.problems.count) 正解")
                .font(.system(size: 36, weight: .bold, design: .rounded))

            Text(scoreMessage)
                .font(.title3)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 8)
    }

    private var scoreEmoji: String {
        let rate = scoreRate
        switch rate {
        case 1.0:         return "🏆"
        case 0.8..<1.0:   return "🎉"
        case 0.6..<0.8:   return "😊"
        case 0.4..<0.6:   return "🤔"
        default:          return "💪"
        }
    }

    private var scoreMessage: String {
        let rate = scoreRate
        switch rate {
        case 1.0:         return "全問正解！コツ名人！"
        case 0.8..<1.0:   return "すごい！よく工夫できたね"
        case 0.6..<0.8:   return "よくできました！"
        case 0.4..<0.6:   return "もう少し！コツを覚えよう"
        default:          return "練習あるのみ！諦めないで！"
        }
    }

    private var scoreRate: Double {
        guard !viewModel.problems.isEmpty else { return 0 }
        return Double(viewModel.correctCount) / Double(viewModel.problems.count)
    }

    // MARK: - Time

    private var timeRow: some View {
        HStack(spacing: 6) {
            Image(systemName: "stopwatch")
                .foregroundColor(.orange)
            Text(String(format: "%.1f秒", viewModel.elapsedSeconds))
                .fontWeight(.semibold)
            Text("で解いたよ！")
                .foregroundColor(.secondary)
        }
        .font(.title3)
    }

    // MARK: - Problem List

    private var problemList: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("問題の振り返り")
                .font(.headline)
                .foregroundColor(.secondary)

            ForEach(Array(viewModel.results.enumerated()), id: \.offset) { index, result in
                resultRow(result: result, number: index + 1)
            }
        }
    }

    private func resultRow(result: GameResult, number: Int) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Text("\(number)")
                .font(.caption)
                .foregroundColor(.secondary)
                .frame(width: 22, alignment: .center)
                .padding(.top, 2)

            Image(systemName: result.isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                .foregroundColor(result.isCorrect ? .green : .red)
                .font(.title3)
                .padding(.top, 1)

            VStack(alignment: .leading, spacing: 3) {
                Text(result.problem.displayString + " ＝ \(result.problem.answer)")
                    .font(.subheadline)
                    .fontWeight(.semibold)

                if !result.isCorrect {
                    Text("あなたの答え：\(result.userAnswer)")
                        .font(.caption)
                        .foregroundColor(.red)
                }

                HStack(spacing: 4) {
                    Image(systemName: "lightbulb.fill")
                        .font(.caption2)
                    Text(result.problem.trick.shortHint)
                        .font(.caption)
                }
                .foregroundColor(.orange)
            }

            Spacer()
        }
        .padding(12)
        .background(
            result.isCorrect
                ? Color.green.opacity(0.08)
                : Color.red.opacity(0.08)
        )
        .cornerRadius(12)
    }

    // MARK: - Action Buttons

    private var actionButtons: some View {
        VStack(spacing: 12) {
            Button {
                viewModel.replayGame()
            } label: {
                Label("もう一度チャレンジ！", systemImage: "arrow.clockwise")
                    .font(.title3).fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(14)
            }

            Button {
                viewModel.goHome()
            } label: {
                Label("ホームに戻る", systemImage: "house")
                    .font(.title3).fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(Color(.secondarySystemBackground))
                    .foregroundColor(.primary)
                    .cornerRadius(14)
            }
        }
        .padding(.bottom, 16)
    }
}
