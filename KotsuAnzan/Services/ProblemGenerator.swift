import Foundation

// MARK: - ProblemGenerator

enum ProblemGenerator {

    /// ゲーム中に1問ずつ呼び出す
    static func generateOne() -> Problem {
        let trick = TrickType.allCases.randomElement()!
        return makeProblem(trick: trick)
    }

    private static func makeProblem(trick: TrickType) -> Problem {
        switch trick {
        case .combineTo100:  return combineTo100()
        case .cross100:      return cross100()
        case .doubles:       return doubles()
        case .times10Adjust: return times10Adjust()
        case .magic25:       return magic25()
        }
    }

    // MARK: - 一の位で10: 一の位が10になる組み合わせ (例: 43+57, 28+32)

    private static func combineTo100() -> Problem {
        let a = Int.random(in: 11...49)
        let b = 100 - a
        let flip = Bool.random()
        return Problem(
            operand1: flip ? a : b,
            operand2: flip ? b : a,
            operation: .addition,
            trick: .combineTo100
        )
    }

    // MARK: - 100をまたぐ: 97+46

    private static func cross100() -> Problem {
        let a = Int.random(in: 88...99)
        let b = Int.random(in: 12...35)
        let flip = Bool.random()
        return Problem(
            operand1: flip ? a : b,
            operand2: flip ? b : a,
            operation: .addition,
            trick: .cross100
        )
    }

    // MARK: - 真ん中の数（2倍）: 46+46

    private static func doubles() -> Problem {
        let a = Int.random(in: 12...49)
        return Problem(
            operand1: a,
            operand2: a,
            operation: .addition,
            trick: .doubles
        )
    }

    // MARK: - 10倍して戻す: ×5, ×9, ×11

    private static func times10Adjust() -> Problem {
        switch Int.random(in: 0...2) {
        case 0: // ×5: 偶数 × 5 → ÷2×10
            let a = Int.random(in: 6...18) * 2   // 12..36
            return Problem(operand1: a, operand2: 5, operation: .multiplication, trick: .times10Adjust)
        case 1: // ×9: a×9 = a×10 - a
            let a = Int.random(in: 11...19)
            return Problem(operand1: a, operand2: 9, operation: .multiplication, trick: .times10Adjust)
        default: // ×11: a×11 = a×10 + a
            let a = Int.random(in: 11...19)
            return Problem(operand1: a, operand2: 11, operation: .multiplication, trick: .times10Adjust)
        }
    }

    // MARK: - 25の魔法: 24×25 = 6×100 = 600

    private static func magic25() -> Problem {
        let a = Int.random(in: 2...9) * 4   // 4の倍数: 8, 12, 16, 20, 24, 28, 32, 36
        return Problem(
            operand1: a,
            operand2: 25,
            operation: .multiplication,
            trick: .magic25
        )
    }
}
