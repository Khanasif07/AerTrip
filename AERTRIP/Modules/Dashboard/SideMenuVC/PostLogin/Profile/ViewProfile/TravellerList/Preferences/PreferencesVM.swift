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
    var removedGroups: [String] = []
    var isCategorizeByGroup : Bool = false
    var sortOrder:String = ""
    var displayOrder:String = ""
    var modifiedGroups: [(originalGroupName: String, modifiedGroupName: String)] = []

    func setUpData() {
        if let generalPref = UserInfo.loggedInUser?.generalPref {
            groups = generalPref.labels
            self.setUpModifiedGroups()
            isCategorizeByGroup = generalPref.categorizeByGroup
            sortOrder = generalPref.sortOrder
            displayOrder = generalPref.displayOrder
        }
    }
    
    func setUpModifiedGroups() {
        for group in groups {
            self.modifiedGroups.append((originalGroupName: group, modifiedGroupName: group))
        }
    }
    
    func getFinalModifiedGroups() {
        self.modifiedGroups = self.modifiedGroups.filter({ $0.modifiedGroupName != $0.originalGroupName })
    }
    
    
    
    func callSavePreferencesAPI() {
        var params = JSONDictionary()
        
        params["sort_order"] = self.sortOrder
        params["display_order"] = self.displayOrder
        params["categorize_by_group"] = self.isCategorizeByGroup
        for (org, new) in self.modifiedGroups {
            if let idx = self.groups.firstIndex(of: org) {
                self.groups[idx] = new
            }
        }
        params["labels"] = self.groups
        params["removed"] = self.removedGroups
        
        UserInfo.loggedInUser?.generalPref?.updateLabelsPriority(newList: self.groups)
        if AppGlobals.shared.isNetworkRechable() {
            getFinalModifiedGroups()
        }
       
        
        for modified in self.modifiedGroups  {
            params["modified[\(modified.originalGroupName)]"] = modified.modifiedGroupName
        }
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
