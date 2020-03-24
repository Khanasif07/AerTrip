//
//  ConfirmationEmailVM.swift
//  AERTRIP
//
//  Created by Admin on 24/03/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation
protocol ConfirmationEmailVMDelegate: class {
    func willSendEmail()
    func didSendEmailSuccess()
    func didSendemailFail(_ errors: ErrorCodes)
}

class ConfirmationEmailVM: NSObject {
    // MARK: - Variables
    
    weak var delegate: ConfirmationEmailVMDelegate?
    var subject: String = LocalizedString.CheckoutMyFavouriteHotels.localized
    var u: String = ""
    var fromEmails: [String] = []
    var pinnedEmails: [String] = []
    
    func callSendEmailMail() {
        var param = JSONDictionary()
        
        
        for (idx, email) in self.fromEmails.enumerated() {
            param["from[\(idx)]"] = email
        }
        param["subject"] = self.subject
        param["u"] = self.u
        
        self.delegate?.willSendEmail()
        APICaller.shared.callSendEmailAPI(params: param) { isSuccess,errors, _ in
            if isSuccess {
                self.delegate?.didSendEmailSuccess()
            } else {
                self.delegate?.didSendemailFail(errors)
            }
        }
    }
}
