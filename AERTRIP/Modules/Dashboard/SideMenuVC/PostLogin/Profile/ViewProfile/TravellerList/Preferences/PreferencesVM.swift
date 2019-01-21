//
//  PreferencesVM.swift
//  AERTRIP
//
//  Created by apple on 08/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

protocol PreferencesVMDelegate: class {
    func willSavePreferences()
    func savePreferencesSuccess()
    func savePreferencesFail(errors: ErrorCodes)
}

class PreferencesVM: NSObject {
    weak var delegate: PreferencesVMDelegate?
    
    var groups: [String] = []
    var isCategorizeByGroup : Bool = false
    var sortOrder:String = ""
    var displayOrder:String = ""

    
    func setUpData() {
        if let generalPref = UserInfo.loggedInUser?.generalPref {
            groups = generalPref.labels
            isCategorizeByGroup = generalPref.categorizeByGroup
            sortOrder = generalPref.sortOrder
            displayOrder = generalPref.displayOrder
        }
    }
    
   
    func callSavePreferencesAPI() {
        var params = JSONDictionary()
        
        params["sort_order"] = self.sortOrder
        params["display_order"] = self.displayOrder
        params["categorize_by_group"] = self.isCategorizeByGroup
        params["labels"] = self.groups
        delegate?.willSavePreferences()
        APICaller.shared.callSavePreferencesAPI(params: params) { [weak self] (success, erroCodes) in
            if success {
                self?.delegate?.savePreferencesSuccess()
            } else {
                self?.delegate?.savePreferencesFail(errors: erroCodes)
            }
        }
    }
}
