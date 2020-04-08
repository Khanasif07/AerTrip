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
        self.dismiss(animated: true, completion: nil)
    }
    
    func sendEmailFail(_ error: ErrorCodes) {
        AppGlobals.shared.showErrorOnToastView(withErrors: error, fromModule: .hotelsSearch)
        AppGlobals.shared.stopLoading()
    }
    
    func willGetTravellerEmail() {
        AppGlobals.shared.startLoading()
    }
    
    func getTravellerEmailSuccess() {
        AppGlobals.shared.stopLoading()
    }
    
    func getTravellerEmailFail(_ error: ErrorCodes) {
        AppGlobals.shared.showErrorOnToastView(withErrors: error, fromModule: .hotelsSearch)
        AppGlobals.shared.stopLoading()
    }
}
