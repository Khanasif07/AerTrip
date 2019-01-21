//
//  AssignGroupVM.swift
//  AERTRIP
//
//  Created by apple on 14/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import CoreData
import Foundation
import UIKit

protocol AssignGroupVMDelegate: class {
    func willSavePreferences()
    func savePreferencesSuccess()
    func savePreferencesFail(errors: ErrorCodes)
    func willAsignGroup()
    func assignGroupSuccess()
    func assignGroupFail(errors: ErrorCodes)
}

class AssignGroupVM: NSObject {
    weak var delegate: AssignGroupVMDelegate?
    
    var groups: [String] = []
    var isCategorizeByGroup: Bool = false
    var sortOrder: String = ""
    var displayOrder: String = ""
    var paxIds: [String] = []
    var label: String = ""
    
    func setUpData() {
        if let generalPref = UserInfo.loggedInUser?.generalPref {
            self.groups = generalPref.labels
            self.isCategorizeByGroup = generalPref.categorizeByGroup
            self.sortOrder = generalPref.sortOrder
            self.displayOrder = generalPref.displayOrder
        }
    }
    
    func callSavePreferencesAPI() {
        var params = JSONDictionary()
        
        params["sort_order"] = self.sortOrder
        params["display_order"] = self.displayOrder
        params["categorize_by_group"] = self.isCategorizeByGroup
        params["labels"] = self.groups
        delegate?.willSavePreferences()
        APICaller.shared.callSavePreferencesAPI(params: params) { [weak self] success, erroCodes in
            if success {
                self?.delegate?.savePreferencesSuccess()
            } else {
                self?.delegate?.savePreferencesFail(errors: erroCodes)
            }
        }
    }
    
    func callAssignGroupAPI() {
        var params = JSONDictionary()
        params["pax_id"] = self.paxIds
        params["label"] = self.label
        
        delegate?.willAsignGroup()
        
        APICaller.shared.callAssignGroupAPI(params: params) { [weak self] success, erroCodes in
            if success {
                self?.delegate?.assignGroupSuccess()
            } else {
                self?.delegate?.assignGroupFail(errors: erroCodes)
            }
        }
    }
}
