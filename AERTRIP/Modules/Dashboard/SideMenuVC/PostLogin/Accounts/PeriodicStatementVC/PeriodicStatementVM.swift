//
//  ViewAllHotelsVM.swift
//  AERTRIP
//
//  Created by Admin on 07/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

protocol PeriodicStatementVMDelegate: class {

}

class PeriodicStatementVM {
    
    //MARK:- Properties
    //MARK:- Public
    var periodicEvents: JSONDictionary = JSONDictionary()
    var allYears: [String] {
        return Array(periodicEvents.keys).sorted(by: { $0 > $1 })
    }
    
    var allTabs: [ATCategoryItem] {
        return self.allYears.map { (year) -> ATCategoryItem in
            var item = ATCategoryItem()
            item.title = year
            return item
        }
    }
    
    weak var delegate: PeriodicStatementVMDelegate? = nil
    
    //MARK:- Private
    
    
    //MARK:- Methods
    //MARK:- Private
    
    //MARK:- Public
    
}
