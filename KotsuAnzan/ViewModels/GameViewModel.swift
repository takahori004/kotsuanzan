import Foundation
import Combine

// MARK: - AppState

enum AppState: Equatable {
    case title
    case story
    case playing
    case gameEnd
    case homeReturn
    case mogmog
    case winter
    case result
}

// MARK: - AnswerFeedback

enum AnswerFeedback {
    case none
    case correct(trickName: String)
    case wrong(correctAnswer: Int)
}

// MARK: - GameViewModel

final class GameViewModel: ObservableObject {

    // MARK: - App State

    @Published var appState: AppState = .title

    // MARK: - Story

    @Published var storyPage: Int = 0

    let storyPanels: [(character: String, emoji: String, text: String)] = [
        ("マーモットの子", "🐹", "かあちゃん、お腹から「きゅ〜つ」って音がするよ"),
        ("母マーモット",   "🐻", "お腹が空くとね、お腹から音がするんだよ"),
        ("母マーモット",   "🐻", "坊やお手々を片方お出し"),
        ("マーモットの子", "🐹", "何だか変だな母ちゃん、これなあに？"),
        ("母マーモット",   "🐻", "それは人間の手よ。いいかい坊や、町へ行ったらね、たくさん人間の家があるからね、まず表に丸いせんべいの看板のかかっている家を探すんだよ。それが見つかったらね、トントンと戸を叩いて、こんにちはって言うんだよ。そうするとね、中から人間が、すこうし戸をあけるからね、その戸の隙間から、こっちの手、ほらこの人間の手をさし入れてね、この手で持てるだけせんべいを頂戴って言うんだよ、わかったね、決して、こっちのお手々を出しちゃ駄目よ"),
        ("せんべい屋",     "👴", "あれ？その手は、マーモットじゃないか？"),
        ("マーモットの子", "🐹", "人間の子供だよ"),
        ("せんべい屋",     "👴", "今何歳ですか？"),
        ("マーモットの子", "🐹", "(きゅ〜っ)とお腹がなりました"),
        ("せんべい屋",     "👴", "9歳？じゃあ小学３年生かな。じゃあ小３の子供なら簡単に答えられるクイズを出すからやってみて"),
        ("せんべい屋",     "👴", "60秒で、できるだけたくさん答えてみろ！"),
    ]

    // MARK: - Gameplay

    @Published var timeRemaining: Double = 60.0
    @Published var senbeiCount: Int = 0
    @Published var currentProblem: Problem?
    @Published var userInput: String = ""
    @Published var feedback: AnswerFeedback = .none
    @Published var isInputDisabled: Bool = false

    let totalTime: Double = 60.0
    let requiredMetabo: Int = 8

    private var timerCancellable: AnyCancellable?

    // MARK: - Computed

    var survived: Bool { senbeiCount >= requiredMetabo }

    var timeRatio: Double { timeRemaining / totalTime }

    // MARK: - Flow: Title → Story

    func startStory() {
        storyPage = 0
        appState = .story
    }

    func advanceStory() {
        if storyPage < storyPanels.count - 1 {
            storyPage += 1
        } else {
            beginPlaying()
        }
    }

    // MARK: - Flow: Story → Playing

    private func beginPlaying() {
        senbeiCount = 0
        timeRemaining = totalTime
        userInput = ""
        feedback = .none
        isInputDisabled = false
        loadNextProblem()
        startTimer()
        appState = .playing
    }

    private func loadNextProblem() {
        currentProblem = ProblemGenerator.generateOne()
    }

    private func startTimer() {
        timerCancellable?.cancel()
        timerCancellable = Timer.publish(every: 0.1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self else { return }
                if self.timeRemaining > 0.1 {
                    self.timeRemaining = max(0, self.timeRemaining - 0.1)
                } else {
                    self.timeRemaining = 0
                    self.stopTimer()
                    self.isInputDisabled = true
                    self.appState = .gameEnd
                }
            }
    }

    private func stopTimer() {
        timerCancellable?.cancel()
        timerCancellable = nil
    }

    // MARK: - Answer Handling

    func submitAnswer() {
        guard !isInputDisabled,
              let problem = currentProblem,
              let answer = Int(userInput) else { return }

        isInputDisabled = true
        let correct = answer == problem.answer

        if correct {
            senbeiCount += 1
            feedback = .correct(trickName: problem.trick.shortName)
        } else {
            feedback = .wrong(correctAnswer: problem.answer)
        }
        userInput = ""

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [weak self] in
            guard let self, self.appState == .playing else { return }
            self.feedback = .none
            self.isInputDisabled = false
            self.loadNextProblem()
        }
    }

    // MARK: - Post-game transitions

    func goToHomeReturn() { appState = .homeReturn }
    func goToMogmog()     { appState = .mogmog }
    func goToWinter()     { appState = .winter }
    func goToResult()     { appState = .result }
    func goToTitle()      {
        stopTimer()
        appState = .title
    }

    // MARK: - Number Input

    func appendDigit(_ d: String) {
        guard !isInputDisabled, userInput.count < 4 else { return }
        if userInput == "0" { userInput = d; return }
        userInput += d
    }

    func deleteDigit() {
        guard !isInputDisabled, !userInput.isEmpty else { return }
        userInput.removeLast()
    }

    func clearInput() {
        guard !isInputDisabled else { return }
        userInput = ""
    }
}
