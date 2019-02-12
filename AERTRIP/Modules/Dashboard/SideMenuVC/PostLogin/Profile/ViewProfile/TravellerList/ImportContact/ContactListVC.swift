//
//  ContactListVC.swift
//  AERTRIP
//
//  Created by Admin on 09/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class ContactListVC: BaseVC {
    
    enum UsingFor: Int {
        case contacts = 0
        case facebook = 1
        case google = 2
    }
    
    //MARK:- IBOutlets
    //MARK:-
    @IBOutlet weak var tableView: ATTableView!
    @IBOutlet weak var selectAllButton: UIButton!
    @IBOutlet weak var containerBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var bottomHeaderTopDiverView: ATDividerView!
    
    //MARK:- Properties
    //MARK:- Public
    var currentlyUsingFor = UsingFor.contacts
    let viewModel = ImportContactVM.shared
    
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
    
    //MARK:- ViewLifeCycle
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.initialSetups()
    }
    
    override func setupColors() {
        self.selectAllButton.tintColor = AppColors.clear
        self.selectAllButton.setTitleColor(AppColors.themeGreen, for: .normal)
        self.selectAllButton.setTitleColor(AppColors.themeGreen, for: .selected)
    }
    
    override func setupTexts() {
        self.selectAllButton.setTitle(LocalizedString.SelectAll.localized, for: .normal)
        self.selectAllButton.setTitle(LocalizedString.DeselectAll.localized, for: .selected)
    }
    
    override func setupFonts() {
        self.selectAllButton.titleLabel?.font = AppFonts.Regular.withSize(18.0)
    }
    
    override func bindViewModel() {
        self.viewModel.delegate = self
    }
    
    override func dataChanged(_ note: Notification) {
        if let obj = note.object as? ImportContactVM.Notification {
            if obj == .phoneContactFetched {
                self.fetchPhoneContactsSuccess()
            }
            else if obj == .selectionChanged {
                self.selectionDidChanged()
            }
            else if obj == .searchDone {
                self.tableView.reloadData()
            }
        }
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
    //    self.bottomHeaderTopDiverView.isHidden = true
    }
    
    //MARK:- Public
    
    
    //MARK:- Action
    @IBAction func selectAllButtonAction(_ sender: UIButton) {
        if self.currentlyUsingFor == .contacts {
            if sender.isSelected {
                //remove all
                self.viewModel.selectedPhoneContacts.removeAll()
            }
            else {
                //add all
                self.viewModel.selectedPhoneContacts = self.viewModel.phoneContacts
            }
        }
        else if self.currentlyUsingFor == .facebook {
            if sender.isSelected {
                //remove all
                self.viewModel.selectedFacebookContacts.removeAll()
            }
            else {
                //add all
                self.viewModel.selectedFacebookContacts = self.viewModel.facebookContacts
            }
        }
        else if self.currentlyUsingFor == .google {
            if sender.isSelected {
                //remove all
                self.viewModel.selectedGoogleContacts.removeAll()
            }
            else {
                //add all
                self.viewModel.selectedGoogleContacts = self.viewModel.googleContacts
            }
        }
        sender.isSelected = !sender.isSelected
    }
}

//MARK:- Table View Delegate and DataSource
//MARK:-
extension ContactListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.currentlyUsingFor == .contacts {
            tableView.backgroundView?.isHidden = !self.viewModel.phoneContacts.isEmpty
            self.selectAllButton.isHidden = self.viewModel.phoneContacts.isEmpty
            self.bottomHeaderTopDiverView.isHidden = self.viewModel.phoneContacts.isEmpty
            return self.viewModel.phoneContacts.count
        }
        else if self.currentlyUsingFor == .facebook {
            tableView.backgroundView?.isHidden = !self.viewModel.facebookContacts.isEmpty
            self.selectAllButton.isHidden = self.viewModel.facebookContacts.isEmpty
             self.bottomHeaderTopDiverView.isHidden = self.viewModel.facebookContacts.isEmpty
            return self.viewModel.facebookContacts.count
        }
        else if self.currentlyUsingFor == .google {
            tableView.backgroundView?.isHidden = !self.viewModel.googleContacts.isEmpty
            self.selectAllButton.isHidden = self.viewModel.googleContacts.isEmpty
            self.bottomHeaderTopDiverView.isHidden = self.viewModel.googleContacts.isEmpty
            return self.viewModel.googleContacts.count
        }
        tableView.backgroundView?.isHidden = false
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ContactDetailsTableCell") as? ContactDetailsTableCell else {
            return UITableViewCell()
        }

        if self.currentlyUsingFor == .contacts {
            cell.contact = self.viewModel.phoneContacts[indexPath.row]
            cell.selectionButton.isSelected = self.viewModel.selectedPhoneContacts.contains(where: { (contact) -> Bool in
                contact.id == self.viewModel.phoneContacts[indexPath.row].id
            })
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
                self.selectAllButton.isSelected = false
            }
            else {
                self.viewModel.selectedPhoneContacts.append(self.viewModel.phoneContacts[indexPath.row])
                if self.viewModel.selectedPhoneContacts.count >= self.viewModel.phoneContacts.count {
                    self.selectAllButtonAction(self.selectAllButton)
                }
            }
        }
        else if self.currentlyUsingFor == .facebook {
            if let index = self.viewModel.selectedFacebookContacts.firstIndex(where: { (contact) -> Bool in
                contact.id == self.viewModel.facebookContacts[indexPath.row].id
            }) {
                self.viewModel.selectedFacebookContacts.remove(at: index)
                self.selectAllButton.isSelected = false
            }
            else {
                self.viewModel.selectedFacebookContacts.append(self.viewModel.facebookContacts[indexPath.row])
                if self.viewModel.selectedFacebookContacts.count >= self.viewModel.facebookContacts.count {
                    self.selectAllButtonAction(self.selectAllButton)
                }
            }
        }
        else if self.currentlyUsingFor == .google {
            if let index = self.viewModel.selectedGoogleContacts.firstIndex(where: { (contact) -> Bool in
                contact.id == self.viewModel.googleContacts[indexPath.row].id
            }) {
                self.viewModel.selectedGoogleContacts.remove(at: index)
                self.selectAllButton.isSelected = false
            }
            else {
                self.viewModel.selectedGoogleContacts.append(self.viewModel.googleContacts[indexPath.row])
                if self.viewModel.selectedGoogleContacts.count >= self.viewModel.googleContacts.count {
                    self.selectAllButtonAction(self.selectAllButton)
                }
            }
        }
    }
}

//MARK:- ViewModel Delegate
//MARK:-
extension ContactListVC: EmptyScreenViewDelegate {
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
extension ContactListVC: ImportContactVMDelegate {
    func willSaveContacts() {
        
    }
    
    func saveContactsSuccess() {
        
    }
    
    func saveContactsFail() {
        
    }
    
    func willFetchPhoneContacts() {
        
    }
    
    func fetchPhoneContactsSuccess() {
        
        if self.currentlyUsingFor == .contacts, self.viewModel.phoneContacts.isEmpty {
            AppToast.default.showToastMessage(message: "No contacts in this phone.")
        } else if self.currentlyUsingFor == .facebook, self.viewModel.facebookContacts.isEmpty {
             AppToast.default.showToastMessage(message: "No contacts in this facebook.")
        } else if self.currentlyUsingFor == .google, self.viewModel.googleContacts.isEmpty {
             AppToast.default.showToastMessage(message: "No contacts in this google.")
        }
        self.tableView.reloadData()
    }
    
    func selectionDidChanged() {
        self.tableView.reloadData()
    }
}
