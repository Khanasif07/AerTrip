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
    }
    
    //MARK:- IBOutlets
    //MARK:-
    @IBOutlet weak var tableView: ATTableView!
    @IBOutlet weak var containerBottomConstraint: NSLayoutConstraint!
    
    //MARK:- Properties
    //MARK:- Public
    var currentlyUsingFor = UsingFor.contacts
    let viewModel = ImportContactVM.shared //only used for fetching the contacts from diffrent sources
    var isPermissionGiven: Bool = false

    //MARK:- Private
    private lazy var emptyView: EmptyScreenView = {
        let newEmptyView = EmptyScreenView()
        
        if self.currentlyUsingFor == .contacts {
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
        
    }
    
    deinit {
        printDebug("deinit")
    }
    
    //MARK:- Methods
    //MARK:- Private
    private func initialSetups() {
        
        self.tableView.backgroundView = self.emptyView
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        noResultemptyView.mainImageViewTopConstraint.constant = 300
        //    self.bottomHeaderTopDiverView.isHidden = true
    }
    
    //MARK:- Public
    
    
    //MARK:- Action
}

//MARK:- Table View Delegate and DataSource
//MARK:-
extension HCGuestListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.currentlyUsingFor == .travellers {
            
            tableView.backgroundView?.isHidden = true
            self.isPermissionGiven = !GuestDetailsVM.shared.travellerList.isEmpty
            return GuestDetailsVM.shared.travellerList.count
        }
        else if self.currentlyUsingFor == .contacts {
            
            tableView.backgroundView?.isHidden = !self.viewModel.phoneContacts.isEmpty
            self.isPermissionGiven = !self.viewModel.phoneContacts.isEmpty
            return self.viewModel.phoneContacts.count
        }
        else if self.currentlyUsingFor == .facebook {
            tableView.backgroundView?.isHidden = !self.viewModel.facebookContacts.isEmpty
            self.isPermissionGiven = !self.viewModel.facebookContacts.isEmpty
            return self.viewModel.facebookContacts.count
        }
        else if self.currentlyUsingFor == .google {
            tableView.backgroundView?.isHidden = !self.viewModel.googleContacts.isEmpty
            self.isPermissionGiven = !self.viewModel.googleContacts.isEmpty
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
            cell.traveller = GuestDetailsVM.shared.travellerList[indexPath.row]
            cell.selectionButton.isSelected = self.viewModel.selectedPhoneContacts.contains(where: { (contact) -> Bool in
                contact.id == self.viewModel.phoneContacts[indexPath.row].id
            })
            cell.dividerView.isHidden = indexPath.row == (self.viewModel.phoneContacts.count - 1)
        }
        else if self.currentlyUsingFor == .contacts {
            cell.contact = self.viewModel.phoneContacts[indexPath.row]
            cell.selectionButton.isSelected = self.viewModel.selectedPhoneContacts.contains(where: { (contact) -> Bool in
                contact.id == self.viewModel.phoneContacts[indexPath.row].id
            })
            cell.dividerView.isHidden = indexPath.row == (self.viewModel.phoneContacts.count - 1)
        }
        else if self.currentlyUsingFor == .facebook {
            cell.contact = self.viewModel.facebookContacts[indexPath.row]
            cell.selectionButton.isSelected = self.viewModel.selectedFacebookContacts.contains(where: { (contact) -> Bool in
                contact.id == self.viewModel.facebookContacts[indexPath.row].id
            })
        }
        else if self.currentlyUsingFor == .google {
            cell.contact = self.viewModel.googleContacts[indexPath.row]
            cell.selectionButton.isSelected = self.viewModel.selectedGoogleContacts.contains(where: { (contact) -> Bool in
                contact.id == self.viewModel.googleContacts[indexPath.row].id
            })
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.currentlyUsingFor == .contacts {
            if let index = self.viewModel.selectedPhoneContacts.firstIndex(where: { (contact) -> Bool in
                contact.id == self.viewModel.phoneContacts[indexPath.row].id
            }) {
                self.viewModel.selectedPhoneContacts.remove(at: index)
                self.viewModel.remove(fromIndex: index, for: .contacts)
            }
            else {
                self.viewModel.selectedPhoneContacts.append(self.viewModel.phoneContacts[indexPath.row])
                self.viewModel.add(for: .contacts)
            }
        }
        else if self.currentlyUsingFor == .facebook {
            if let index = self.viewModel.selectedFacebookContacts.firstIndex(where: { (contact) -> Bool in
                contact.id == self.viewModel.facebookContacts[indexPath.row].id
            }) {
                self.viewModel.selectedFacebookContacts.remove(at: index)
                self.viewModel.remove(fromIndex: index, for: .facebook)
            }
            else {
                self.viewModel.selectedFacebookContacts.append(self.viewModel.facebookContacts[indexPath.row])
                self.viewModel.add(for: .facebook)
            }
        }
        else if self.currentlyUsingFor == .google {
            if let index = self.viewModel.selectedGoogleContacts.firstIndex(where: { (contact) -> Bool in
                contact.id == self.viewModel.googleContacts[indexPath.row].id
            }) {
                self.viewModel.selectedGoogleContacts.remove(at: index)
                self.viewModel.remove(fromIndex: index, for: .google)
            }
            else {
                self.viewModel.selectedGoogleContacts.append(self.viewModel.googleContacts[indexPath.row])
                self.viewModel.add(for: .google)
            }
        }
    }
}

//MARK:- ViewModel Delegate
//MARK:-
extension HCGuestListVC: EmptyScreenViewDelegate {
    func firstButtonAction(sender: UIButton) {
        if self.currentlyUsingFor == .contacts {
            self.viewModel.fetchPhoneContacts(forVC: self)
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
extension HCGuestListVC: ImportContactVMDelegate {

    func add(for usingFor: ContactListVC.UsingFor) {
        self.tableView.reloadData()
    }
    
    func remove(fromIndex: Int, for usingFor: ContactListVC.UsingFor) {
        self.tableView.reloadData()
    }
    
    func addAll(for usingFor: ContactListVC.UsingFor) {
        self.tableView.reloadData()
    }
    
    func removeAll(for usingFor: ContactListVC.UsingFor) {
        self.tableView.reloadData()
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
        self.isPermissionGiven = true
        self.tableView.reloadData()
    }
}
