//
//  StatsViewModel.swift
//  Leaf
//
//  Created by Ahmed-Zayne El husseini on 13/5/2025.
//
import SwiftUI

class StatsViewModel: ObservableObject {
    @Published var dayStreak: Int = 0
    @Published var pagesThisWeek: Int = 0
    @Published var booksThisYear: Int = 0
    @Published var weeklyBarData: [(day: String, percent: CGFloat, pages: Int)] = []
    @Published var booksCompleted: Int = 0
    let readingGoal = 24
    
    var bookProvider: (() -> [Book])?

    var booksCompletedText: String {
        "\(booksCompleted) of \(readingGoal) books completed"
    }

    var progressText: String {
        booksCompleted >= (readingGoal / 2) ? "On track" : "Behind"
    }

    init() {
        loadStreak()
        loadPagesThisWeek()
        
        NotificationCenter.default.addObserver(forName: .didLogReading, object: nil, queue: .main) { _ in
            self.loadStreak()
            self.loadPagesThisWeek()
            
            if let books = self.bookProvider?() {
                self.loadBooksThisYear(from: books)
            }
        }
    }

    func loadStreak() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let lastDate = UserDefaults.standard.object(forKey: "lastReadDate") as? Date
        let streak = UserDefaults.standard.integer(forKey: "dayStreak")

        if let last = lastDate {
            let lastDay = calendar.startOfDay(for: last)
            let daysBetween = calendar.dateComponents([.day], from: lastDay, to: today).day ?? 0

            switch daysBetween {
            case 0:
                dayStreak = streak
            case 1:
                dayStreak = streak + 1
            default:
                dayStreak = 1
            }
        } else {
            dayStreak = 1
        }

        UserDefaults.standard.set(today, forKey: "lastReadDate")
        UserDefaults.standard.set(dayStreak, forKey: "dayStreak")
    }
    
    func loadPagesThisWeek() {
        let calendar = Calendar.current
        let today = Date()
        let weekStart = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today))!

        guard let savedData = UserDefaults.standard.array(forKey: "readingSessions") as? [[String: Any]] else {
            pagesThisWeek = 0
            weeklyBarData = []
            return
        }

        let sessions: [(Date, Int)] = savedData.compactMap { entry in
            if let date = entry["date"] as? Date,
               let pages = entry["pages"] as? Int {
                return (date, pages)
            }
            return nil
        }

        var totals: [String: Int] = [:]
        let days = calendar.shortWeekdaySymbols

        for session in sessions {
            let date = session.0
            if date >= weekStart {
                let weekday = calendar.component(.weekday, from: date)
                let key = days[weekday - 1]
                totals[key, default: 0] += session.1
            }
        }

        let maxPages = totals.values.max() ?? 1

        weeklyBarData = days.map { day in
            let value = totals[day, default: 0]
            let percent = CGFloat(value) / CGFloat(maxPages)
            return (day, percent, value)
        }

        pagesThisWeek = sessions.filter { calendar.startOfDay(for: $0.0) >= weekStart }
                                .map { $0.1 }
                                .reduce(0, +)
    }
    
    func loadBooksThisYear(from books: [Book]) {
        let calendar = Calendar.current
        let year = 2025

        booksThisYear = books.filter {
            $0.status == "Finished" &&
            $0.completionDate != nil &&
            calendar.component(.year, from: $0.completionDate!) == year
        }.count
    }
}
