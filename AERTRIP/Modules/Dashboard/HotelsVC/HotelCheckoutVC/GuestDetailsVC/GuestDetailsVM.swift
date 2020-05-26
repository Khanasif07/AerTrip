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
    typealias GuestDetailContactTouple = (firstName: String, lastName: String, fullName: String, dob: String, salutation: String)
    
    static let shared = GuestDetailsVM()
    weak var delegate: GuestDetailsVMDelegate?
    // Save Hotel Form Data
    var hotelFormData: HotelFormPreviosSearchData = HotelFormPreviosSearchData()
    var selectedIndexPath: IndexPath = IndexPath()
    var salutation = [String]()
    var canShowSalutationError = false
    
    // GuestModalArray for travellers
    var guests: [[ATContact]] = [[]]
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
    
    private override init() {}
    
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
            return (obj.firstName, obj.lastName, obj.fullName, obj.dob, obj.salutation)
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
        self.travellerContacts = HCSelectGuestsVM.shared._travellerContacts.filter({ (contact) -> Bool in
            contact.fullName.lowercased().contains(forText.lowercased())
        })
        self.phoneContacts = HCSelectGuestsVM.shared._phoneContacts.filter({ (contact) -> Bool in
            contact.fullName.lowercased().contains(forText.lowercased())
        })
        self.facebookContacts = HCSelectGuestsVM.shared._facebookContacts.filter({ (contact) -> Bool in
            contact.fullName.lowercased().contains(forText.lowercased())
        })
        self.googleContacts = HCSelectGuestsVM.shared._googleContacts.filter({ (contact) -> Bool in
            contact.fullName.lowercased().contains(forText.lowercased())
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


