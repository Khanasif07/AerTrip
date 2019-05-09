//
//  PeriodicStatementListVM.swift
//  AERTRIP
//
//  Created by Admin on 07/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

protocol PeriodicStatementListVMDelegate: class {

}

class PeriodicStatementListVM {
    
    //MARK:- Properties
    //MARK:- Public
    var statementDetails: JSONDictionary = JSONDictionary()
    var allDates: [String] {
        return Array(statementDetails.keys)
    }
    
    weak var delegate: PeriodicStatementListVMDelegate?
    //MARK:- Private
    
    
    //MARK:- Methods
    //MARK:- Private
    
    //MARK:- Public
    
    //MARK:- Action
}
