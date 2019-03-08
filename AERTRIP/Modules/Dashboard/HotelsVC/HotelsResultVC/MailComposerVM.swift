//
//  MailComposerVM.swift
//  AERTRIP
//
//  Created by apple on 01/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

protocol  MailComoserVMDelegate : class {
    func willSendEmail()
    func didSendEmailSuccess()
    func didSendemailFail()
}

class MailComposerVM: NSObject {
    
    // MARK:- Variables
    
    var favouriteHotels :[HotelSearched] = []
    weak var delegate : MailComoserVMDelegate?
    var sid: String = ""
    var subject: String = "Tesging"
    var u: String = ""
    var fromEmails:[String] = ["rahulTest@yopmail.com"]
    var pinnedEmails: [String] = ["pawan.kumar@appinventiv.co"]
    
    
    func callSendEmailMail() {
        var param = JSONDictionary()
        for (idx, hotel) in self.favouriteHotels.enumerated() {
            param["hid[\(idx)]"] = hotel.hid
        }
        param["sid"] = self.sid
        for (idx, email) in pinnedEmails.enumerated() {
            param["pinned_to[\(idx)]"] = email
        }
        
        for (idx, email) in fromEmails.enumerated() {
            param["from[\(idx)]"] = email
        }
        param["subject"] = self.subject
        param["u"] = self.u
        
        self.delegate?.willSendEmail()
        APICaller.shared.callSendEmailAPI(params: param) { isSuccess,errors, successMessage in
            if isSuccess {
                self.delegate?.didSendEmailSuccess()
            } else {
                self.delegate?.didSendemailFail()
            }
        }
    }
    
    
    
    
}
