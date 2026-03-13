import Foundation
import Combine

// MARK: - GameMode

enum GameMode: String, CaseIterable {
    case addition       = "足し算"
    case multiplication = "掛け算"
    case mixed          = "ミックス"

    var icon: String {
        switch self {
        case .addition:       return "plus.circle.fill"
        case .multiplication: return "multiply.circle.fill"
        case .mixed:          return "shuffle.circle.fill"
        }
    }

    var operation: Operation? {
        switch self {
        case .addition:       return .addition
        case .multiplication: return .multiplication
        case .mixed:          return nil
        }
    }
}

// MARK: - GameState

enum GameState {
    case home
    case playing
    case result
}

// MARK: - GameViewModel

final class GameViewModel: ObservableObject {

    // MARK: - Published State

    @Published var gameState: GameState = .home
    @Published var problems: [Problem] = []
    @Published var currentIndex: Int = 0
    @Published var userInput: String = ""
    @Published var results: [GameResult] = []
    @Published var isAnswered: Bool = false
    @Published var elapsedSeconds: Double = 0

    // MARK: - Session Settings (preserved for replay)

    private(set) var lastMode: GameMode = .mixed
    private(set) var lastCount: Int = 10

    // MARK: - Private

    private var startTime: Date = Date()

    // MARK: - Computed

    var currentProblem: Problem? {
        problems.indices.contains(currentIndex) ? problems[currentIndex] : nil
    }

    var progress: Double {
        problems.isEmpty ? 0 : Double(currentIndex) / Double(problems.count)
    }

    var correctCount: Int {
        results.filter(\.isCorrect).count
    }

    var lastResult: GameResult? {
        results.last
    }

    var isLastProblem: Bool {
        currentIndex + 1 >= problems.count
    }

    // MARK: - Game Flow

    func startGame(mode: GameMode, count: Int) {
        lastMode = mode
        lastCount = count
        problems = ProblemGenerator.generate(operation: mode.operation, count: count)
        currentIndex = 0
        results = []
        userInput = ""
        isAnswered = false
        startTime = Date()
        gameState = .playing
    }

    func replayGame() {
        startGame(mode: lastMode, count: lastCount)
    }

    func submitAnswer() {
        guard let problem = currentProblem,
              let answer = Int(userInput) else { return }

        let result = GameResult(
            problem: problem,
            userAnswer: answer,
            isCorrect: answer == problem.answer
        )
        results.append(result)
        isAnswered = true
    }

    func advance() {
        if isLastProblem {
            elapsedSeconds = Date().timeIntervalSince(startTime)
            gameState = .result
        } else {
            currentIndex += 1
            userInput = ""
            isAnswered = false
        }
    }

    func goHome() {
        gameState = .home
        userInput = ""
        isAnswered = false
    }

    // MARK: - Number Input

    func appendDigit(_ digit: String) {
        guard userInput.count < 5 else { return }
        // 先頭の0を除去
        if userInput == "0" { userInput = digit; return }
        userInput += digit
    }

    func deleteDigit() {
        guard !userInput.isEmpty else { return }
        userInput.removeLast()
    }

    func clearInput() {
        userInput = ""
    }
}
