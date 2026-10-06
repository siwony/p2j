import Foundation

/// A Gregorian calendar day, not a midnight instant. Sorting keys are timezone independent.
struct LocalDate: Hashable, Comparable, Codable, Identifiable {
    let year: Int
    let month: Int
    let day: Int
    var id: Int { key }
    var key: Int { year * 10_000 + month * 100 + day }

    init?(year: Int, month: Int, day: Int) {
        guard (1...9999).contains(year), (1...12).contains(month), (1...31).contains(day) else { return nil }
        let calendar = Self.calendar(in: .gmt)
        let components = DateComponents(year: year, month: month, day: day, hour: 12)
        guard let date = calendar.date(from: components),
              calendar.dateComponents([.year, .month, .day], from: date).year == year,
              calendar.component(.month, from: date) == month,
              calendar.component(.day, from: date) == day else { return nil }
        self.year = year; self.month = month; self.day = day
    }

    init?(key: Int) { self.init(year: key / 10_000, month: (key / 100) % 100, day: key % 100) }

    init(_ instant: Date, timeZone: TimeZone = .current) {
        let parts = Self.calendar(in: timeZone).dateComponents([.year, .month, .day], from: instant)
        year = parts.year ?? 1; month = parts.month ?? 1; day = parts.day ?? 1
    }

    static func < (lhs: Self, rhs: Self) -> Bool { lhs.key < rhs.key }
    static func calendar(in timeZone: TimeZone) -> Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = timeZone
        calendar.firstWeekday = 2
        calendar.minimumDaysInFirstWeek = 4
        return calendar
    }

    /// Noon UTC is used only for arithmetic/pickers. It is never persisted as the planned day.
    var pickerDate: Date {
        Self.calendar(in: .gmt).date(from: DateComponents(year: year, month: month, day: day, hour: 12)) ?? .distantPast
    }
    func adding(days: Int) -> LocalDate {
        let calendar = Self.calendar(in: .gmt)
        guard let date = calendar.date(byAdding: .day, value: days, to: pickerDate) else { return self }
        return LocalDate(date, timeZone: .gmt)
    }
    var weekday: Int { (Self.calendar(in: .gmt).component(.weekday, from: pickerDate) + 5) % 7 + 1 }
    var monday: LocalDate { adding(days: 1 - weekday) }
    var weekDays: [LocalDate] { (0..<7).map { monday.adding(days: $0) } }
    var label: String { "\(month)월 \(day)일 (\(Self.dayNames[weekday - 1]))" }
    var fullLabel: String { "\(year)년 \(label)" }
    static let dayNames = ["월", "화", "수", "목", "금", "토", "일"]
}

struct LocalTime: Hashable, Codable {
    let hour: Int
    let minute: Int
    init?(hour: Int, minute: Int) {
        guard (0...23).contains(hour), (0...59).contains(minute) else { return nil }
        self.hour = hour; self.minute = minute
    }
    init?(minutes: Int) { self.init(hour: minutes / 60, minute: minutes % 60) }
    var minutes: Int { hour * 60 + minute }
    var label: String { String(format: "%02d:%02d", hour, minute) }

    func resolve(on day: LocalDate, in timeZone: TimeZone) -> Resolution? {
        let calendar = LocalDate.calendar(in: timeZone)
        guard let noon = calendar.date(from: DateComponents(year: day.year, month: day.month, day: day.day, hour: 12)) else { return nil }
        let start = calendar.startOfDay(for: noon)
        let components = DateComponents(hour: hour, minute: minute)
        guard let first = calendar.nextDate(after: start.addingTimeInterval(-1), matching: components,
                                            matchingPolicy: .nextTime, repeatedTimePolicy: .first),
              LocalDate(first, timeZone: timeZone) == day else { return nil }
        let last = calendar.nextDate(after: start.addingTimeInterval(-1), matching: components,
                                     matchingPolicy: .nextTime, repeatedTimePolicy: .last)
        let actual = calendar.dateComponents([.hour, .minute], from: first)
        let adjusted = actual.hour != hour || actual.minute != minute
        let repeated = last != first
        let actualLabel = String(format: "%02d:%02d", actual.hour ?? hour, actual.minute ?? minute)
        let explanation: String?
        if adjusted { explanation = "시간대 변경으로 \(actualLabel)에 예정돼요. (\(timeZone.identifier))" }
        else if repeated { explanation = "두 번 있는 \(label) 중 첫 번째 시각이에요. (\(timeZone.identifier))" }
        else { explanation = nil }
        return Resolution(instant: first, explanation: explanation)
    }
    struct Resolution { let instant: Date; let explanation: String? }
}
