//
//  BookingConfirmationMailVM.swift
//  AERTRIP
//
//  Created by apple on 26/06/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

protocol BookingConfirmationMailVMDelegate: class{
    func willGetTravellerEmail()
    func getTravellerEmailSuccess()
    func getTravellerEmailFail()
    func willSendEmail()
    func sendEmailSuccess()
    func sendEmailFail()
}

class BookingConfirmationMailVM {
    
    //MARK:- Properties
    weak var delegate: BookingConfirmationMailVMDelegate?
    var bookingId: String = ""
    var emails: [String] = []
    var token: String = ""
    var addedEmail: [String] = []
    
    
    
    
    
    func getTravellerMail() {
        self.delegate?.willGetTravellerEmail()
      
        
        APICaller.shared.getTravellerEmail { [weak self] (success,emails,token, errors) in
            guard let sSelf = self else { return }
            if success  {
                sSelf.emails = emails
                sSelf.token = token
                sSelf.delegate?.getTravellerEmailSuccess()
            } else {
                  sSelf.delegate?.getTravellerEmailFail()
            }
        }
        
    }
    
    
    func sendConfirmationMail() {
        var params: JSONDictionary = [:]
        for email in emails {
            params["\(APIKeys.email.rawValue)[]"] = email
        }
        params["_t"] = self.token
        self.delegate?.willSendEmail()
        APICaller.shared.sendConfirmationEmailApi(bookingID: bookingId, params: params) { [weak self] (success, errorCode, message) in
            guard let sSelf = self else { return }
            if success {
                sSelf.delegate?.getTravellerEmailSuccess()
            } else {
                sSelf.delegate?.getTravellerEmailFail()
            }
        }
    }
    
}