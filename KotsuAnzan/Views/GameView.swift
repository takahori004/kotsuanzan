import SwiftUI

struct GameView: View {
    @ObservedObject var viewModel: GameViewModel

    var body: some View {
        VStack(spacing: 0) {
            progressHeader
                .padding(.top, 8)
                .padding(.horizontal)

            Spacer()

            if let problem = viewModel.currentProblem {
                problemCard(problem)
                    .padding(.horizontal)

                Spacer()

                answerDisplay
                    .padding(.horizontal)

                Spacer()

                if viewModel.isAnswered {
                    resultFeedback(problem)
                    nextButton
                        .padding(.horizontal)
                        .padding(.bottom, 32)
                } else {
                    numberPad
                        .padding(.horizontal)
                        .padding(.bottom, 32)
                }
            }
        }
    }

    // MARK: - Progress Header

    private var progressHeader: some View {
        VStack(spacing: 6) {
            HStack {
                Text("\(viewModel.currentIndex + 1) / \(viewModel.problems.count)問目")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Spacer()
                Text("\(viewModel.correctCount)問正解")
                    .font(.subheadline)
                    .foregroundColor(.blue)
                    .fontWeight(.medium)
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color(.systemGray5))
                        .frame(height: 8)
                    Capsule()
                        .fill(Color.blue)
                        .frame(width: geo.size.width * viewModel.progress, height: 8)
                        .animation(.spring(response: 0.4), value: viewModel.progress)
                }
            }
            .frame(height: 8)
        }
    }

    // MARK: - Problem Card

    private func problemCard(_ problem: Problem) -> some View {
        VStack(spacing: 14) {
            // コツバッジ
            HStack {
                Image(systemName: "lightbulb.fill")
                    .font(.caption)
                Text(problem.trick.shortHint)
                    .font(.caption)
                    .fontWeight(.semibold)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 7)
            .background(Color.orange.opacity(0.15))
            .foregroundColor(.orange)
            .clipShape(Capsule())

            // 問題式
            Text(problem.displayString)
                .font(.system(size: 58, weight: .bold, design: .rounded))
                .minimumScaleFactor(0.6)
                .lineLimit(1)

            Text("＝　？")
                .font(.system(size: 40, weight: .bold, design: .rounded))
                .foregroundColor(.blue)
        }
        .padding(.vertical, 28)
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(20)
    }

    // MARK: - Answer Display

    private var answerDisplay: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14)
                .fill(Color(.tertiarySystemBackground))
                .frame(height: 76)
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color(.systemGray4), lineWidth: 1)
                )

            if viewModel.userInput.isEmpty {
                Text("答えを入力してね")
                    .font(.title3)
                    .foregroundColor(Color(.systemGray3))
            } else {
                Text(viewModel.userInput)
                    .font(.system(size: 46, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
            }
        }
    }

    // MARK: - Result Feedback

    private func resultFeedback(_ problem: Problem) -> some View {
        let correct = viewModel.lastResult?.isCorrect ?? false
        return VStack(spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: correct ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .font(.title2)
                    .foregroundColor(correct ? .green : .red)
                if correct {
                    Text("正解！　\(problem.answer)")
                        .font(.title3).fontWeight(.bold).foregroundColor(.green)
                } else {
                    Text("不正解…正解は \(problem.answer)")
                        .font(.title3).fontWeight(.bold).foregroundColor(.red)
                }
            }

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Image(systemName: "lightbulb.fill").foregroundColor(.orange)
                    Text("コツ").fontWeight(.bold).foregroundColor(.orange)
                }
                .font(.subheadline)
                Text(problem.trick.hint)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.orange.opacity(0.1))
            .cornerRadius(12)
            .padding(.horizontal)
        }
        .padding(.bottom, 12)
    }

    // MARK: - Next Button

    private var nextButton: some View {
        Button {
            viewModel.advance()
        } label: {
            Text(viewModel.isLastProblem ? "結果を見る 🎉" : "次の問題 →")
                .font(.title3)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(14)
        }
    }

    // MARK: - Number Pad

    private var numberPad: some View {
        VStack(spacing: 10) {
            ForEach([[7, 8, 9], [4, 5, 6], [1, 2, 3]], id: \.self) { row in
                HStack(spacing: 10) {
                    ForEach(row, id: \.self) { digit in
                        digitKey(String(digit))
                    }
                }
            }

            HStack(spacing: 10) {
                // Clear
                Button {
                    viewModel.clearInput()
                } label: {
                    Text("C")
                        .frame(maxWidth: .infinity)
                        .frame(height: 68)
                        .background(Color.red.opacity(0.12))
                        .foregroundColor(.red)
                        .font(.title2).fontWeight(.semibold)
                        .cornerRadius(14)
                }

                digitKey("0")

                // Delete
                Button {
                    viewModel.deleteDigit()
                } label: {
                    Image(systemName: "delete.left")
                        .frame(maxWidth: .infinity)
                        .frame(height: 68)
                        .background(Color(.secondarySystemBackground))
                        .foregroundColor(.primary)
                        .font(.title2)
                        .cornerRadius(14)
                }
            }

            // Submit
            Button {
                viewModel.submitAnswer()
            } label: {
                Text("決定")
                    .font(.title2).fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .frame(height: 68)
                    .background(viewModel.userInput.isEmpty ? Color.gray.opacity(0.4) : Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(14)
            }
            .disabled(viewModel.userInput.isEmpty)
        }
    }

    private func digitKey(_ digit: String) -> some View {
        Button {
            viewModel.appendDigit(digit)
        } label: {
            Text(digit)
                .font(.system(size: 26, weight: .semibold, design: .rounded))
                .frame(maxWidth: .infinity)
                .frame(height: 68)
                .background(Color(.secondarySystemBackground))
                .foregroundColor(.primary)
                .cornerRadius(14)
        }
    }
}
