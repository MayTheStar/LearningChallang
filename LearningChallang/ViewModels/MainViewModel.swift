
import SwiftUI

class MainViewModel: ObservableObject {
    @Published var currentDate = Date()
    @Published var streakCount = 0
    @Published var frozenCount = 0
    @Published var totalFreezesUsed = 0
    @Published var logStatus: LogStatus = .logToday
    @Published var selectedDate = Date()
    @Published var learningDays: Set<Date> = []
    @Published var freezeDays: Set<Date> = []
    @Published var isMonthlyView = false
    @Published var isTodayLoggedAsLearned: Bool = false

    var goal: String

    enum LogStatus {
        case logToday
        case learnedToday
        case freezedToday
    }
    
    var foregroundColorForStatus: Color {
        switch logStatus {
        case .logToday:
            return Color.black
        case .learnedToday:
            return Color.orange
        case .freezedToday:
            return Color.blue.opacity(0.8)
        }
    }
    

    var backgroundColorForStatus: Color {
        switch logStatus {
        case .logToday:
            return Color.orange
        case .learnedToday:
            return Color.brown1
        case .freezedToday:
            return Color.blue1
        }
    }
        
    
    init(goal: String) {
        self.goal = goal.isEmpty ? "Learning Swift" : goal
        loadSavedData()
        updateDate()
        calculateStreak()
    }

    var freezeLimit: Int {
        return 6
    }

    // MARK: - Data Loading and Persistence
    func loadSavedData() {
        if let savedLearningDays = UserDefaults.standard.array(forKey: "learningDays") as? [TimeInterval] {
            learningDays = Set(savedLearningDays.map { Date(timeIntervalSince1970: $0) })
        }

        if let savedFreezeDays = UserDefaults.standard.array(forKey: "freezeDays") as? [TimeInterval] {
            freezeDays = Set(savedFreezeDays.map { Date(timeIntervalSince1970: $0) })
        }

        if learningDays.contains(currentDate) {
            isTodayLoggedAsLearned = true
            logStatus = .learnedToday
        } else if freezeDays.contains(currentDate) {
            logStatus = .freezedToday
        } else {
            logStatus = .logToday
        }

        calculateStreak()
    }

    private func saveLearningAndFreezeDays() {
        UserDefaults.standard.set(learningDays.map { $0.timeIntervalSince1970 }, forKey: "learningDays")
        UserDefaults.standard.set(freezeDays.map { $0.timeIntervalSince1970 }, forKey: "freezeDays")
    }

    // MARK: - Date and Streak Management
    func updateDate() {
        currentDate = Date()
    }

    func calculateStreak() {
        let sortedDates = learningDays.sorted(by: { $0 < $1 })
        var currentStreak = 0
        var lastDate: Date?

        for date in sortedDates {
            if let lastDate = lastDate, Calendar.current.isDate(date, inSameDayAs: Calendar.current.date(byAdding: .day, value: 1, to: lastDate)!) {
                currentStreak += 1
            } else {
                currentStreak = 1
            }
            lastDate = date
        }

        streakCount = currentStreak
    }

    // MARK: - Log and Freeze Handlers
    func handleLogAction() {
        if !isTodayLoggedAsLearned {
            isTodayLoggedAsLearned = true
            learningDays.insert(currentDate)
            logStatus = .learnedToday
            saveLearningAndFreezeDays()
            calculateStreak()
        }
    }

    func handleFreezeAction() {
        if frozenCount < freezeLimit {
            frozenCount += 1
            totalFreezesUsed += 1
            freezeDays.insert(currentDate)
            logStatus = .freezedToday
            if isTodayLoggedAsLearned {
                isTodayLoggedAsLearned = false
            }
            saveLearningAndFreezeDays()
        }
    }

    // MARK: - Date Display Formatting
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE d MMM"
        return formatter.string(from: currentDate)
    }

    func monthAndYearString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: currentDate)
    }

    func weekdayString(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: date)
    }

    func dayNumber(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }

    // MARK: - Calendar Date Calculations
    func currentWeekDates() -> [Date] {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: currentDate)
        let startOfWeek = calendar.date(byAdding: .day, value: -weekday + 1, to: currentDate)!

        return (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: startOfWeek) }
    }

    func currentMonthDates() -> [Date] {
        let calendar = Calendar.current
        let range = calendar.range(of: .day, in: .month, for: currentDate)!
        let components = calendar.dateComponents([.year, .month], from: currentDate)

        return range.compactMap { day -> Date? in
            calendar.date(from: DateComponents(year: components.year, month: components.month, day: day))
        }
    }

    // MARK: - View Toggles and Navigation
    func toggleView() {
        isMonthlyView.toggle()
    }

    func previousPeriod() {
        if isMonthlyView {
            currentDate = Calendar.current.date(byAdding: .month, value: -1, to: currentDate)!
        } else {
            currentDate = Calendar.current.date(byAdding: .day, value: -7, to: currentDate)!
        }
    }

    func nextPeriod() {
        if isMonthlyView {
            currentDate = Calendar.current.date(byAdding: .month, value: 1, to: currentDate)!
        } else {
            currentDate = Calendar.current.date(byAdding: .day, value: 7, to: currentDate)!
        }
    }
}
