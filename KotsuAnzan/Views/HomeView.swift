import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: GameViewModel
    @State private var selectedMode: GameMode = .mixed
    @State private var selectedCount: Int = 10

    private let counts = [10, 20, 30]

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            // MARK: Title
            VStack(spacing: 6) {
                Text("コツ暗算")
                    .font(.system(size: 52, weight: .bold, design: .rounded))
                Text("工夫して計算しよう！")
                    .font(.title3)
                    .foregroundColor(.secondary)
            }
            .padding(.bottom, 48)

            Spacer()

            // MARK: Mode Picker
            VStack(alignment: .leading, spacing: 10) {
                Label("種類", systemImage: "slider.horizontal.3")
                    .font(.headline)
                    .foregroundColor(.secondary)

                HStack(spacing: 10) {
                    ForEach(GameMode.allCases, id: \.self) { mode in
                        ModeButton(
                            mode: mode,
                            isSelected: selectedMode == mode
                        ) {
                            selectedMode = mode
                        }
                    }
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 24)

            // MARK: Count Picker
            VStack(alignment: .leading, spacing: 10) {
                Label("問題数", systemImage: "list.number")
                    .font(.headline)
                    .foregroundColor(.secondary)

                HStack(spacing: 10) {
                    ForEach(counts, id: \.self) { count in
                        Button {
                            selectedCount = count
                        } label: {
                            Text("\(count)問")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 18)
                                .background(
                                    selectedCount == count
                                        ? Color.orange
                                        : Color(.secondarySystemBackground)
                                )
                                .foregroundColor(selectedCount == count ? .white : .primary)
                                .cornerRadius(14)
                        }
                    }
                }
            }
            .padding(.horizontal)

            Spacer()

            // MARK: Start Button
            Button {
                viewModel.startGame(mode: selectedMode, count: selectedCount)
            } label: {
                Text("スタート！")
                    .font(.title2)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(16)
            }
            .padding(.horizontal)
            .padding(.bottom, 40)
        }
    }
}

// MARK: - ModeButton

private struct ModeButton: View {
    let mode: GameMode
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: mode.icon)
                    .font(.title2)
                Text(mode.rawValue)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(isSelected ? Color.blue : Color(.secondarySystemBackground))
            .foregroundColor(isSelected ? .white : .primary)
            .cornerRadius(14)
        }
    }
}
