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
    var allYears: [String] {
//        return ["2018-19"]
        return ["2018-19", "2017-18", "2016-17", "2015-16", "2014-15", "2013-14", "2012-13"]
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
