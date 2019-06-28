//
//  BookingAddOnRequestVM.swift
//  AERTRIP
//
//  Created by apple on 26/06/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

protocol BookingAddOnRequestVMDelegate: class {
    func willGetPreferenceMaster()
    func getPreferenceMasterSuccess()
    func getPreferenceMasterFail()
}

import Foundation

class BookingAddOnRequestVM {
    // MARK: - Properties:-
    
    weak var delegate: BookingAddOnRequestVMDelegate?
    // preferences
    var seatPreferences = [String: String]()
    var mealPreferences = [String: String]()
    
    func getPreferenceMaster() {
        delegate?.willGetPreferenceMaster()
        
        APICaller.shared.getPreferenceMaster { [weak self] (success, seatPreferences, mealPreferences, errors) in
            guard let sSelf = self else { return }
            if success {
                sSelf.seatPreferences = seatPreferences
                sSelf.mealPreferences = mealPreferences
                sSelf.delegate?.getPreferenceMasterSuccess()
            } else {
                sSelf.delegate?.getPreferenceMasterFail()
            }
        }
        
        
    }
}
