//
//  HCGuestListVC.swift
//  AERTRIP
//
//  Created by Admin on 15/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class HCGuestListVC: BaseVC {
    
    enum UsingFor: Int {
        case travellers = 0
        case contacts = 1
        case facebook = 2
        case google = 3
        
        var title: String {
            switch self {
            case .travellers:
                return LocalizedString.Travellers.localized
                
            case .contacts:
                return LocalizedString.Contacts.localized
                
            case .facebook:
                return LocalizedString.Facebook.localized
                
            case .google:
                return LocalizedString.Google.localized
            }
        }
    }
    
    //MARK:- IBOutlets
    //MARK:-
    @IBOutlet weak var tableView: ATTableView!
    @IBOutlet weak var containerBottomConstraint: NSLayoutConstraint!
    
    //MARK:- Properties
    //MARK:- Public
    var currentlyUsingFor = UsingFor.contacts
    let viewModel = HCSelectGuestsVM.shared //only used for fetching the contacts from diffrent sources

    //MARK:- Private
    private lazy var allowEmptyView: EmptyScreenView = {
        let newEmptyView = EmptyScreenView()
        
        if self.currentlyUsingFor == .travellers {
            newEmptyView.vType = .noTraveller
        }
        else if self.currentlyUsingFor == .contacts {
            newEmptyView.vType = .importPhoneContacts
        }
        else if self.currentlyUsingFor == .facebook {
            newEmptyView.vType = .importFacebookContacts
        }
        else if self.currentlyUsingFor == .google {
            newEmptyView.vType = .importGoogleContacts
        }
        
        newEmptyView.delegate = self
        
        return newEmptyView
    }()
    
    private lazy var noResultemptyView: EmptyScreenView = {
        let newEmptyView = EmptyScreenView()
        newEmptyView.vType = .noResult
        return newEmptyView
    }()
    
    //MARK:- ViewLifeCycle
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.initialSetups()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.containerBottomConstraint.constant = AppFlowManager.default.safeAreaInsets.bottom
    }
    
    override func setupColors() {
    }
    
    override func setupTexts() {
    }
    
    override func setupFonts() {
    }
    
    override func bindViewModel() {
        self.viewModel.delegateList = self
    }
    
    override func dataChanged(_ note: Notification) {
        if let obj = note.object as? HCSelectGuestsVM.Notification {
            if obj == .contactFetched {
                self.fetchPhoneContactsSuccess()
            }
            else if obj == .selectionChanged {
                self.reloadList()
            }
            else if obj == .searchDone {
                if self.currentlyUsingFor == .travellers && !self.viewModel.travellerContacts.isEmpty {
                    tableView.backgroundView = noResultemptyView
                }
                else if self.currentlyUsingFor == .contacts && !self.viewModel.phoneContacts.isEmpty {
                    tableView.backgroundView = noResultemptyView
                    
                }
                else if self.currentlyUsingFor == .facebook && !self.viewModel.facebookContacts.isEmpty {
                    tableView.backgroundView = noResultemptyView
                    
                }
                else if self.currentlyUsingFor == .google && !self.viewModel.googleContacts.isEmpty {
                    tableView.backgroundView = noResultemptyView
                }
                self.reloadList()
            }
        }
    }
    
    deinit {
        printDebug("deinit")
    }
    
    //MARK:- Methods
    //MARK:- Private
    private func initialSetups() {
        self.viewModel.fetchTravellersContact()
        self.tableView.backgroundView = self.allowEmptyView
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        noResultemptyView.mainImageViewTopConstraint.constant = 300
    }
    
    private func reloadList() {
        self.tableView.reloadData()
    }
    
    //MARK:- Public
    
    
    //MARK:- Action
}

//MARK:- Table View Delegate and DataSource
//MARK:-
extension HCGuestListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.currentlyUsingFor == .travellers {
            tableView.backgroundView?.isHidden = !self.viewModel.travellerContacts.isEmpty
            return self.viewModel.travellerContacts.count
        }
        else if self.currentlyUsingFor == .contacts {
            
            tableView.backgroundView?.isHidden = !self.viewModel.phoneContacts.isEmpty
            return self.viewModel.phoneContacts.count
        }
        else if self.currentlyUsingFor == .facebook {
            tableView.backgroundView?.isHidden = !self.viewModel.facebookContacts.isEmpty
            return self.viewModel.facebookContacts.count
        }
        else if self.currentlyUsingFor == .google {
            tableView.backgroundView?.isHidden = !self.viewModel.googleContacts.isEmpty
            return self.viewModel.googleContacts.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ContactDetailsTableCell") as? ContactDetailsTableCell else {
            return UITableViewCell()
        }
        
        if self.currentlyUsingFor == .travellers {
            cell.contact = self.viewModel.travellerContacts[indexPath.row]
            cell.dividerView.isHidden = indexPath.row == (self.viewModel.travellerContacts.count - 1)
            cell.selectionButton.isSelected = self.viewModel.selectedTravellerContacts.contains(where: { (contact) -> Bool in
                contact.id == self.viewModel.travellerContacts[indexPath.row].id
            })
        }
        else if self.currentlyUsingFor == .contacts {
            cell.contact = self.viewModel.phoneContacts[indexPath.row]
            cell.dividerView.isHidden = indexPath.row == (self.viewModel.phoneContacts.count - 1)
            cell.selectionButton.isSelected = self.viewModel.selectedPhoneContacts.contains(where: { (contact) -> Bool in
                contact.id == self.viewModel.phoneContacts[indexPath.row].id
            })
        }
        else if self.currentlyUsingFor == .facebook {
            cell.contact = self.viewModel.facebookContacts[indexPath.row]
            cell.dividerView.isHidden = indexPath.row == (self.viewModel.facebookContacts.count - 1)
            cell.selectionButton.isSelected = self.viewModel.selectedFacebookContacts.contains(where: { (contact) -> Bool in
                contact.id == self.viewModel.facebookContacts[indexPath.row].id
            })
        }
        else if self.currentlyUsingFor == .google {
            cell.contact = self.viewModel.googleContacts[indexPath.row]
            cell.dividerView.isHidden = indexPath.row == (self.viewModel.googleContacts.count - 1)
            cell.selectionButton.isSelected = self.viewModel.selectedGoogleContacts.contains(where: { (contact) -> Bool in
                contact.id == self.viewModel.googleContacts[indexPath.row].id
            })
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard HotelsSearchVM.hotelFormData.totalGuestCount > self.viewModel.allSelectedCount else {
          return
        }
        
        
        if self.currentlyUsingFor == .travellers {
            
            if let oIndex = self.viewModel.originalIndex(forContact: self.viewModel.travellerContacts[indexPath.row], forType: .travellers) {
                
                if let index = self.viewModel.selectedTravellerContacts.firstIndex(where: { (contact) -> Bool in
                    contact.id == self.viewModel.travellerContacts[indexPath.row].id
                }) {
                    self.viewModel.selectedTravellerContacts.remove(at: index)
                    self.viewModel.remove(atIndex: oIndex, for: .travellers)
                }
                else {
                self.viewModel.selectedTravellerContacts.append(self.viewModel.travellerContacts[indexPath.row])
                    self.viewModel.add(atIndex: oIndex, for: .travellers)
                }
            }
        }
        else if self.currentlyUsingFor == .contacts {
            if let index = self.viewModel.selectedPhoneContacts.firstIndex(where: { (contact) -> Bool in
                contact.id == self.viewModel.phoneContacts[indexPath.row].id
            }) {
                self.viewModel.selectedPhoneContacts.remove(at: index)
                self.viewModel.remove(atIndex: indexPath.row, for: .contacts)
            }
            else {
                
                let newContact = self.viewModel.phoneContacts[indexPath.row]
                self.viewModel.selectedPhoneContacts.append(newContact)
                if let index = self.viewModel._phoneContacts.firstIndex(where: { (contact) -> Bool in
                    contact.id == newContact.id
                }) {
                    //get the original index of the contact
                    self.viewModel.add(atIndex: index, for: .contacts)
                }
            }
        }
        else if self.currentlyUsingFor == .facebook {
            if let index = self.viewModel.selectedFacebookContacts.firstIndex(where: { (contact) -> Bool in
                contact.id == self.viewModel.facebookContacts[indexPath.row].id
            }) {
                self.viewModel.selectedFacebookContacts.remove(at: index)
                self.viewModel.remove(atIndex: indexPath.row, for: .facebook)
            }
            else {
                
                let newContact = self.viewModel.facebookContacts[indexPath.row]
                self.viewModel.selectedFacebookContacts.append(newContact)
                if let index = self.viewModel._facebookContacts.firstIndex(where: { (contact) -> Bool in
                    contact.id == newContact.id
                }) {
                    //get the original index of the contact
                    self.viewModel.add(atIndex: index, for: .facebook)
                }
            }
        }
        else if self.currentlyUsingFor == .google {
            if let index = self.viewModel.selectedGoogleContacts.firstIndex(where: { (contact) -> Bool in
                contact.id == self.viewModel.googleContacts[indexPath.row].id
            }) {
                self.viewModel.selectedGoogleContacts.remove(at: index)
                self.viewModel.remove(atIndex: indexPath.row, for: .google)
            }
            else {
                
                let newContact = self.viewModel.googleContacts[indexPath.row]
                self.viewModel.selectedGoogleContacts.append(newContact)
                if let index = self.viewModel._googleContacts.firstIndex(where: { (contact) -> Bool in
                    contact.id == newContact.id
                }) {
                    //get the original index of the contact
                    self.viewModel.add(atIndex: index, for: .google)
                }
            }
        }
    }
}

//MARK:- ViewModel Delegate
//MARK:-
extension HCGuestListVC: EmptyScreenViewDelegate {
    func firstButtonAction(sender: ATButton) {
        if self.currentlyUsingFor == .travellers {
            self.viewModel.fetchTravellersContact()
        }
        else if self.currentlyUsingFor == .contacts {
            sender.isLoading = true
            delay(seconds: 0.1) { [weak self] in
                guard let sSelf = self else {return}
                sSelf.viewModel.fetchPhoneContacts(forVC: sSelf)
            }
        }
        else if self.currentlyUsingFor == .facebook {
            self.viewModel.fetchFacebookContacts(forVC: self)
        }
        else if self.currentlyUsingFor == .google {
            self.viewModel.fetchGoogleContacts(forVC: self)
        }
    }
}

//MARK:- ViewModel Delegate
//MARK:-
extension HCGuestListVC: HCSelectGuestsVMDelegate {

    func add(atIndex index: Int, for usingFor: HCGuestListVC.UsingFor) {
        self.reloadList()
    }
    
    func remove(atIndex index: Int, for usingFor: HCGuestListVC.UsingFor) {
        self.reloadList()
    }
    
    func willSaveContacts() {
        
    }
    
    func saveContactsSuccess() {
        
    }
    
    func saveContactsFail() {
        
    }
    
    func willFetchPhoneContacts() {
        
    }
    
    func fetchPhoneContactsSuccess() {
        
        switch self.currentlyUsingFor {
            
        case .travellers:
            if self.viewModel.travellerContacts.isEmpty {
                tableView.backgroundView = noResultemptyView
            }
            else {
                tableView.backgroundView = nil
            }
            
        case .contacts:
            if !self.viewModel.isPhoneContactsAllowed {
                tableView.backgroundView = allowEmptyView
            }
            else if self.viewModel.phoneContacts.isEmpty {
                tableView.backgroundView = noResultemptyView
            }
            else {
                tableView.backgroundView = nil
            }
            
        case .facebook:
            if !self.viewModel.isFacebookContactsAllowed {
                tableView.backgroundView = allowEmptyView
            }
            else if self.viewModel.facebookContacts.isEmpty {
                tableView.backgroundView = noResultemptyView
            }
            else {
                tableView.backgroundView = nil
            }
            
        case .google:
            if !self.viewModel.isGoogleContactsAllowed {
                tableView.backgroundView = allowEmptyView
            }
            else if self.viewModel.googleContacts.isEmpty {
                tableView.backgroundView = noResultemptyView
            }
            else {
                tableView.backgroundView = nil
            }
        }
        
        self.reloadList()
    }
}
