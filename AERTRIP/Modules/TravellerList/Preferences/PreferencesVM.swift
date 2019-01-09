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
    func savePreferencesFail()
}

class PreferencesVM: NSObject {
    weak var delegate: PreferencesVMDelegate?
    
    
    
    
    func callSavePreferencesAPI() {
        let param = JSONDictionary()
        
        APICaller.shared.callSavePreferencesAPI(params: param) { (success, erroCodes) in
            if success {
                
            } else {
                
            }
        }
    }
}
