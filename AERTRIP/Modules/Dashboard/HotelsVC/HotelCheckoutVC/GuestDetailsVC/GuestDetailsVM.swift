//
//  GuestDetailsVM.swift
//  AERTRIP
//
//  Created by Admin on 14/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol GuestDetailsVMDelegate: class {
    func searchDidComplete()
}

class GuestDetailsVM: NSObject {
    typealias GuestDetailContactTouple = (firstName: String, lastName: String, fullName: String, dob: String, salutation: String, id: String)
    
    static let shared = GuestDetailsVM()
    weak var delegate: GuestDetailsVMDelegate?
    // Save Hotel Form Data
    var hotelFormData: HotelFormPreviosSearchData = HotelFormPreviosSearchData()
    var selectedIndexPath: IndexPath = IndexPath()
    var salutation = [String]()
    var canShowSalutationError = false
   // var countries:[String:String]?
    // GuestModalArray for travellers
    var guests: [[ATContact]] = [[]]
    var selectedGuest: ATContact?
    var isFirstNameTextField = true
    var sid:String = ""//To key user details for same search.
    var travellerList: [TravellerModel] = [] {
        didSet {
            fetchTravellersContact()
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
    
    var isDataEmpty: Bool {
        if phoneContacts.isEmpty && facebookContacts.isEmpty && googleContacts.isEmpty && travellerContacts.isEmpty {
            return true
        }
        
        return false
    }
    
    static func clearData(){
        GuestDetailsVM.shared.guests.removeAll()
        GuestDetailsVM.shared.delegate = nil
        GuestDetailsVM.shared.selectedIndexPath = IndexPath()
        GuestDetailsVM.shared.salutation.removeAll()
        GuestDetailsVM.shared.canShowSalutationError = false
        GuestDetailsVM.shared.guests.removeAll()
        GuestDetailsVM.shared.travellerList.removeAll()
        GuestDetailsVM.shared.travellerContacts.removeAll()
    }
    
    private override init() {}
    
    func checkForDoneValidation() -> Bool {
        for guest in GuestDetailsVM.shared.guests.flatMap({return $0}) {
            if !guest.firstName.isEmpty || !guest.lastName.isEmpty {
                if guest.firstName.count < 3 || guest.lastName.count < 3 {
                    AppToast.default.showToastMessage(message: LocalizedString.FirstLastNameCharacterLimitMessage.localized)
                    return false
                }
            }
        }
        return true
    }
    
    func fetchTravellersContact() {
        HCSelectGuestsVM.shared._travellerContacts = self.travellerList.map { (travlr) -> ATContact in
            var conct = travlr.contact
            conct.label = ATContact.Label.traveller
            return conct
        }
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        switch section {
        case 0: return self.travellerContacts.count //section 0 for travellers
        case 1: return self.phoneContacts.count //section 1 for phone contacts
        case 2: return self.facebookContacts.count //section 2 for facebook contact
        case 3: return self.googleContacts.count //section 3 for google contacts
        default: return 0
        }
    }
    
    func objectForIndexPath(indexPath: IndexPath) -> GuestDetailContactTouple? {
        var object: ATContact?
        
        switch indexPath.section {
        case 0: //section 0 for travellers
            object = self.travellerContacts[indexPath.row]
        case 1: //section 1 for phone contacts
            object =  self.phoneContacts[indexPath.row]
        case 2: //section 2 for facebook contact
            object =  self.facebookContacts[indexPath.row]
        case 3: //section 3 for google contacts
            object =  self.googleContacts[indexPath.row]
        default: break
        }
        if let obj = object {
            return (obj.firstName, obj.lastName, obj.fullName, obj.dob, obj.salutation, obj.apiId)
        }
        
        return nil
    }
    
    func contactForIndexPath(indexPath: IndexPath) -> ATContact? {
        var object: ATContact?
        
        switch indexPath.section {
        case 0: //section 0 for travellers
            object = self.travellerContacts[indexPath.row]
        case 1: //section 1 for phone contacts
            object =  self.phoneContacts[indexPath.row]
        case 2: //section 2 for facebook contact
            object =  self.facebookContacts[indexPath.row]
        case 3: //section 3 for google contacts
            object =  self.googleContacts[indexPath.row]
        default: break
        }
        if let obj = object {
            return obj
        }
        
        return nil
    }
    
    func titleForSection(section: Int) -> String {
        switch section {
        case 0: return HCGuestListVC.UsingFor.travellers.title //section 0 for travellers
        case 1: return HCGuestListVC.UsingFor.contacts.title //section 1 for phone contacts
        case 2: return HCGuestListVC.UsingFor.facebook.title //section 2 for facebook contact
        case 3: return HCGuestListVC.UsingFor.google.title //section 3 for google contacts
        default: return ""
        }
    }
    
    func isLastIndexOfTable(indexPath: IndexPath) -> Bool {
        switch indexPath.section {
        case 0: //section 0 for travellers
            if (numberOfRowsInSection(section: 1) == 0 && numberOfRowsInSection(section: 2) == 0 && numberOfRowsInSection(section: 3) == 0) {
                return (indexPath.row == self.numberOfRowsInSection(section: indexPath.section) - 1)
            }
        case 1: //section 1 for phone contacts
            if (numberOfRowsInSection(section: 2) == 0 && numberOfRowsInSection(section: 3) == 0) {
                return (indexPath.row == self.numberOfRowsInSection(section: indexPath.section) - 1)
            }
        case 2: //section 2 for facebook contact
            if (numberOfRowsInSection(section: 3) == 0) {
                return (indexPath.row == self.numberOfRowsInSection(section: indexPath.section) - 1)
            }
        case 3: //section 3 for google contacts
            return (indexPath.row == self.numberOfRowsInSection(section: indexPath.section) - 1)
        default: break
        }
        
        return false
    }
    
    func resetData() {
        travellerContacts = []
        phoneContacts = []
        facebookContacts = []
        googleContacts = []
    }
    
    func search(forText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        perform(#selector(callSearch(_:)), with: forText, afterDelay: 0.5)
    }
    
    
    @objc private func callSearch(_ forText: String) {
        printDebug("search text: \(forText)")
        
        guard !forText.isEmpty else {
            resetData()
            self.delegate?.searchDidComplete()
            return
        }
        let allContact = GuestDetailsVM.shared.guests.flatMap({ $0})
        
        self.travellerContacts = HCSelectGuestsVM.shared._travellerContacts.filter({ (contact) -> Bool in
            for guest in allContact {
                if guest.firstName.lowercased() == contact.firstName.lowercased() && guest.lastName.lowercased() == contact.lastName.lowercased() {
                    return false
                }
            }
            var name = ""
            if isFirstNameTextField  {
                if let selectedGuest = self.selectedGuest, !selectedGuest.lastName.isEmpty {
                    if contact.lastName.lowercased().contains(selectedGuest.lastName.lowercased()) {
                        name = contact.firstName
                    }
                } else {
                    name = contact.fullName
                }
            } else {
                if let selectedGuest = self.selectedGuest, !selectedGuest.firstName.isEmpty {
                    if contact.firstName.lowercased().contains(selectedGuest.firstName.lowercased()) {
                        name = contact.lastName
                    }
                    
                } else {
                    name = contact.fullName
                }
            }
            return name.lowercased().contains(forText.lowercased())
        })
        self.phoneContacts = HCSelectGuestsVM.shared._phoneContacts.filter({ (contact) -> Bool in
            for guest in allContact {
                if guest.firstName.lowercased() == contact.firstName.lowercased() && guest.lastName.lowercased() == contact.lastName.lowercased() {
                    return false
                }
            }
            var name = ""
            if isFirstNameTextField  {
                if let selectedGuest = self.selectedGuest, !selectedGuest.lastName.isEmpty {
                    if contact.lastName.lowercased().contains(selectedGuest.lastName.lowercased()) {
                        name = contact.firstName
                    }
                } else {
                    name = contact.fullName
                }
            } else {
                if let selectedGuest = self.selectedGuest, !selectedGuest.firstName.isEmpty {
                    if contact.firstName.lowercased().contains(selectedGuest.firstName.lowercased()) {
                        name = contact.lastName
                    }
                    
                } else {
                    name = contact.fullName
                }
            }
            return name.lowercased().contains(forText.lowercased())
        })
        self.facebookContacts = HCSelectGuestsVM.shared._facebookContacts.filter({ (contact) -> Bool in
            for guest in allContact {
                if guest.firstName.lowercased() == contact.firstName.lowercased() && guest.lastName.lowercased() == contact.lastName.lowercased() {
                    return false
                }
            }
            var name = ""
            if isFirstNameTextField  {
                if let selectedGuest = self.selectedGuest, !selectedGuest.lastName.isEmpty {
                    if contact.lastName.lowercased().contains(selectedGuest.lastName.lowercased()) {
                        name = contact.firstName
                    }
                } else {
                    name = contact.fullName
                }
            } else {
                if let selectedGuest = self.selectedGuest, !selectedGuest.firstName.isEmpty {
                    if contact.firstName.lowercased().contains(selectedGuest.firstName.lowercased()) {
                        name = contact.lastName
                    }
                    
                } else {
                    name = contact.fullName
                }
            }
            return name.lowercased().contains(forText.lowercased())
        })
        self.googleContacts = HCSelectGuestsVM.shared._googleContacts.filter({ (contact) -> Bool in
            for guest in allContact {
                if guest.firstName.lowercased() == contact.firstName.lowercased() && guest.lastName.lowercased() == contact.lastName.lowercased() {
                    return false
                }
            }
            var name = ""
            if isFirstNameTextField  {
                if let selectedGuest = self.selectedGuest, !selectedGuest.lastName.isEmpty {
                    if contact.lastName.lowercased().contains(selectedGuest.lastName.lowercased()) {
                        name = contact.firstName
                    }
                } else {
                    name = contact.fullName
                }
            } else {
                if let selectedGuest = self.selectedGuest, !selectedGuest.firstName.isEmpty {
                    if contact.firstName.lowercased().contains(selectedGuest.firstName.lowercased()) {
                        name = contact.lastName
                    }
                    
                } else {
                    name = contact.fullName
                }
            }
            return name.lowercased().contains(forText.lowercased())
        })
        self.delegate?.searchDidComplete()
    }
    
    
    func webserviceForGetSalutations() {
        APICaller.shared.callGetSalutationsApi(completionBlock: { success, data, errors in
            
            if success {
                self.salutation = data
            }
            else {
                AppGlobals.shared.showErrorOnToastView(withErrors: errors, fromModule: .login)
            }
        })
    }
}


