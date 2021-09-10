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
        //AppGlobals.shared.startLoading()
        topNavigationView.firstRightButton.isHidden = true
        topNavigationView.startActivityIndicaorLoading()
    }
    
    func sendEmailSuccess() {
        //AppGlobals.shared.stopLoading()
        topNavigationView.firstRightButton.isHidden = false
        topNavigationView.stopActivityIndicaorLoading()
        self.dismiss(animated: true, completion: nil)
        delay(seconds: 0.5) {
            AppToast.default.showToastMessage(message: LocalizedString.FavoriteHotelsInfoSentMessage.localized)
        }
    }
    
    func sendEmailFail(_ error: ErrorCodes) {
        AppGlobals.shared.showErrorOnToastView(withErrors: error, fromModule: .hotelsSearch)
        //AppGlobals.shared.stopLoading()
        topNavigationView.firstRightButton.isHidden = false
        topNavigationView.stopActivityIndicaorLoading()
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
