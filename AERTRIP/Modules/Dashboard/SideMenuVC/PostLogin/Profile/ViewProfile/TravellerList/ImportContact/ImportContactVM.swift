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
    
    func add(for usingFor: ContactListVC.UsingFor)
    func remove(fromIndex: Int, for usingFor: ContactListVC.UsingFor)
    
    func addAll(for usingFor: ContactListVC.UsingFor)
    func removeAll(for usingFor: ContactListVC.UsingFor)
}

class ImportContactVM: NSObject {
    
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
    static let shared = ImportContactVM()
    
    private var _phoneContacts: [CNContact] = [] {
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
    
    var phoneContacts: [CNContact] = [] {
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
    
    var searchingFor = "" //used to show the not result
    var isPhoneContactsAllowed: Bool = false
    var isFacebookContactsAllowed: Bool = false
    var isGoogleContactsAllowed: Bool = false
    
    var selectedPhoneContacts: [CNContact] = []
    
    var selectedFacebookContacts: [ATContact] = []
    
    var selectedGoogleContacts: [ATContact] = []
    
    var selectedTrContacts: [ATContact] = []
    
    var totalSelectedContacts: Int {
        return (self.selectedPhoneContacts.count + self.selectedFacebookContacts.count + self.selectedGoogleContacts.count)
    }
    
    weak var delegateList: ImportContactVMDelegate?
    weak var delegateCollection: ImportContactVMDelegate?
    
    // section array  for Making header wise list
    var sections = [Section]()
    var facebookSection = [Section]()
    var googleSection = [Section]()
    
//    private(set) var contactListWithHeaderForPhone: [String: Any] = [String: Any]()
//    private(set) var contactListWithHeaderForFacebook: [String: Any] = [String: Any]()
//    private(set) var contactListWithHeaderForGoogle: [String: Any] = [String: Any]()
    

    
    //MARK:- Methods
    //MARK:- Public
    private override init() {
        super.init()
    }
    
    func add(for usingFor: ContactListVC.UsingFor) {
        self.delegateList?.add(for: usingFor)
        self.delegateCollection?.add(for: usingFor)
        if let obj = self.delegateCollection as? BaseVC {
            obj.sendDataChangedNotification(data: Notification.selectionChanged)
        }
    }

    func remove(fromIndex: Int, for usingFor: ContactListVC.UsingFor) {
        self.delegateList?.remove(fromIndex: fromIndex, for: usingFor)
        self.delegateCollection?.remove(fromIndex: fromIndex, for: usingFor)
        if let obj = self.delegateCollection as? BaseVC {
            obj.sendDataChangedNotification(data: Notification.selectionChanged)
        }
    }
    
    func addAll(for usingFor: ContactListVC.UsingFor) {
        self.delegateList?.addAll(for: usingFor)
        self.delegateCollection?.addAll(for: usingFor)
        if let obj = self.delegateCollection as? BaseVC {
            obj.sendDataChangedNotification(data: Notification.selectionChanged)
        }
    }
    
    func removeAll(for usingFor: ContactListVC.UsingFor) {
        self.delegateList?.removeAll(for: usingFor)
        self.delegateCollection?.removeAll(for: usingFor)
        if let obj = self.delegateCollection as? BaseVC {
            obj.sendDataChangedNotification(data: Notification.selectionChanged)
        }
    }
    
    //MARK:- Fetch Phone Contacts
    //MARK:-
    func fetchPhoneContacts(forVC: UIViewController, cancled: (()->Void)? = nil) {
        self.delegateList?.willFetchPhoneContacts()
        self.delegateCollection?.willFetchPhoneContacts()
        
        forVC.fetchContacts(complition: { [weak self] (contacts) in
            DispatchQueue.mainAsync {
                self?.isPhoneContactsAllowed = true
                self?._phoneContacts = contacts
                self?.createSectionWiseDataForContacts(for: .contacts)
                if let obj = self?.delegateCollection as? BaseVC {
                    obj.sendDataChangedNotification(data: Notification.contactFetched)
                }
            }
        }) {
            cancled?()
        }
    }
    
    //MARK:- Fetch Facebook Contacts
    //MARK:-
    func fetchFacebookContacts(forVC: UIViewController) {
        self.delegateList?.willFetchPhoneContacts()
        self.delegateCollection?.willFetchPhoneContacts()
        FacebookController.shared.facebookLogout()
        FacebookController.shared.fetchFacebookFriendsUsingThisAPP(withViewController: forVC, shouldFetchFriends: true, success: { [weak self] (friends) in
            if let fbContacts = friends["data"] as? [JSONDictionary] {
                self?.isFacebookContactsAllowed = true
                self?._facebookContacts = ATContact.fetchModels(facebookContactsArr: fbContacts)
                self?.createSectionWiseDataForContacts(for: .facebook)
                if let obj = self?.delegateCollection as? BaseVC {
                    obj.sendDataChangedNotification(data: Notification.contactFetched)
                }
            }
        }, failure: { (error) in
            printDebug(error)
        })
    }
    
    //MARK:- Fetch Google Contacts
    //MARK:-
    func fetchGoogleContacts(forVC: UIViewController) {
        self.delegateList?.willFetchPhoneContacts()
        self.delegateCollection?.willFetchPhoneContacts()
        GoogleLoginController.shared.logout()
        GoogleLoginController.shared.fetchContacts(fromViewController: forVC, success: { [weak self] (contacts) in
            self?.isGoogleContactsAllowed = true
            self?._googleContacts = ATContact.fetchModels(googleContactsDict: contacts)
            self?.createSectionWiseDataForContacts(for: .google)
            if let obj = self?.delegateCollection as? BaseVC {
                obj.sendDataChangedNotification(data: Notification.contactFetched)
            }
        }, failure: { (error) in
            printDebug(error)
        })
    }
    
    func createSectionWiseDataForContacts(for usingFor: ContactListVC.UsingFor) {
        switch usingFor {
        case .contacts:
            
//            sections = Section.fetch(forContacts: self.phoneContacts)
            
            let groupedDictionary = Dictionary(grouping: self.phoneContacts,by: { String($0.firstName.prefix(1)).capitalizedFirst() })
            let keys = groupedDictionary.keys.sorted()
            sections = keys.map{ Section(letter: $0, contacts: [], cnContacts: groupedDictionary[$0]!.sorted(by: { (ct1, ct2) -> Bool in
                return ct1.firstName.lowercased() < ct2.firstName.lowercased()
            })) }
        case .facebook:
            
//            facebookSection = Section.fetch(forContacts: self.facebookContacts)
            
            let groupedDictionary = Dictionary(grouping: self.facebookContacts,by: { String($0.firstName.prefix(1)) })
            let keys = groupedDictionary.keys.sorted()
            facebookSection = keys.map{ Section(letter: $0, contacts: groupedDictionary[$0]!.sorted(by: { (ct1, ct2) -> Bool in
                return ct1.firstName.lowercased() < ct2.firstName.lowercased()
            })) }
        case .google:
            
//            googleSection = Section.fetch(forContacts: self.googleContacts)
            
            let groupedDictionary = Dictionary(grouping: self.googleContacts,by: { String($0.firstName.prefix(1)).capitalizedFirst() })
            let keys = groupedDictionary.keys.sorted()
            googleSection = keys.map{ Section(letter: $0, contacts: groupedDictionary[$0]!.sorted(by: { (ct1, ct2) -> Bool in
                return ct1.firstName.lowercased() < ct2.firstName.lowercased()
            })) }
        }
        
        }
    
    //MARK:- Search
    //MARK:-
    func search(forText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        if !_phoneContacts.isEmpty || !_googleContacts.isEmpty || !_facebookContacts.isEmpty {
            self.searchingFor = forText
            perform(#selector(callSearch(_:)), with: forText, afterDelay: 0.5)
        }
        
   }
    
    @objc private func callSearch(_ forText: String) {
        if let obj = self.delegateCollection as? BaseVC {
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
                if !contact.email.isEmpty {
                    params["contacts[google][\(idx)][email][\(idx)][contact_label]"] = "home"
                      params["contacts[google][\(idx)][email][\(idx)][contact_type]"]  = "email"
                      params["contacts[google][\(idx)][email][\(idx)][contact_value]"] = contact.email
                }
                
//                if !contact.contact.isEmpty {
//                    params["contacts[google][\(idx)][mobile][\(idx)][contact_label]"] = "home"
//                    params["contacts[google][\(idx)][mobile][\(idx)][contact_type]"]  = "mobile"
//                    params["contacts[google][\(idx)][mobile][\(idx)][contact_value]"] = contact.contact // phone number without isd
//                        params["contacts[google][\(idx)][mobile][\(idx)][isd]"] = contact.contact // isd
//
//
//                }
                
                
            }
            
        
            
            APICaller.shared.callSaveSocialContactsAPI(params: params, loader: true) { [weak self] (success, errorCodes) in
                guard let sSelf = self else {return}
                if let obj = sSelf.delegateCollection as? BaseVC {
                    obj.sendDataChangedNotification(data: success ? Notification.contactSavedSuccess : Notification.contactSavedFail)
                }
            }
        }
        
        func savePhoneContacts() {
            var params = JSONDictionary()

            for (idx, contact) in self.selectedPhoneContacts.enumerated() {
//                let contact = ATContact(contact: cnContact)
                params["data[\(idx)][last_name]"] = contact.lastName
                params["data[\(idx)][first_name]"] = contact.firstName
                params["data[\(idx)][dob]"] = contact.dob
                
                params["data[\(idx)][email][0][contact_label]"] = contact.emailLabel
                params["data[\(idx)][email][0][contact_type]"] = "email"
                params["data[\(idx)][email][0][contact_value]"] = contact.email
                
                params["data[\(idx)][mobile][0][contact_label]"] = "cell"
                params["data[\(idx)][mobile][0][contact_type]"] = contact.label.rawValue
                let fullContact = contact.fullContact
                params["data[\(idx)][mobile][0][contact_value]"] = fullContact.contact
                params["data[\(idx)][mobile][0][isd]"] = fullContact.isd
                
            }
            
            
            APICaller.shared.callSavePhoneContactsAPI(params: params, loader: true) { [weak self] (success, errorCodes) in
                printDebug("phone contact saved")
                guard let sSelf = self else {return}
                if sSelf.selectedFacebookContacts.isEmpty, sSelf.selectedGoogleContacts.isEmpty {
                    if let obj = sSelf.delegateCollection as? BaseVC {
                        obj.sendDataChangedNotification(data: success ? Notification.contactSavedSuccess : Notification.phoneContactSavedFail)
                    }
                    return
                }
                saveSocialContacts()
            }
        }
        
        guard self.totalSelectedContacts <= 100 else {
            AppToast.default.showToastMessage(message: LocalizedString.SelectMaxNContacts.localized)
            return
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


struct Section {
    var letter : String
    var contacts : [ATContact]
    var cnContacts : [CNContact] = []
    
    init(letter : String, contacts : [ATContact], cnContacts : [CNContact]? = nil) {
        self.letter = letter
        self.contacts = contacts
        self.cnContacts = cnContacts ?? []
    }
    
    static func fetch(forContacts: [CNContact]) -> [Section] {
        var tempSec = forContacts.reduce(into: [Section]()) { (result, cont) in
            if !cont.firstName.isEmpty {
                if let index = result.firstIndex(where: { $0.letter == "\(cont.firstName.firstCharacter)"}) {
                    var temp = result.remove(at: index)
                    temp.cnContacts.append(cont)
                    temp.cnContacts.sort(by: { $0.firstName < $1.firstName })
                    result.insert(temp, at: index)
                }
                else {
                    result.append(Section(letter: "\(cont.firstName.firstCharacter)", contacts: [], cnContacts: [cont]))
                }
            }
        }
        tempSec.sort { $0.letter < $1.letter}
        return tempSec
    }
    
    static func fetch(forContacts: [ATContact]) -> [Section] {
        
        var tempSec = forContacts.reduce(into: [Section]()) { (result, cont) in
            
            if !cont.firstName.isEmpty {
                if let index = result.firstIndex(where: { $0.letter == "\(cont.firstName.firstCharacter)"}) {
                    var temp = result.remove(at: index)
                    temp.contacts.append(cont)
                    temp.contacts.sort(by: { $0.firstName < $1.firstName })
                    result.insert(temp, at: index)
                }
                else {
                    result.append(Section(letter: "\(cont.firstName.firstCharacter)", contacts: [cont]))
                }
            }
        }
        tempSec.sort { $0.letter < $1.letter}
        return tempSec
    }
}
