//
//  PeriodicStatementListVM.swift
//  AERTRIP
//
//  Created by Admin on 07/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

protocol PeriodicStatementListVMDelegate: class {
    func fetchMonthsForGivenYearSuccess()
}

class PeriodicStatementListVM {
    
    //MARK:- Properties
    //MARK:- Public
    var currentFinYear = ""
    private(set) var allDates: [String] = []
    weak var delegate: PeriodicStatementListVMDelegate?
    //MARK:- Private
    
    
    //MARK:- Methods
    //MARK:- Private
    private func getMonthsForFinancialYear(year: String) -> [String] {
        
        var months: [String] = []
        var onlyYear = year
        guard onlyYear.count >= 4 else {fatalError("Please pass year like: 2018 or 2018-19")}
        if  year.contains("-"), let obj = year.components(separatedBy: "-").first, obj.count == 4 {
            onlyYear = obj
        }
        
        //String to Date Convert
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY"
        guard let date = dateFormatter.date(from: onlyYear) else {return months}
        
        let allMonths = Calendar.current.shortMonthSymbols // 12
        
        if let newD = date.add(years: 1) {
            let startYear = dateFormatter.string(from: newD)
            for idx in 3...11 {
                //start year
                months.append("\(allMonths[idx]) \(startYear)")
            }
        }
        
        if let newD = date.add(years: 2) {
            let endYear = dateFormatter.string(from: newD)
            for idx in 0...2 {
                //end year
                months.append("\(allMonths[idx]) \(endYear)")
            }
        }
        
        return months
    }
    //MARK:- Public
    func fetchMonthsForGivenYear() {
        self.allDates = self.getMonthsForFinancialYear(year: self.currentFinYear)
//        self.delegate?.fetchMonthsForGivenYearSuccess()
    }
    
    //MARK:- Action
}
