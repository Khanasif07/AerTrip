//
//  MailComposerVM.swift
//  AERTRIP
//
//  Created by apple on 01/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

protocol MailComoserVMDelegate: class {
    func willSendEmail()
    func didSendEmailSuccess()
    func didSendemailFail(_ errors: ErrorCodes)
    
    func willGetPinnedTemplate()
    func getPinnedTemplateSuccess()
    func getPinnedTemplateFail()
}

class MailComposerVM: NSObject {
    // MARK: - Variables
    
    var favouriteHotels: [HotelSearched] = []
    var hotelSearchRequest: HotelSearchRequestModel?
    weak var delegate: MailComoserVMDelegate?
    var subject: String = LocalizedString.CheckoutMyFavouriteHotels.localized
   // var u: String = ""
    var fromEmails: [String] = []
    var pinnedEmails: [String] = []
    var shortUrl: String = ""
    
    func callSendEmailMail() {
        var param = JSONDictionary()
        for (idx, hotel) in self.favouriteHotels.enumerated() {
            param["hid[\(idx)]"] = hotel.hid
        }
        param["sid"] = self.hotelSearchRequest?.sid
        for (idx, email) in self.pinnedEmails.enumerated() {
            param["pinned_to[\(idx)]"] = email
        }
        
        for (idx, email) in self.fromEmails.enumerated() {
            param["from[\(idx)]"] = email
        }
        param["subject"] = self.subject
        param["u"] = self.shortUrl
        
        self.delegate?.willSendEmail()
        APICaller.shared.callSendEmailAPI(params: param) { isSuccess,errors, _ in
            if isSuccess {
                self.delegate?.didSendEmailSuccess()
            } else {
                self.delegate?.didSendemailFail(errors)
            }
        }
    }
    
    func getPinnedTemplate() {
        var param = JSONDictionary()
        for (idx, hotel) in favouriteHotels.enumerated() {
            param["hid[\(idx)]"] = hotel.hid
        }
        param[APIKeys.sid.rawValue] = self.hotelSearchRequest?.sid
        
        self.delegate?.willGetPinnedTemplate()
        APICaller.shared.getPinnedTemplateAPI(params: param) { isSuccess, _, shortTemplateUrl in
            if isSuccess {
                self.shortUrl = shortTemplateUrl
                self.delegate?.getPinnedTemplateSuccess()
            } else {
                self.delegate?.getPinnedTemplateFail()
            }
        }
    }
}
