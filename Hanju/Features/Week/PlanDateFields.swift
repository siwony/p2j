import SwiftUI

struct PlanDateFields: View {
    @Binding var day: LocalDate
    @Binding var time: LocalTime?
    var range: ClosedRange<LocalDate>?
    @Environment(\.timeZone) private var timeZone

    var body: some View {
        Group {
            if let range {
                DatePicker("날짜", selection: dateBinding, in: range.lowerBound.pickerDate...range.upperBound.pickerDate, displayedComponents: .date)
                    .environment(\.timeZone, .gmt)
                    .environment(\.calendar, LocalDate.calendar(in: .gmt))
            } else {
                DatePicker("날짜", selection: dateBinding, displayedComponents: .date)
                    .environment(\.timeZone, .gmt)
                    .environment(\.calendar, LocalDate.calendar(in: .gmt))
            }
            Toggle("시각 정하기", isOn: hasTime)
            if time != nil {
                DatePicker("시각", selection: timeBinding, displayedComponents: .hourAndMinute)
                    .environment(\.timeZone, .gmt)
                    .environment(\.calendar, LocalDate.calendar(in: .gmt))
                if let explanation = time?.resolve(on: day, in: timeZone)?.explanation {
                    Text(explanation).font(.footnote).foregroundStyle(DesignTokens.textSecondary)
                }
            }
        }
    }
    private var dateBinding: Binding<Date> {
        Binding(get: { day.pickerDate }, set: { day = LocalDate($0, timeZone: .gmt) })
    }
    private var hasTime: Binding<Bool> {
        Binding(get: { time != nil }, set: { time = $0 ? LocalTime(hour: 12, minute: 0) : nil })
    }
    private var timeBinding: Binding<Date> {
        Binding(get: { day.pickerDate.addingTimeInterval(TimeInterval((time?.minutes ?? 720) - 720) * 60) }, set: {
            let parts = LocalDate.calendar(in: .gmt).dateComponents([.hour, .minute], from: $0)
            time = LocalTime(hour: parts.hour ?? 12, minute: parts.minute ?? 0)
        })
    }
}

/// Native cancellation semantics shared by week drafts, preserving the editing view and its controls.
struct PlanDismissal: ViewModifier {
    let dirty: Bool
    let onDiscard: () -> Void
    @Binding var confirming: Bool

    func body(content: Content) -> some View {
        content
            .interactiveDismissDisabled(dirty)
            .background(UnsavedChangesGuard(isDirty: dirty) { confirming = true }.frame(width: 0, height: 0))
            .confirmationDialog("변경한 내용을 버릴까요?", isPresented: $confirming, titleVisibility: .visible) {
                Button("계속 편집") { confirming = false }
                Button("변경 버리기", role: .destructive, action: onDiscard)
            } message: { Text("저장하지 않은 변경만 사라져요.") }
    }
}
