//
//  PeriodicStatementEvent.swift
//  AERTRIP
//
//  Created by Admin on 22/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

extension Date {
    var monthsForFinancialYear: [String] {
        
        var months: [String] = []
        
        //String to Date Convert
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY"
        
        let date = self
        let allMonths = Calendar.current.shortMonthSymbols // 12
        
        let startYear = dateFormatter.string(from: date)
        for idx in 3...11 {
            //start year
            months.append("\(allMonths[idx]) \(startYear)")
        }
        
        if let newD = date.add(years: 1) {
            let endYear = dateFormatter.string(from: newD)
            for idx in 0...2 {
                //end year
                months.append("\(allMonths[idx]) \(endYear)")
            }
        }
        
        return months
    }
}

struct PeriodicStatementEvent {
    var id: String = ""
    var statementDate: Date?
    var periodFrom: Date?
    var periodTo: Date?
    var dueDate: Date?
    
    //title is not coming from api, we need to show it as "Statement 1"
    var title: String = ""
    
    var periodTitle: String {
        let from = self.periodFrom?.toString(dateFormat: "d MMM ") ?? LocalizedString.na.localized
        let to = self.periodTo?.toString(dateFormat: "d MMM ") ?? LocalizedString.na.localized
        
        return "\(from) - \(to)"
    }
    
    var statementMonth: String? {
        if let date = statementDate {
            return date.toString(dateFormat: "MM MMM YYYY")
        }
        return nil
    }
    
    var statementMonthToMatch:String?{
        if let date = statementDate {
            return date.toString(dateFormat: "MMM YYYY")
        }
        return nil
    }
    
    var statementYear: String? {
        
        if let date = statementDate, let monthWithYear = self.statementMonth,let newMonth =  statementMonthToMatch{
            
            if date.monthsForFinancialYear.contains(monthWithYear) || date.monthsForFinancialYear.contains(newMonth){
                //srart with current year
                let start = date.toString(dateFormat: "YYYY")
                
                var end = ""
                if let newD = date.add(years: 1) {
                    end = newD.toString(dateFormat: "YY")
                }
                
                return end.isEmpty ? start : "\(start)-\(end)"
            }
            else {
                //end with current year
                let end = date.toString(dateFormat: "YY")
                
                var start = ""
                if let newD = date.add(years: -1) {
                    start = newD.toString(dateFormat: "YYYY")
                }
                
                return start.isEmpty ? end : "\(start)-\(end)"
            }
        }
        return nil
    }
    
    init(json: JSONDictionary) {
        
        if let obj = json["id"] {
            self.id = "\(obj)"
        }
        
        if let obj = json["statement_date"] {
            //"2018-02-15 00:00:00"
            self.statementDate = "\(obj)".toDate(dateFormat: "YYYY-MM-dd HH:mm:ss")
        }
        
        if let obj = json["period_from"] {
            //"2018-02-08"
            self.periodFrom = "\(obj)".toDate(dateFormat: "YYYY-MM-dd")
        }
        
        if let obj = json["period_to"] {
            //"2018-02-08"
            self.periodTo = "\(obj)".toDate(dateFormat: "YYYY-MM-dd")
        }
        
        if let obj = json["due_date"] {
            //"2018-02-15 00:00:00"
            self.dueDate = "\(obj)".toDate(dateFormat: "YYYY-MM-dd HH:mm:ss")
        }
    }
    
    
    static func modelsDict(data: [JSONDictionary]) -> JSONDictionary {
        var finalTemp = JSONDictionary()
        
        for dict in data {
            var event = PeriodicStatementEvent(json: dict)
            if let sYear = event.statementYear, let sMonth = event.statementMonth {
                
                var newTemp = (finalTemp[sYear] as? JSONDictionary) ?? JSONDictionary()
                if let yrData = finalTemp[sYear] as? JSONDictionary, !yrData.isEmpty, var monthData = yrData[sMonth] as? [PeriodicStatementEvent], !monthData.isEmpty {
                    //already there, update only
                    
                    monthData.append(event)
                    
                    //sort the data according to the from date
                    newTemp[sMonth] = monthData.sorted(by: { ($0.periodFrom?.timeIntervalSince1970 ?? 0) < ($1.periodFrom?.timeIntervalSince1970 ?? 0) })
                }
                else {
                    //create new one
                    event.title = "Statement 1"
                    newTemp[sMonth] = [event]
                }
                
                finalTemp[sYear] = newTemp
            }
        }
        
        return finalTemp
    }
    
}
