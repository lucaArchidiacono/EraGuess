//
//  Duration+.swift
//
//
//  Created by Luca Archidiacono on 30.04.2024.
//

import Foundation

@available(macOS 13.0, *)
public extension Duration {
    var isFinite: Bool {
        timeInterval.isFinite
    }

    var timeInterval: TimeInterval {
        TimeInterval(components.seconds) + (TimeInterval(components.attoseconds) * 1e-18)
    }

    var milliseconds: Int {
        Int(components.seconds.saturatingMultiplication(1000)) + Int(Double(components.attoseconds) * 1e-15)
    }

    static func minutes(_ minutes: Int) -> Duration {
        .seconds(minutes.saturatingMultiplication(60))
    }

    static func hours(_ hours: Int) -> Duration {
        .seconds(hours.saturatingMultiplication(3600))
    }

    static func days(_ days: Int) -> Duration {
        .seconds(days.saturatingMultiplication(86400))
    }
}

@available(macOS 13.0, *)
public extension Duration {
    static func + (lhs: DispatchWallTime, rhs: Duration) -> DispatchWallTime {
        lhs + rhs.timeInterval
    }

    static func * (lhs: Duration, rhs: Double) -> Duration {
        let milliseconds = lhs.timeInterval * rhs * 1000

        let maxTruncated = min(milliseconds, Double(Int.max).nextDown)
        let bothTruncated = max(maxTruncated, Double(Int.min).nextUp)

        return .milliseconds(Int(bothTruncated))
    }

    static func + (lhs: Duration, rhs: TimeInterval) -> Duration {
        .milliseconds(lhs.milliseconds.saturatingAddition(Int(rhs * 1000)))
    }

    static func - (lhs: Duration, rhs: TimeInterval) -> Duration {
        .milliseconds(lhs.milliseconds.saturatingSubtraction(Int(rhs * 1000)))
    }

    static func >= (lhs: TimeInterval, rhs: Duration) -> Bool {
        lhs >= rhs.timeInterval
    }

    static func <= (lhs: TimeInterval, rhs: Duration) -> Bool {
        lhs <= rhs.timeInterval
    }

    static func < (lhs: TimeInterval, rhs: Duration) -> Bool {
        lhs < rhs.timeInterval
    }

    static func > (lhs: TimeInterval, rhs: Duration) -> Bool {
        lhs > rhs.timeInterval
    }
}
