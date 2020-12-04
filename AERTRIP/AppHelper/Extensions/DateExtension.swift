//
//  DateExtention.swift
//
//  Created by Pramod Kumar on 19/09/17.
//  Copyright © 2017 Pramod Kumar. All rights reserved.
//

import Foundation

extension Date {
    var isToday: Bool {
        return Calendar.current.isDateInToday(self)
    }
    
    var isYesterday: Bool {
        return Calendar.current.isDateInYesterday(self)
    }
    
    var isTomorrow: Bool {
        return Calendar.current.isDateInTomorrow(self)
    }
    
    var isWeekend: Bool {
        return Calendar.current.isDateInWeekend(self)
    }
    
    var isCurrentYear: Bool {
        return Date().year == self.year
    }
    
    var year: Int {
        return (Calendar.current as NSCalendar).components(.year, from: self).year ?? 0
    }
    
    var month: Int {
        return (Calendar.current as NSCalendar).components(.month, from: self).month ?? 0
    }
    
    var weekOfYear: Int {
        return (Calendar.current as NSCalendar).components(.weekOfYear, from: self).weekOfYear ?? 0
    }
    
    var weekday: Int {
        return (Calendar.current as NSCalendar).components(.weekday, from: self).weekday ?? 0
    }
    
    var weekdayOrdinal: Int {
        return (Calendar.current as NSCalendar).components(.weekdayOrdinal, from: self).weekdayOrdinal ?? 0
    }
    
    var weekOfMonth: Int {
        return (Calendar.current as NSCalendar).components(.weekOfMonth, from: self).weekOfMonth ?? 0
    }
    
    var day: Int {
        return (Calendar.current as NSCalendar).components(.day, from: self).day ?? 0
    }
    
    var hour: Int {
        return (Calendar.current as NSCalendar).components(.hour, from: self).hour ?? 0
    }
    
    var minute: Int {
        return (Calendar.current as NSCalendar).components(.minute, from: self).minute ?? 0
    }
    
    var second: Int {
        return (Calendar.current as NSCalendar).components(.second, from: self).second ?? 0
    }
    
    var numberOfWeeks: Int {
        let weekRange = (Calendar.current as NSCalendar).range(of: .weekOfYear, in: .month, for: Date())
        return weekRange.length
    }
    
    var unixTimestamp: Double {
        return timeIntervalSince1970
    }
    
    var age: Int {
        let calendar: Calendar = Calendar.current
        let unitFlags: NSCalendar.Unit = [NSCalendar.Unit.year, NSCalendar.Unit.month, NSCalendar.Unit.day]
        let dateComponentNow: DateComponents = (calendar as NSCalendar).components(unitFlags, from: Date())
        let dateComponentBirth: DateComponents = (calendar as NSCalendar).components(unitFlags, from: self)
        
        if ((dateComponentNow.month ?? 0) < (dateComponentBirth.month ?? 0)) ||
            (((dateComponentNow.month ?? 0) == (dateComponentBirth.month ?? 0)) && ((dateComponentNow.day ?? 0) < (dateComponentBirth.day ?? 0))) {
            return (dateComponentNow.year ?? 0) - (dateComponentBirth.year ?? 0) - 1
        } else {
            return (dateComponentNow.year ?? 0) - (dateComponentBirth.year ?? 0)
        }
    }
    
    var morningOrEvening : String{
         let hour = Calendar.current.component(.hour, from: self)
         switch hour {
            case 0..<12 : return "Morning"
            case 12 : return "Afternoon"
            case 13..<17 : return "Afternoon"
            case 17..<24 : return "Evening"
            default: return "Evening"
         }
     }
    
    func yearsFrom(_ date: Date) -> Int {
        return (Calendar.current as NSCalendar).components(.year, from: date, to: self, options: []).year ?? 0
    }
    
    func monthsFrom(_ date: Date) -> Int {
        return (Calendar.current as NSCalendar).components(.month, from: date, to: self, options: []).month ?? 0
    }
    
    func weeksFrom(_ date: Date) -> Int {
        return (Calendar.current as NSCalendar).components(.weekOfYear, from: date, to: self, options: []).weekOfYear ?? 0
    }
    
    func weekdayFrom(_ date: Date) -> Int {
        return (Calendar.current as NSCalendar).components(.weekday, from: date, to: self, options: []).weekday ?? 0
    }
    
    func weekdayOrdinalFrom(_ date: Date) -> Int {
        return (Calendar.current as NSCalendar).components(.weekdayOrdinal, from: date, to: self, options: []).weekdayOrdinal ?? 0
    }
    
    func weekOfMonthFrom(_ date: Date) -> Int {
        return (Calendar.current as NSCalendar).components(.weekOfMonth, from: date, to: self, options: []).weekOfMonth ?? 0
    }
    
    func daysFrom(_ date: Date) -> Int {
        return (Calendar.current as NSCalendar).components(.day, from: date, to: self, options: []).day ?? 0
    }
    
    func hoursFrom(_ date: Date) -> Int {
        return (Calendar.current as NSCalendar).components(.hour, from: date, to: self, options: []).hour ?? 0
    }
    
    func minutesFrom(_ date: Date) -> Int {
        return (Calendar.current as NSCalendar).components(.minute, from: date, to: self, options: []).minute ?? 0
    }
    
    func secondsFrom(_ date: Date) -> Int {
        return (Calendar.current as NSCalendar).components(.second, from: date, to: self, options: []).second ?? 0
    }
    
    func offsetFrom(_ date: Date) -> String {
        if yearsFrom(date) > 0 { return "\(yearsFrom(date))y" }
        if monthsFrom(date) > 0 { return "\(monthsFrom(date))M" }
        if weeksFrom(date) > 0 { return "\(weeksFrom(date))w" }
        if daysFrom(date) > 0 { return "\(daysFrom(date))d" }
        if hoursFrom(date) > 0 { return "\(hoursFrom(date))h" }
        if minutesFrom(date) > 0 { return "\(minutesFrom(date))m" }
        if secondsFrom(date) > 0 { return "\(secondsFrom(date))s" }
        return ""
    }
    
    /// Converts a given Date into String based on the date format and timezone provided
    func toString(dateFormat: String, timeZone: TimeZone = TimeZone.current) -> String {
        let frmtr = DateFormatter()
        frmtr.locale = Locale(identifier: "en_US_POSIX")
        frmtr.dateFormat = dateFormat
        frmtr.timeZone = timeZone
        return frmtr.string(from: self)
    }
    
    fileprivate func dateComponents() -> DateComponents {
        let calander = Calendar.current
        return (calander as NSCalendar).components([.second, .minute, .hour, .day, .month, .year], from: self, to: Date(), options: [])
    }
    
    public var timeAgo: String {
        let components = dateComponents()
        
        if components.year! > 0 {
            return "\(components.year ?? 0)Y ago"
        }
        
        if components.month! > 0 {
            return "\(components.month ?? 0)M ago"
        }
        
        if components.day! >= 7 {
            let week = (components.day ?? 0) / 7
            return "\(week)W ago"
        }
        
        if components.day! > 0 {
            return "\(components.day ?? 0)d ago"
        }
        
        if components.hour! > 0 {
            return "\(components.hour ?? 0)h ago"
        }
        
        if components.minute! > 0 {
            return "\(components.minute ?? 0)m ago"
        }
        if components.second! > 10 {
            return "\(components.second ?? 0)s ago"
        }
        if components.second! < 10 {
            return "Just now"
        }
        return ""
    }
    
    var millisecondsSince1970: Int64 {
        return Int64((timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds: Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }
    
    func timeAgo(numericDates: Bool) -> String {
        let calendar = NSCalendar.current
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
        
        let earliest = NSDate().earlierDate(self)
        let now = Date()
        let latest = (earliest == now) ? self : now
        let components = calendar.dateComponents(unitFlags, from: earliest as Date, to: latest as Date)
        
        if components.year! >= 2 {
            return "\(components.year ?? 0) years ago"
        } else if (components.year ?? 0) >= 1 {
            if numericDates {
                return "1 year ago"
            } else {
                return "Last year"
            }
        } else if (components.month ?? 0) >= 2 {
            return "\(components.month ?? 0) months ago"
        } else if (components.month ?? 0) >= 1 {
            if numericDates {
                return "1 month ago"
            } else {
                return "Last month"
            }
        } else if (components.weekOfYear ?? 0) >= 2 {
            return "\(components.weekOfYear ?? 0) weeks ago"
        } else if (components.weekOfYear ?? 0) >= 1 {
            if numericDates {
                return "1 week ago"
            } else {
                return "Last week"
            }
        } else if (components.day ?? 0) >= 2 {
            return "\(components.day ?? 0) days ago"
        } else if (components.day ?? 0) >= 1 {
            if numericDates {
                return "1 day ago"
            } else {
                return "Yesterday"
            }
        } else if (components.hour ?? 0) >= 2 {
            return "\(components.hour ?? 0) hours ago"
        } else if (components.hour ?? 0) >= 1 {
            if numericDates {
                return "1 hour ago"
            } else {
                return "An hour ago"
            }
        } else if (components.minute ?? 0) >= 2 {
            return "\(components.minute ?? 0) minutes ago"
        } else if (components.minute ?? 0) >= 1 {
            if numericDates {
                return "1 minute ago"
            } else {
                return "A minute ago"
            }
        } else if (components.second ?? 0) >= 3 {
            return "\(components.second ?? 0) seconds ago"
        } else {
            return "Just now"
        }
    }
    
    func add(years: Int = 0, months: Int = 0, days: Int = 0, hours: Int = 0, minutes: Int = 0, seconds: Int = 0) -> Date? {
        let components = DateComponents(year: years, month: months, day: days, hour: hours, minute: minutes, second: seconds)
        return Calendar.current.date(byAdding: components, to: self)
    }
    
    func addDay(days: Int = 0) -> String? {
        let components = DateComponents(year: 0, month: 0, day: days, hour: 0, minute: 0, second: 0)
        return Calendar.current.date(byAdding: components, to: self)?.toString(dateFormat: "yyyy-MM-dd")
    }
    
    func isEqualTo(_ date: Date) -> Bool {
        return self == date
    }
    
    func isGreaterThan(_ date: Date) -> Bool {
        return self > date
    }
    
    func isSmallerThan(_ date: Date) -> Bool {
        return self < date
    }
    
    /// GetDateFromString
    static func getDateFromString(stringDate: String, currentFormat: String, requiredFormat: String) -> String? {
        // String to Date Convert
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = currentFormat
        guard let date = dateFormatter.date(from: stringDate) else { return nil }
        // CONVERT FROM Date to String
        dateFormatter.dateFormat = requiredFormat
        return dateFormatter.string(from: date)
    }
    
    // function to get date between two dates
    static func dates(from fromDate: Date, to toDate: Date) -> [Date] {
        var dates: [Date] = []
        var date = fromDate
        
        while date <= toDate {
            dates.append(date)
            guard let newDate = Calendar.current.date(byAdding: .day, value: 1, to: date) else { break }
            date = newDate
        }
        return dates
    }
    
    static func compareDate(date1:Date, date2:Date) -> Bool {
        return Calendar.current.isDate(date1, equalTo: date2, toGranularity: .day)
    }
}

extension Date {
    
    // MARK:- DATE FORMAT ENUM
    //==========================
    enum DateFormat : String {
        
        case yyyy_MM_dd = "yyyy-MM-dd"
        case yyyyMMddHHmmss = "yyyy-MM-dd HH:mm:ss"
        case yyyyMMddTHHmmssz = "yyyy-MM-dd'T'HH:mm:ssZ"
        case yyyyMMddTHHmmssssZZZZZ = "yyyy-MM-dd'T'HH:mm:ss.ssZZZZZ"
        case yyyyMMdd = "yyyy/MM/dd"
        case dMMMyyyy = "d MMM, yyyy"
        case ddMMMyyyy = "dd MMM, yyyy"
        case MMMdyyyy = "MMM d, yyyy"
        case hmmazzz = "h:mm a zzz"
        case dd = "dd"
        case mm = "MM"
        case yyyy = "YYYY"
        case EComaddMMMyy = "E, dd MMM yy"
        case ddMMM = "dd MMM"
    }
}

