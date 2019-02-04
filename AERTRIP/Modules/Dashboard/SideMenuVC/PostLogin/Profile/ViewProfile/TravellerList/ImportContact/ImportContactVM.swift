//
//  ImportContactVM.swift
//  AERTRIP
//
//  Created by Admin on 09/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit
import Contacts

protocol ImportContactVMDelegate: class {
    func willFetchPhoneContacts()
    func fetchPhoneContactsSuccess()
    
    func selectionDidChanged()
}

class ImportContactVM: NSObject {
    
    enum Notification {
        case selectionChanged
        case phoneContactFetched
        case searchDone
        case contactSavedSuccess
        case contactSavedFail
        case phoneContactSavedFail
    }
    
    //MARK:- Properties
    //MARK:- Public
    static let shared = ImportContactVM()
    
    private var _phoneContacts: [ATContact] = [] {
        didSet {
            self.phoneContacts = self._phoneContacts
        }
    }
    private var _facebookContacts: [ATContact] = []{
        didSet {
            self.facebookContacts = self._facebookContacts
        }
    }
    private var _googleContacts: [ATContact] = []{
        didSet {
            self.googleContacts = self._googleContacts
        }
    }
    
    var phoneContacts: [ATContact] = []
    var facebookContacts: [ATContact] = []
    var googleContacts: [ATContact] = []
    
    var selectedPhoneContacts: [ATContact] = [] {
        didSet {
            if let obj = self.delegate as? BaseVC {
                obj.sendDataChangedNotification(data: Notification.selectionChanged)
            }
        }
    }
    
    var selectedFacebookContacts: [ATContact] = []{
        didSet {
            if let obj = self.delegate as? BaseVC {
                obj.sendDataChangedNotification(data: Notification.selectionChanged)
            }
        }
    }
    
    var selectedGoogleContacts: [ATContact] = []{
        didSet {
            if let obj = self.delegate as? BaseVC {
                obj.sendDataChangedNotification(data: Notification.selectionChanged)
            }
        }
    }
    
    var totalContacts: Int {
        return (self.selectedPhoneContacts.count + self.selectedFacebookContacts.count + self.selectedGoogleContacts.count)
    }
    
    weak var delegate: ImportContactVMDelegate?
    
    //MARK:- Methods
    //MARK:- Public
    private override init() {
        super.init()
    }
    
    //MARK:- Fetch Phone Contacts
    //MARK:-
    func fetchPhoneContacts(forVC: UIViewController) {
        self.delegate?.willFetchPhoneContacts()
        forVC.fetchContacts { [weak self] (contacts) in
            DispatchQueue.mainAsync {
                if let obj = self?.delegate as? BaseVC {
                    obj.sendDataChangedNotification(data: Notification.phoneContactFetched)
                }
                self?._phoneContacts = ATContact.fetchModels(phoneContactsArr: contacts)
            }
        }
    }
    
    //MARK:- Fetch Facebook Contacts
    //MARK:-
    func fetchFacebookContacts(forVC: UIViewController) {
        self.delegate?.willFetchPhoneContacts()
        FacebookController.shared.fetchFacebookFriendsUsingThisAPP(withViewController: forVC, shouldFetchFriends: true, success: { [weak self] (friends) in
            if let fbContacts = friends["data"] as? [JSONDictionary] {
                if let obj = self?.delegate as? BaseVC {
                    obj.sendDataChangedNotification(data: Notification.phoneContactFetched)
                }
                self?._facebookContacts = ATContact.fetchModels(facebookContactsArr: fbContacts)
            }
        }, failure: { (error) in
            printDebug(error)
        })
    }
    
    //MARK:- Fetch Google Contacts
    //MARK:-
    func fetchGoogleContacts(forVC: UIViewController) {
        self.delegate?.willFetchPhoneContacts()
        GoogleLoginController.shared.fetchContacts(fromViewController: forVC, success: { [weak self] (contacts) in
            if let obj = self?.delegate as? BaseVC {
                obj.sendDataChangedNotification(data: Notification.phoneContactFetched)
            }
            self?._googleContacts = ATContact.fetchModels(googleContactsDict: contacts)
        }, failure: { (error) in
            print(error)
        })
    }
    
    //MARK:- Search
    //MARK:-
    func search(forText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        perform(#selector(callSearch(_:)), with: forText, afterDelay: 0.5)
    }
    
    @objc private func callSearch(_ forText: String) {
        if let obj = self.delegate as? BaseVC {
            guard !forText.isEmpty else {
                self.phoneContacts = self._phoneContacts
                self.facebookContacts = self._facebookContacts
                self.googleContacts = self._googleContacts
                obj.sendDataChangedNotification(data: Notification.searchDone)
                return
            }
            self.phoneContacts = self._phoneContacts.filter({ (contact) -> Bool in
                contact.fullName.contains(forText)
            })
            self.facebookContacts = self._facebookContacts.filter({ (contact) -> Bool in
                contact.fullName.contains(forText)
            })
            self.googleContacts = self._googleContacts.filter({ (contact) -> Bool in
                contact.fullName.contains(forText)
            })
            obj.sendDataChangedNotification(data: Notification.searchDone)
        }
    }
    
    //MARK:- Save Contacts On Server
    //MARK:-
    func saveContacts() {
        var isPhoneContactsSaved = false, isSocialContactsSaved = false
        
        func saveSocialContacts() {
            var params = JSONDictionary()
            
            
            //facebook contacts
            for (idx, contact) in self.selectedFacebookContacts.enumerated() {
                params["contacts[facebook][\(idx)][id]"] = contact.socialId
                params["contacts[facebook][\(idx)][type]"] = contact.label.rawValue.uppercased()
                params["contacts[facebook][\(idx)][name]"] = contact.fullName
                params["contacts[facebook][\(idx)][picture]"] = contact.image
            }
            
            //google contacts
            for (idx, contact) in self.selectedGoogleContacts.enumerated() {
                params["contacts[google][\(idx)][id]"] = contact.socialId
                params["contacts[google][\(idx)][type]"] = contact.label.rawValue.uppercased()
                params["contacts[google][\(idx)][name]"] = contact.fullName
                params["contacts[google][\(idx)][picture]"] = contact.image
            }
            
            APICaller.shared.callSaveSocialContactsAPI(params: params, loader: true) { [weak self] (success, errorCodes) in
                guard let sSelf = self else {return}
                if let obj = sSelf.delegate as? BaseVC {
                    obj.sendDataChangedNotification(data: success ? Notification.contactSavedSuccess : Notification.contactSavedFail)
                }
            }
        }
        
        func savePhoneContacts() {
            var params = JSONDictionary()

            for (idx, contact) in self.selectedPhoneContacts.enumerated() {
                params["data[\(idx)][last_name]"] = contact.lastName
                params["data[\(idx)][first_name]"] = contact.firstName
                
                params["data[\(idx)][email][0][contact_label]"] = contact.emailLabel
                params["data[\(idx)][email][0][contact_type]"] = "email"
                params["data[\(idx)][email][0][contact_value]"] = contact.email
                
                params["data[\(idx)][mobile][0][contact_label]"] = "cell"
                params["data[\(idx)][mobile][0][contact_type]"] = contact.label.rawValue
                params["data[\(idx)][mobile][0][contact_value]"] = contact.contact
            }
            
            APICaller.shared.callSavePhoneContactsAPI(params: params, loader: true) { [weak self] (success, errorCodes) in
                printDebug("phone contact saved")
                guard let sSelf = self else {return}
                if sSelf.selectedFacebookContacts.isEmpty, sSelf.selectedGoogleContacts.isEmpty {
                    if let obj = sSelf.delegate as? BaseVC {
                        obj.sendDataChangedNotification(data: success ? Notification.contactSavedSuccess : Notification.phoneContactSavedFail)
                    }
                    return
                }
                saveSocialContacts()
            }
        }
        
        if !self.selectedPhoneContacts.isEmpty {
            savePhoneContacts()
        }
        else {
            if self.selectedFacebookContacts.isEmpty, self.selectedGoogleContacts.isEmpty {
                return
            }
            saveSocialContacts()
        }
    }
}
