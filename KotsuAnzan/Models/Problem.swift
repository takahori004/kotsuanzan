import Foundation

// MARK: - Operation

enum Operation: String {
    case addition = "＋"
    case multiplication = "×"
}

// MARK: - TrickType

enum TrickType: String, CaseIterable {
    // 足し算のコツ
    case onesSum10        // 一の位が足すと10: 48+52
    case roundNearest10   // 近くの切りのいい数に丸める: 39+47 → 40+47-1
    case doubles          // 同じ数の2倍: 46+46

    // 掛け算のコツ
    case timesBy5         // ×5 → ÷2×10: 46×5=230
    case timesBy25        // ×25 → ÷4×100: 44×25=1100
    case nearRound        // 切りのいい数に近い: 19×8=20×8-8
    case splitAround25    // 25に近い数に分解: 26×8=25×8+8
    case repeatedDoubling // 2倍を繰り返す: 24×4=48×2=96

    /// ヒントのタイトル（短め）
    var shortHint: String {
        switch self {
        case .onesSum10:        return "一の位の和が10"
        case .roundNearest10:   return "丸めて計算"
        case .doubles:          return "2倍で計算"
        case .timesBy5:         return "÷2して×10"
        case .timesBy25:        return "÷4して×100"
        case .nearRound:        return "丸めて引く"
        case .splitAround25:    return "25に分解"
        case .repeatedDoubling: return "2倍を繰り返す"
        }
    }

    /// ヒントの詳細説明
    var hint: String {
        switch self {
        case .onesSum10:
            return "一の位を足すと10になる組み合わせ！\n十の位はそのまま足して、一の位は繰り上がりで10にしよう"
        case .roundNearest10:
            return "一方を切りのいい数に直して計算！\n例：39+47 → 40+47=87、87-1=86"
        case .doubles:
            return "同じ数を2回足すのは「×2」と同じ！\nかけ算で一発で出せるよ"
        case .timesBy5:
            return "×5のコツ：÷2してから×10！\n例：46×5 → 46÷2=23、23×10=230"
        case .timesBy25:
            return "×25のコツ：÷4してから×100！\n例：44×25 → 44÷4=11、11×100=1100"
        case .nearRound:
            return "切りのいい数に近い！丸めて計算してから調整！\n例：19×8 → 20×8=160、160-8=152"
        case .splitAround25:
            return "25に近い数に分解！\n例：26×8 → 25×8+1×8 = 200+8=208"
        case .repeatedDoubling:
            return "×4は「2倍の2倍」、×8は「2倍の2倍の2倍」！\n例：24×4 → 48×2=96"
        }
    }
}

// MARK: - GameResult

struct GameResult: Identifiable {
    let id = UUID()
    let problem: Problem
    let userAnswer: Int
    let isCorrect: Bool
}

// MARK: - Problem

struct Problem: Identifiable {
    let id = UUID()
    let operand1: Int
    let operand2: Int
    let operation: Operation
    let trick: TrickType

    var answer: Int {
        switch operation {
        case .addition:       return operand1 + operand2
        case .multiplication: return operand1 * operand2
        }
    }

    var displayString: String {
        "\(operand1) \(operation.rawValue) \(operand2)"
    }
}
