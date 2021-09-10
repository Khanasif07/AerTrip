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
    func getTravellerEmailFail(_ errors: ErrorCodes)
    func willSendEmail()
    func sendEmailSuccess()
    func sendEmailFail(_ errors: ErrorCodes)
}

class BookingConfirmationMailVM {
    
    //MARK:- Properties
    weak var delegate: BookingConfirmationMailVMDelegate?
    var bookingId: String = ""
    var emails: [String] = []
    var token: String = ""
    var addedEmail: [String] = []
    var hitSendConfirmationApi = false
    
    
    
    
    func getTravellerMail() {
        self.delegate?.willGetTravellerEmail()
      
        
        APICaller.shared.getTravellerEmail { [weak self] (success,emails,token, errors) in
            guard let sSelf = self else { return }
            if success  {
                sSelf.emails = emails
                sSelf.token = token
                sSelf.delegate?.getTravellerEmailSuccess()
                if sSelf.hitSendConfirmationApi {
                    sSelf.hitSendConfirmationApi = false
                    sSelf.sendConfirmationMail()
                }
            } else {
                sSelf.delegate?.getTravellerEmailFail(errors)
                sSelf.hitSendConfirmationApi = false
            }
        }
        
    }
    
    
    func sendConfirmationMail() {
        var params: JSONDictionary = [:]
        for (index, email) in addedEmail.enumerated() {
            params["\(APIKeys.email.rawValue)[\(index)]"] = email
        }
        params["_t"] = self.token
        params["booking_id"] = self.bookingId

        self.delegate?.willSendEmail()
        APICaller.shared.sendConfirmationEmailApi(bookingID: bookingId, params: params) { [weak self] (success, errorCode, message) in
            guard let sSelf = self else { return }
            if success {
                sSelf.delegate?.sendEmailSuccess()
            } else {
                sSelf.delegate?.sendEmailFail(errorCode)
            }
        }
    }
    
}
