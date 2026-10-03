import SwiftUI

struct RoutineRow: View {
    let routine: RoutineSnapshot

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(routine.draft.name)
                .font(.body)
                .foregroundStyle(DesignTokens.textPrimary)
            if !details.isEmpty {
                Text(details)
                    .font(.subheadline)
                    .foregroundStyle(DesignTokens.textSecondary)
            }
        }
        .padding(.vertical, 4)
        .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
        .accessibilityElement(children: .combine)
    }

    private var details: String {
        var parts: [String] = []
        if !routine.draft.expectedMinutesText.isEmpty { parts.append("예상 \(routine.draft.expectedMinutesText)분") }
        if !routine.draft.weeklyFrequencyText.isEmpty { parts.append("주 \(routine.draft.weeklyFrequencyText)회") }
        return parts.joined(separator: " · ")
    }
}
