//
//  HCSelectGuestsVM.swift
//  AERTRIP
//
//  Created by Admin on 29/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit
import Contacts

protocol HCSelectGuestsVMDelegate: class {
    func willFetchPhoneContacts()
    func fetchPhoneContactsSuccess()
    
    func add(atIndex index: Int, for usingFor: HCGuestListVC.UsingFor)
    func remove(atIndex index: Int, for usingFor: HCGuestListVC.UsingFor)
}

class HCSelectGuestsVM: NSObject {
    
    enum Notification {
        case selectionChanged
        case contactFetched
        case searchDone
        case contactSavedSuccess
        case contactSavedFail
        case phoneContactSavedFail
    }
    
    //MARK:- Properties
    //MARK:- Public
    static let shared = HCSelectGuestsVM()
    
    var _phoneContacts: [ATContact] = [] {
        didSet {
            self.phoneContacts = self._phoneContacts
        }
    }
    var _facebookContacts: [ATContact] = []{
        didSet {
            self.facebookContacts = self._facebookContacts
        }
    }
    var _googleContacts: [ATContact] = []{
        didSet {
            self.googleContacts = self._googleContacts
        }
    }
    var _travellerContacts: [ATContact] = []{
        didSet {
            self.travellerContacts = self._travellerContacts
        }
    }
    
    var phoneContacts: [ATContact] = [] {
        didSet {
            phoneContacts.sort { (ct1, ct2) -> Bool in
                ct1.fullName < ct2.fullName
            }
        }
    }
    var facebookContacts: [ATContact] = []{
        didSet {
            facebookContacts.sort { (ct1, ct2) -> Bool in
                ct1.fullName < ct2.fullName
            }
        }
    }
    var googleContacts: [ATContact] = []{
        didSet {
            googleContacts.sort { (ct1, ct2) -> Bool in
                ct1.fullName < ct2.fullName
            }
        }
    }
    var travellerContacts: [ATContact] = []{
        didSet {
            travellerContacts.sort { (ct1, ct2) -> Bool in
                ct1.fullName < ct2.fullName
            }
        }
    }
    
    var isPhoneContactsAllowed: Bool = false
    var isFacebookContactsAllowed: Bool = false
    var isGoogleContactsAllowed: Bool = false
    
    var selectedPhoneContacts: [ATContact] = []

    var selectedFacebookContacts: [ATContact] = []

    var selectedGoogleContacts: [ATContact] = []

    var selectedTravellerContacts: [ATContact] = []
    
    weak var delegateList: HCSelectGuestsVMDelegate?
    weak var delegateCollection: HCSelectGuestsVMDelegate?
    
    var allSelectedCount: Int {
        return selectedPhoneContacts.count + selectedFacebookContacts.count + selectedGoogleContacts.count + selectedTravellerContacts.count
    }
    
    //MARK:- Methods
    //MARK:- Public
    private override init() {
        super.init()
    }
    
    func clearAllSelection() {
        self.selectedTravellerContacts.removeAll()
        self.selectedPhoneContacts.removeAll()
        self.selectedFacebookContacts.removeAll()
        self.selectedGoogleContacts.removeAll()
    }
    
    func add(atIndex index: Int, for usingFor: HCGuestListVC.UsingFor) {
        self.delegateList?.add(atIndex: index, for: usingFor)
        self.delegateCollection?.add(atIndex: index, for: usingFor)
        if let obj = self.delegateCollection as? BaseVC {
            obj.sendDataChangedNotification(data: Notification.selectionChanged)
        }
    }
    
    func remove(atIndex index: Int, for usingFor: HCGuestListVC.UsingFor) {
        self.delegateList?.remove(atIndex: index, for: usingFor)
        self.delegateCollection?.remove(atIndex: index, for: usingFor)
        if let obj = self.delegateCollection as? BaseVC {
            obj.sendDataChangedNotification(data: Notification.selectionChanged)
        }
    }
    
    func originalIndex(forContact contact: ATContact, forType type: HCGuestListVC.UsingFor) ->Int? {
        var index: Int?
        switch type {
        case .travellers:
            if let idx = self._travellerContacts.firstIndex(where: { (cnct) -> Bool in
                cnct.id == contact.id
            }) {
                index = idx
            }
            
        case .contacts:
            if let idx = self._phoneContacts.firstIndex(where: { (cnct) -> Bool in
                cnct.id == contact.id
            }) {
                index = idx
            }
            
        case .facebook:
            if let idx = self._facebookContacts.firstIndex(where: { (cnct) -> Bool in
                cnct.id == contact.id
            }) {
                index = idx
            }
            
        case .google:
            if let idx = self._googleContacts.firstIndex(where: { (cnct) -> Bool in
                cnct.id == contact.id
            }) {
                index = idx
            }
        }
        
        return index
    }

    //MARK:- Fetch Phone Contacts
    //MARK:-
    func fetchTravellersContact() {
        self._travellerContacts = GuestDetailsVM.shared.travellerList.map { (travlr) -> ATContact in
            var conct = travlr.contact
            conct.label = ATContact.Label.traveller
            return conct
        }
    }
    
    //MARK:- Fetch Phone Contacts
    //MARK:-
    func fetchPhoneContacts(forVC: UIViewController,sender: ATButton? = nil) {
        self.delegateList?.willFetchPhoneContacts()
        self.delegateCollection?.willFetchPhoneContacts()
        forVC.fetchContacts(complition: { [weak self] (contacts) in
                DispatchQueue.mainAsync {
                    if let obj = self?.delegateCollection as? BaseVC {
                        obj.sendDataChangedNotification(data: Notification.contactFetched)
                    }
                    self?.isPhoneContactsAllowed = true
                    self?._phoneContacts = ATContact.fetchModels(phoneContactsArr: contacts)
                }
            
        }) {
            printDebug("process cancelled")
        }
    }
    
    //MARK:- Fetch Facebook Contacts
    //MARK:-
    func fetchFacebookContacts(forVC: UIViewController,sender: ATButton? = nil) {
        self.delegateList?.willFetchPhoneContacts()
        self.delegateCollection?.willFetchPhoneContacts()
        FacebookController.shared.facebookLogout()
        FacebookController.shared.fetchFacebookFriendsUsingThisAPP(withViewController: forVC, shouldFetchFriends: true, success: { [weak self] (friends) in
            if let fbContacts = friends["data"] as? [JSONDictionary] {
                if let obj = self?.delegateCollection as? BaseVC {
                    obj.sendDataChangedNotification(data: Notification.contactFetched)
                }
                self?.isFacebookContactsAllowed = true
                self?._facebookContacts = ATContact.fetchModels(facebookContactsArr: fbContacts)
            }
            }, failure: { (error) in
                if let sender = sender {
                    sender.isLoading = false
                }
                printDebug(error)
        })
    }
    
    //MARK:- Fetch Google Contacts
    //MARK:-
    func fetchGoogleContacts(forVC: UIViewController,sender: ATButton? = nil) {
        self.delegateList?.willFetchPhoneContacts()
        self.delegateCollection?.willFetchPhoneContacts()
        GoogleLoginController.shared.logout()
        GoogleLoginController.shared.fetchContacts(fromViewController: forVC, success: { [weak self] (contacts) in
            if let obj = self?.delegateCollection as? BaseVC {
                obj.sendDataChangedNotification(data: Notification.contactFetched)
            }
            self?.isGoogleContactsAllowed = true
            self?._googleContacts = ATContact.fetchModels(googleContactsDict: contacts)
            }, failure: { (error) in
                if let sender = sender {
                    sender.isLoading = false
                }
                printDebug(error)
        })
    }
    
    //MARK:- Search
    //MARK:-
    func search(forText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        perform(#selector(callSearch(_:)), with: forText, afterDelay: 0.5)        
    }
    
    @objc private func callSearch(_ forText: String) {
        if let obj = self.delegateCollection as? BaseVC {
            guard !forText.isEmpty else {
                self.travellerContacts = self._travellerContacts
                self.phoneContacts = self._phoneContacts
                self.facebookContacts = self._facebookContacts
                self.googleContacts = self._googleContacts
                obj.sendDataChangedNotification(data: Notification.searchDone)
                return
            }
            self.travellerContacts = self._travellerContacts.filter({ (contact) -> Bool in
                contact.fullName.contains(forText)
            })
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
}
