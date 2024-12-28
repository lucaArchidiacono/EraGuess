//
//  Date+.swift
//
//
//  Created by Luca Archidiacono on 17.07.2024.
//

import Foundation

@available(macOS 12.0, *)
public extension ParseStrategy where Self == Date.FormatStyle {
    static var iso8601_light: Date.ParseStrategy {
        Date.ParseStrategy(format: "\(year: .defaultDigits)-\(month: .defaultDigits)-\(day: .defaultDigits)",
                           locale: .current,
                           timeZone: .current)
    }
}

public extension Date {
    static var yesterday: Date { Date().dayBefore }
    static var tomorrow: Date { Date().dayAfter }
    static var oneMonthAgo: Date { Calendar.current.date(byAdding: .month, value: -1, to: .now)! }

    var dayBefore: Date {
        Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }

    var dayAfter: Date {
        Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }

    var noon: Date {
        Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }

    var month: Int {
        Calendar.current.component(.month, from: self)
    }

    var isLastDayOfMonth: Bool {
        dayAfter.month != month
    }

    var startOfMonth: Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: self)
        return calendar.date(from: components)!
    }
}
