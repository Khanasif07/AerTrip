//
//  HCEmailItinerariesVM.swift
//  AERTRIP
//
//  Created by Admin on 14/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

protocol HCEmailItinerariesVMDelegate: class {
    func willBegainEmailSending(isMultipleEmailSending : Bool, currentEmailIndex: Int)
    func emailSendingSuccess(isMultipleEmailSending : Bool, currentEmailIndex: Int)
    func emailSendingFail(isMultipleEmailSending : Bool, currentEmailIndex: Int)
}

class HCEmailItinerariesVM {
    
    //Mark:- Variables
    //================
    var guestModal: [ATContact] = []
    var emailInfo: [HCEmailItinerariesModel] = []
    weak var delegate: HCEmailItinerariesVMDelegate?
    var bookingId: String = ""
    var travellers: [TravellersList] = []
    
    //Mark:- Functions
    //================
    func startSendingEmailId(isMultipleEmailSending : Bool, currentEmailIndex: Int = -1) {
        self.delegate?.willBegainEmailSending(isMultipleEmailSending : isMultipleEmailSending, currentEmailIndex: currentEmailIndex)
    }
    
    func sendEmailIdApi(emailId: [String], isMultipleEmailSending : Bool, currentEmailIndex: Int) {
        let params: JSONDictionary = [APIKeys.email.rawValue : emailId]
        APICaller.shared.sendDashBoardEmailIDAPI(bookingID: self.bookingId, params: params, loader: false) { [weak self] (success, errors, recentSearchesHotels) in
            guard let sSelf = self else { return }
            if success {
                sSelf.delegate?.emailSendingSuccess(isMultipleEmailSending : isMultipleEmailSending, currentEmailIndex: currentEmailIndex)
            } else {
                printDebug(errors)
                AppGlobals.shared.showErrorOnToastView(withErrors: errors, fromModule: .hotelsSearch)
                sSelf.delegate?.emailSendingFail(isMultipleEmailSending : isMultipleEmailSending, currentEmailIndex: currentEmailIndex)
            }
        }
    }
    
    func getNonSentEmails() -> [String] {
        var emailIds: [String] = []
        for emailData in self.emailInfo {
            if emailData.emailStatus == .toBeSend && emailData.emailId.isEmail {
                emailIds.append(emailData.emailId)
            }
        }
        return emailIds
    }
    
    func emailIdSetUp() {
        for _ in self.travellers {
            var emailInfo = HCEmailItinerariesModel()
            emailInfo.emailId = ""
            emailInfo.emailStatus = .toBeSend
            self.emailInfo.append(emailInfo)
        }
    }
    
    func fillData() {
        var person1 = ATContact()
        person1.id = "1"
        person1.firstName = "one "
        person1.lastName = "ewe"
        person1.profilePicture = ""
        var person2 = ATContact()
        person2.id = "2"
        person2.firstName = "two "
        person2.lastName = "wwqwqewe"
        person2.profilePicture = ""
        var person3 = ATContact()
        person3.id = "3"
        person3.firstName = "three "
        person3.lastName = "ewe"
        person3.profilePicture = ""
        var person4 = ATContact()
        person4.id = "4"
        person4.firstName = "four "
        person4.lastName = "wwqwqewe"
        person4.profilePicture = ""
        var person5 = ATContact()
        person5.id = "5"
        person5.firstName = "five "
        person5.lastName = "ewe"
        person5.profilePicture = ""
        var person6 = ATContact()
        person6.id = "6"
        person6.firstName = "six "
        person6.lastName = "wwqwqewe"
        person6.profilePicture = ""
        var person7 = ATContact()
        person7.id = "7"
        person7.firstName = "seven "
        person7.lastName = "ewe"
        person7.profilePicture = ""
        var person8 = ATContact()
        person8.id = "8"
        person8.firstName = "eight "
        person8.lastName = "wwqwqewe"
        person8.profilePicture = ""
        var person9 = ATContact()
        person9.id = "9"
        person9.firstName = "nine "
        person9.lastName = "ewe"
        person9.profilePicture = ""
        var person10 = ATContact()
        person10.id = "10"
        person10.firstName = "ten "
        person10.lastName = "wwqwqewe"
        person10.profilePicture = ""

        self.guestModal.append(person1)
        self.guestModal.append(person2)
        self.guestModal.append(person3)
        self.guestModal.append(person4)
        self.guestModal.append(person5)
        self.guestModal.append(person6)
        self.guestModal.append(person7)
        self.guestModal.append(person8)
        self.guestModal.append(person9)
        self.guestModal.append(person10)
        
        var emailInfo1 = HCEmailItinerariesModel()
        emailInfo1.emailId = ""
        emailInfo1.emailStatus = .toBeSend
        var emailInfo2 = HCEmailItinerariesModel()
        emailInfo2.emailId = ""
        emailInfo2.emailStatus = .toBeSend
        var emailInfo3 = HCEmailItinerariesModel()
        emailInfo3.emailId = ""
        emailInfo3.emailStatus = .toBeSend
        var emailInfo4 = HCEmailItinerariesModel()
        emailInfo4.emailId = ""
        emailInfo4.emailStatus = .toBeSend
        var emailInfo5 = HCEmailItinerariesModel()
        emailInfo5.emailId = ""
        emailInfo5.emailStatus = .toBeSend
        var emailInfo6 = HCEmailItinerariesModel()
        emailInfo6.emailId = ""
        emailInfo6.emailStatus = .toBeSend
        var emailInfo7 = HCEmailItinerariesModel()
        emailInfo7.emailId = ""
        emailInfo7.emailStatus = .toBeSend
        var emailInfo8 = HCEmailItinerariesModel()
        emailInfo8.emailId = ""
        emailInfo8.emailStatus = .toBeSend
        var emailInfo9 = HCEmailItinerariesModel()
        emailInfo9.emailId = ""
        emailInfo9.emailStatus = .toBeSend
        var emailInfo10 = HCEmailItinerariesModel()
        emailInfo10.emailId = ""
        emailInfo10.emailStatus = .toBeSend

        self.emailInfo.append(emailInfo1)
        self.emailInfo.append(emailInfo2)
        self.emailInfo.append(emailInfo3)
        self.emailInfo.append(emailInfo4)
        self.emailInfo.append(emailInfo5)
        self.emailInfo.append(emailInfo6)
        self.emailInfo.append(emailInfo7)
        self.emailInfo.append(emailInfo8)
        self.emailInfo.append(emailInfo9)
        self.emailInfo.append(emailInfo10)
        
    }
}
