import Foundation

// MARK: - ProblemGenerator

enum ProblemGenerator {

    // MARK: - Public Interface

    static func generate(operation: Operation?, count: Int) -> [Problem] {
        (0..<count).compactMap { _ in
            let op = operation ?? (Bool.random() ? .addition : .multiplication)
            return makeProblem(operation: op)
        }
    }

    // MARK: - Dispatch

    private static func makeProblem(operation: Operation) -> Problem {
        switch operation {
        case .addition:       return makeAdditionProblem()
        case .multiplication: return makeMultiplicationProblem()
        }
    }

    // MARK: - Addition Problems

    private static func makeAdditionProblem() -> Problem {
        let tricks: [TrickType] = [.onesSum10, .onesSum10, .roundNearest10, .doubles]
        switch tricks.randomElement()! {
        case .onesSum10:      return onesSum10()
        case .roundNearest10: return roundNearest10()
        default:              return doubles()
        }
    }

    /// 一の位を足すと10になる: 48+52, 37+63
    /// コツ: 一の位が足して10になるので繰り上がりが確定し、十の位だけ計算すればいい
    private static func onesSum10() -> Problem {
        let tensA = Int.random(in: 1...7)
        let onesA = Int.random(in: 1...9)
        let tensB = Int.random(in: 1...7)
        let onesB = 10 - onesA          // onesA + onesB = 10 が確定

        return Problem(
            operand1: tensA * 10 + onesA,
            operand2: tensB * 10 + onesB,
            operation: .addition,
            trick: .onesSum10
        )
    }

    /// 片方を切りのいい数に丸めて計算: 39+47 → 40+47-1
    /// 一の位が8か9のものを選ぶ
    private static func roundNearest10() -> Problem {
        let nearValues = [19, 29, 38, 39, 48, 49, 58, 59, 68, 69, 78, 79, 88, 89, 98, 99]
        let a = nearValues.randomElement()!
        let b = Int.random(in: 21...79)
        // shuffle so operand order varies
        let flip = Bool.random()
        return Problem(
            operand1: flip ? a : b,
            operand2: flip ? b : a,
            operation: .addition,
            trick: .roundNearest10
        )
    }

    /// 同じ数を2回足す: 46+46 = 46×2
    private static func doubles() -> Problem {
        let a = Int.random(in: 12...49)
        return Problem(
            operand1: a,
            operand2: a,
            operation: .addition,
            trick: .doubles
        )
    }

    // MARK: - Multiplication Problems

    private static func makeMultiplicationProblem() -> Problem {
        let tricks: [TrickType] = [.timesBy5, .timesBy25, .nearRound, .splitAround25, .repeatedDoubling]
        switch tricks.randomElement()! {
        case .timesBy5:         return timesBy5()
        case .timesBy25:        return timesBy25()
        case .nearRound:        return nearRound()
        case .splitAround25:    return splitAround25()
        default:                return repeatedDoubling()
        }
    }

    /// ×5 → ÷2×10: 46×5 = 23×10 = 230
    /// 偶数を掛け算することで割り切れる
    private static func timesBy5() -> Problem {
        // 偶数を選ぶ（÷2が割り切れるように）
        let a = Int.random(in: 6...19) * 2   // 12, 14, ..., 38
        return Problem(operand1: a, operand2: 5, operation: .multiplication, trick: .timesBy5)
    }

    /// ×25 → ÷4×100: 44×25 = 11×100 = 1100
    /// 4の倍数を選ぶ
    private static func timesBy25() -> Problem {
        let a = Int.random(in: 3...9) * 4    // 12, 16, 20, 24, 28, 32, 36
        return Problem(operand1: a, operand2: 25, operation: .multiplication, trick: .timesBy25)
    }

    /// 切りのいい数に近い: 19×8 = 20×8 - 8
    private static func nearRound() -> Problem {
        // 一の位が1,2,8,9のもの → 切りのいい数に近い
        let candidates = [19, 21, 29, 31, 39, 41, 49, 51, 18, 22, 28, 32, 38, 42]
        let a = candidates.randomElement()!
        let b = Int.random(in: 3...9)
        return Problem(operand1: a, operand2: b, operation: .multiplication, trick: .nearRound)
    }

    /// 25に近い数に分解: 26×8 = 25×8 + 1×8 = 200+8 = 208
    private static func splitAround25() -> Problem {
        let offsets = [-3, -2, -1, 1, 2, 3]
        let offset = offsets.randomElement()!
        let a = 25 + offset         // 22〜28
        let b = Int.random(in: 3...8)
        return Problem(operand1: a, operand2: b, operation: .multiplication, trick: .splitAround25)
    }

    /// 2倍を繰り返す: 24×4 = 48×2 = 96 / 13×8 = 26×4 = 52×2 = 104
    private static func repeatedDoubling() -> Problem {
        let a = Int.random(in: 11...24)
        let b = [4, 8].randomElement()!
        return Problem(operand1: a, operand2: b, operation: .multiplication, trick: .repeatedDoubling)
    }
}
