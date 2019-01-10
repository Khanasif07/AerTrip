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
    
    weak var delegate: ImportContactVMDelegate?
    
    //MARK:- Methods
    //MARK:- Public
    private override init() {
        super.init()
    }
    
    func fetchPhoneContacts(forVC: UIViewController) {
        self.delegate?.willFetchPhoneContacts()
        forVC.fetchContacts { [weak self] (contacts) in
            DispatchQueue.mainAsync {
                if let obj = self?.delegate as? BaseVC {
                    obj.sendDataChangedNotification(data: Notification.phoneContactFetched)
                }
                self?._phoneContacts = ATContact.fetchModels(contactsArr: contacts)
            }
        }
    }
    
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
}
