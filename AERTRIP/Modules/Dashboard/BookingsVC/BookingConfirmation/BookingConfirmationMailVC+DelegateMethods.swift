//
//  BookingConfirmationMailVC+DelegateMethods.swift
//  AERTRIP
//
//  Created by apple on 26/06/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

extension BookingConfimationMailVC: BookingConfirmationMailVMDelegate {
    func willSendEmail() {
        AppGlobals.shared.startLoading()
    }
    
    func sendEmailSuccess() {
        AppGlobals.shared.stopLoading()
    }
    
    func sendEmailFail() {
        AppGlobals.shared.stopLoading()
    }
    
    func willGetTravellerEmail() {
        AppGlobals.shared.startLoading()
    }
    
    func getTravellerEmailSuccess() {
        AppGlobals.shared.stopLoading()
    }
    
    func getTravellerEmailFail() {
        AppGlobals.shared.stopLoading()
    }
}
