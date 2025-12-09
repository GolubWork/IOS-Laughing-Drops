import Foundation
import SwiftUI

struct DayHistory: Codable, Identifiable {
    var id = UUID()
    var date: Date
    var amount: Int
}

@MainActor
class HistoryStore: ObservableObject {
    @Published var todayML: Int = 0 {
        didSet { updateTodayHistory() }
    }
    @Published var dailyGoal: Int = 2000
    @Published var history: [DayHistory] = []
    @Published var lastNDatesCache: [(Date, Int)] = []

    private let keyToday = "todayML"
    private let keyGoal = "dailyGoal"
    private let keyHistory = "history"
    private let keyLastDate = "lastDate"

    private let chartDays = 30

    init() {
        load()
        checkNewDay()
        updateLastNDates()
    }

    // MARK: - Computed
    var progress: Double { min(Double(todayML) / Double(dailyGoal), 1) }
    var goalReached: Bool { todayML >= dailyGoal }

    func amount(for date: Date) -> Int {
        if Calendar.current.isDateInToday(date) { return todayML }
        return history.first(where: { Calendar.current.isDate($0.date, inSameDayAs: date) })?.amount ?? 0
    }

    // MARK: - Add / Remove water
    func add(amount: Int) {
        todayML += amount
        save()
        updateLastNDates()
    }

    func remove(amount: Int) {
        todayML = max(todayML - amount, 0)
        save()
        updateLastNDates()
    }

    private func updateTodayHistory() {
        let today = Date()
        if let index = history.firstIndex(where: { Calendar.current.isDate($0.date, inSameDayAs: today) }) {
            history[index].amount = todayML
        } else {
            history.append(DayHistory(date: today, amount: todayML))
        }
        history.sort { $0.date < $1.date }
    }

    // MARK: - New day check
    func checkNewDay() {
        let lastDate = UserDefaults.standard.object(forKey: keyLastDate) as? Date ?? Date()
        if !Calendar.current.isDateInToday(lastDate) {
            if todayML > 0 {
                history.append(DayHistory(date: lastDate, amount: todayML))
            }
            todayML = 0
            save()
        }
        UserDefaults.standard.set(Date(), forKey: keyLastDate)
        updateLastNDates()
    }

    // MARK: - Save / Load
    private func save() {
        UserDefaults.standard.set(todayML, forKey: keyToday)
        UserDefaults.standard.set(dailyGoal, forKey: keyGoal)
        if let data = try? JSONEncoder().encode(history) {
            UserDefaults.standard.set(data, forKey: keyHistory)
        }
    }

    private func load() {
        todayML = UserDefaults.standard.integer(forKey: keyToday)
        dailyGoal = UserDefaults.standard.integer(forKey: keyGoal)
        if dailyGoal == 0 { dailyGoal = 2000 }
        if let data = UserDefaults.standard.data(forKey: keyHistory),
           let decoded = try? JSONDecoder().decode([DayHistory].self, from: data) {
            history = decoded
        }
    }

    // MARK: - Last N days for chart
    private func updateLastNDates() {
        let calendar = Calendar.current
        var result: [(Date, Int)] = []
        for i in (0..<chartDays).reversed() {
            if let date = calendar.date(byAdding: .day, value: -i, to: Date()) {
                result.append((date, amount(for: date)))
            }
        }
        lastNDatesCache = result
    }

    // MARK: - Streaks
    func streak(days: Int) -> Bool {
        guard days > 0 else { return false }
        var streakCount = 0
        let calendar = Calendar.current
        for i in 0..<days {
            guard let date = calendar.date(byAdding: .day, value: -i, to: Date()) else { continue }
            if amount(for: date) >= dailyGoal { streakCount += 1 }
            else { break }
        }
        return streakCount >= days
    }

    func perfectWeek() -> Bool {
        var successDays = 0
        let calendar = Calendar.current
        for i in 0..<7 {
            guard let date = calendar.date(byAdding: .day, value: -i, to: Date()) else { continue }
            if amount(for: date) >= dailyGoal { successDays += 1 }
        }
        return successDays == 7
    }
}
