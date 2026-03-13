import Foundation

// MARK: - Operation

enum Operation: String {
    case addition       = "＋"
    case multiplication = "×"
}

// MARK: - TrickType (MVP 5種)

enum TrickType: String, CaseIterable {
    case combineTo100   // 合体して100: 43+57=100
    case cross100       // 100をまたぐ: 97+46
    case doubles        // 真ん中の数: 46+46
    case times10Adjust  // 10倍して戻す: ×5, ×9, ×11
    case magic25        // 25の魔法: 24×25=600

    var shortName: String {
        switch self {
        case .combineTo100:  return "合体して100"
        case .cross100:      return "100をまたぐ"
        case .doubles:       return "真ん中の数"
        case .times10Adjust: return "10倍して戻す"
        case .magic25:       return "25の魔法"
        }
    }

    var hint: String {
        switch self {
        case .combineTo100:
            return "2つを足すと100！\n十の位を足して、一の位で100にしよう"
        case .cross100:
            return "もう少しで100！\n100まで計算して、残りを足そう"
        case .doubles:
            return "同じ数が2つ！\n×2で一発で出せるよ"
        case .times10Adjust:
            return "×5は÷2×10　×9は×10-1　×11は×10+1"
        case .magic25:
            return "25×4=100！\n÷4してから×100しよう"
        }
    }
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
        "\(operand1)  \(operation.rawValue)  \(operand2)"
    }
}
