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
    var yearData: JSONDictionary = JSONDictionary()
    var allDates: [String] {
        return Array(yearData.keys).sorted(by: { $0 < $1 })
    }
    
    weak var delegate: PeriodicStatementListVMDelegate?
    //MARK:- Private
    
    
    //MARK:- Methods
    //MARK:- Private

    //MARK:- Public

    
    //MARK:- Action
}
