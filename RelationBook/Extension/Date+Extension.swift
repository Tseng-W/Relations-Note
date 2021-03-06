//
//  Date+Extension.swift
//  RelationBook
//
//  Created by 曾問 on 2021/5/12.
//

import Foundation

extension Date {
  enum OutputType {
    case day
    case time
    case dayAndTime
  }

  var yesterday: Date { return Date().dayBefore }

  var tomorrow: Date { return Date().dayAfter }

  var dayBefore: Date {
    return Calendar.current.date(byAdding: .day, value: -1, to: midnight) ?? self
  }

  var dayAfter: Date {
    return Calendar.current.date(byAdding: .day, value: 1, to: midnight) ?? self
  }

  var midnight: Date {
    return Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: self) ?? self
  }

  var month: Int {
    return Calendar.current.component(.month, from: self)
  }

  var day: Int {
    return Calendar.current.component(.day, from: self)
  }

  var week: Int {
    return Calendar.current.component(.weekday, from: self)
  }

  var isLastDayOfMonth: Bool {
    return dayAfter.month != month
  }

  var millisecondsSince1970: Int64 {
    return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
  }

  var isWeekend: Bool {
    if let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian) {
      return calendar.isDateInWeekend(self)
    }

    return false
  }

  var isFirstDay: Bool {
    let calendar = Calendar(identifier: .gregorian)
    let components = calendar.dateComponents([.year, .month], from: self)

    if let firstDay = calendar.date(from: components) {
      return self == firstDay
    }
    return false
  }

  init(milliseconds: Int64) {
    self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
  }

  static var dateFormatter: DateFormatter {
    let formatter = DateFormatter()

    formatter.dateFormat = "yyyy.MM.dd HH:mm"

    return formatter
  }

  func getDayString(type: OutputType) -> String {
    let dateFormatter = DateFormatter()

    dateFormatter.locale = Locale(identifier: "zh_Hant_TW")

    switch type {
    case .day:
      dateFormatter.dateFormat = "YYYY / MM / dd"
    case .time:
      dateFormatter.dateFormat = "HH : MM"
    case .dayAndTime:
      dateFormatter.dateFormat = "YYYY / MM / dd HH : mm"
    }

    let yesterday = Date().yesterday..<Date().midnight
    let today = Date().midnight..<Date().tomorrow
    let tomorrow = Date().tomorrow...Date().tomorrow.tomorrow

    if type == .day {
      if yesterday.contains(self) {
        return "昨天"
      } else if today.contains(self) {
        return "今天"
      } else if tomorrow.contains(self) {
        return "明天"
      }
    }
    return dateFormatter.string(from: self)
  }

  func isSameDay(date: Date) -> Bool {
    return date >= midnight && date <= dayAfter
  }
}
