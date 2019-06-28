//
//  BookingAddOnRequestFF+DelegateMethods.swift
//  AERTRIP
//
//  Created by apple on 26/06/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

extension BookingRequestAddOnsFFVC: BookingAddOnRequestVMDelegate {
    func willGetPreferenceMaster() {
        AppGlobals.shared.startLoading()
    }
    
    func getPreferenceMasterSuccess() {
          AppGlobals.shared.stopLoading()
    }
    
    func getPreferenceMasterFail() {
         AppGlobals.shared.startLoading()
    }
    
    
}
