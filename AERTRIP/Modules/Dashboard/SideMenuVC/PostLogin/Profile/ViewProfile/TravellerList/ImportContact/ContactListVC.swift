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
        self.viewModel.delegateList = self
    }
    
    override func dataChanged(_ note: Notification) {
        if let obj = note.object as? ImportContactVM.Notification {
            if obj == .phoneContactFetched {
                self.isPermissionGiven = !self.viewModel.sections.isEmpty
                self.viewModel.createSectionWiseDataForContacts(for: .contacts)
                self.fetchPhoneContactsSuccess()
                tableView.backgroundView = noResultemptyView
            }
            else if obj == .facebookContactFetched {
                self.isPermissionGiven = !self.viewModel.facebookSection.isEmpty
                self.viewModel.createSectionWiseDataForContacts(for: .facebook)
                self.fetchPhoneContactsSuccess()
                tableView.backgroundView = noResultemptyView
            }
            else if obj == .googleContactFetched {
                self.isPermissionGiven = !self.viewModel.googleSection.isEmpty
                self.viewModel.createSectionWiseDataForContacts(for: .google)
                self.fetchPhoneContactsSuccess()
                tableView.backgroundView = noResultemptyView
            }
            else if obj == .selectionChanged {
                self.reloadList()
            }
            else if obj == .searchDone {
                if self.currentlyUsingFor == .contacts && !self.viewModel.phoneContacts.isEmpty {
                    self.viewModel.createSectionWiseDataForContacts(for: .contacts)
                    tableView.backgroundView = noResultemptyView
                    
                }
                else if self.currentlyUsingFor == .facebook && !self.viewModel.facebookContacts.isEmpty {
                    self.viewModel.createSectionWiseDataForContacts(for: .facebook)
                    tableView.backgroundView = noResultemptyView
                    
                }
                else if self.currentlyUsingFor == .google && !self.viewModel.googleContacts.isEmpty {
                    self.viewModel.createSectionWiseDataForContacts(for: .google)
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
        
        self.tableView.backgroundView = self.emptyView
        self.tableView.sectionIndexColor = AppColors.themeGreen
        self.tableView.delegate = self
        self.tableView.dataSource = self
        noResultemptyView.mainImageViewTopConstraint.constant = 300
    }
    
    private func reloadList() {
        self.tableView.reloadData()
    }
    
    private func hideSelectAllButton(isHidden: Bool = true) {
        self.bottomHeaderTopDiverView.isHidden = isHidden
        self.selectAllButton.isHidden = isHidden

        tableView.backgroundView?.isHidden = !isHidden
        self.isPermissionGiven = !isHidden
    }
    
    //MARK:- Public
    
    
    //MARK:- Action
    func getIndexPath(contact: ATContact) -> IndexPath? {
        var index: IndexPath?
        switch self.currentlyUsingFor {
        case .contacts:
            if let section = self.viewModel.sections.firstIndex(where: { $0.letter == "\(contact.firstName.firstCharacter)" }) {
                
                if let row = self.viewModel.sections[section].contacts.firstIndex(where: { (cntc) -> Bool in
                    cntc.id == contact.id
                }) {
                    index = IndexPath(row: row, section: section)
                }
            }
            
        case .facebook:
            if let section = self.viewModel.facebookSection.firstIndex(where: { $0.letter == "\(contact.firstName.firstCharacter)" }) {
                
                if let row = self.viewModel.facebookSection[section].contacts.firstIndex(where: { (cntc) -> Bool in
                    cntc.id == contact.id
                }) {
                    index = IndexPath(row: row, section: section)
                }
            }
        case .google:
            if let section = self.viewModel.googleSection.firstIndex(where: { $0.letter == "\(contact.firstName.firstCharacter)" }) {
                
                if let row = self.viewModel.googleSection[section].contacts.firstIndex(where: { (cntc) -> Bool in
                    cntc.id == contact.id
                }) {
                    index = IndexPath(row: row, section: section)
                }
            }
        }
        
        return index
    }
    @IBAction func selectAllButtonAction(_ sender: UIButton) {
        sender.disable(forSeconds: 0.6)
        if self.currentlyUsingFor == .contacts {
            if sender.isSelected {
                //remove all
                self.viewModel.removeAll(for: .contacts)
                self.viewModel.selectedPhoneContacts.removeAll()
            }
            else {
                //remove all preselected items
                for contact in self.viewModel.selectedPhoneContacts {
                    if let index = self.getIndexPath(contact: contact) {
                        self.tableView(self.tableView, didSelectRowAt: index)
                    }
                }
                
                self.viewModel.selectedPhoneContacts = self.viewModel.phoneContacts
                //add all
                self.viewModel.addAll(for: .contacts)
            }
        }
        else if self.currentlyUsingFor == .facebook {
            if sender.isSelected {
                //remove all
                self.viewModel.removeAll(for: .facebook)
                self.viewModel.selectedFacebookContacts.removeAll()
                
            }
            else {
                // remove all preselected facebook Items
                for contact in self.viewModel.facebookContacts {
                    if let index = self.getIndexPath(contact: contact) {
                        self.tableView(self.tableView, didSelectRowAt: index)
                    }
                }
                
                self.viewModel.selectedFacebookContacts = self.viewModel.facebookContacts
                //add all
                self.viewModel.addAll(for: .facebook)
            }
        }
        else if self.currentlyUsingFor == .google {
            if sender.isSelected {
                //remove all
                self.viewModel.removeAll(for: .google)
                self.viewModel.selectedGoogleContacts.removeAll()
                
            }
            else {
                // remove all preselected google Contacts Items
                for contact in self.viewModel.selectedGoogleContacts {
                    if let index = self.getIndexPath(contact: contact) {
                        self.tableView(self.tableView, didSelectRowAt: index)
                    }
                }
                
                self.viewModel.selectedGoogleContacts = self.viewModel.googleContacts
                //add all
                self.viewModel.addAll(for: .google)
            }
        }
        sender.isSelected = !sender.isSelected
    }
}

//MARK:- Table View Delegate and DataSource
//MARK:-
extension ContactListVC: UITableViewDelegate, UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.currentlyUsingFor == .contacts {
            self.hideSelectAllButton(isHidden: self.viewModel.sections.isEmpty)
            return self.viewModel.sections.count
        } else if self.currentlyUsingFor == .facebook {
            self.hideSelectAllButton(isHidden: self.viewModel.facebookSection.isEmpty)
            return self.viewModel.facebookSection.count
        } else if self.currentlyUsingFor == .google {
            self.hideSelectAllButton(isHidden: self.viewModel.googleSection.isEmpty)
            return self.viewModel.googleSection.count
        }
        
        return 0
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.currentlyUsingFor == .contacts {
            return self.viewModel.sections[section].contacts.count
        }
        else if self.currentlyUsingFor == .facebook {
            return self.viewModel.facebookSection[section].contacts.count
        }
        else if self.currentlyUsingFor == .google {
            return self.viewModel.googleSection[section].contacts.count
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
        if self.currentlyUsingFor == .contacts {
            cell.contact = self.viewModel.sections[indexPath.section].contacts[indexPath.row]
            cell.selectionButton.isSelected = self.viewModel.selectedPhoneContacts.contains(where: { (contact) -> Bool in
                contact.id == self.viewModel.sections[indexPath.section].contacts[indexPath.row].id
            })
            cell.dividerView.isHidden = indexPath.row == (self.viewModel.sections[indexPath.section].contacts.count - 1)
        }
        else if self.currentlyUsingFor == .facebook {
            cell.contact = self.viewModel.facebookSection[indexPath.section].contacts[indexPath.row]
            cell.selectionButton.isSelected = self.viewModel.selectedFacebookContacts.contains(where: { (contact) -> Bool in
                contact.id == self.viewModel.facebookSection[indexPath.section].contacts[indexPath.row].id
            })
            cell.dividerView.isHidden = indexPath.row == (self.viewModel.facebookSection[indexPath.section].contacts.count - 1)
        }
        else if self.currentlyUsingFor == .google {
            cell.contact = self.viewModel.googleSection[indexPath.section].contacts[indexPath.row]
            cell.selectionButton.isSelected = self.viewModel.selectedGoogleContacts.contains(where: { (contact) -> Bool in
                contact.id == self.viewModel.googleSection[indexPath.section].contacts[indexPath.row].id
            })
            cell.dividerView.isHidden = indexPath.row == (self.viewModel.googleSection[indexPath.section].contacts.count - 1)
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.currentlyUsingFor == .contacts {
            if let index = self.viewModel.selectedPhoneContacts.firstIndex(where: { (contact) -> Bool in
                contact.id == self.viewModel.sections[indexPath.section].contacts[indexPath.row].id
            }) {
                self.viewModel.selectedPhoneContacts.remove(at: index)
                self.selectAllButton.isSelected = false
                self.viewModel.remove(fromIndex: index, for: .contacts)
            }
            else {
                self.viewModel.selectedPhoneContacts.append(self.viewModel.sections[indexPath.section].contacts[indexPath.row])
                self.viewModel.add(for: .contacts)
                self.selectAllButton.isSelected = self.viewModel.selectedPhoneContacts.count >= self.viewModel.sections.count
            }
            
        }
        else if self.currentlyUsingFor == .facebook {
            if let index = self.viewModel.selectedFacebookContacts.firstIndex(where: { (contact) -> Bool in
                contact.id == self.viewModel.facebookSection[indexPath.section].contacts[indexPath.row].id
            }) {
                self.viewModel.selectedFacebookContacts.remove(at: index)
                self.selectAllButton.isSelected = false
                self.viewModel.remove(fromIndex: index, for: .facebook)
            }
            else {
                self.viewModel.selectedFacebookContacts.append(self.viewModel.facebookSection[indexPath.section].contacts[indexPath.row])
                self.viewModel.add(for: .facebook)
                self.selectAllButton.isSelected = self.viewModel.selectedFacebookContacts.count >= self.viewModel.facebookSection.count
            }
        }
        else if self.currentlyUsingFor == .google {
            if let index = self.viewModel.selectedGoogleContacts.firstIndex(where: { (contact) -> Bool in
                contact.id == self.viewModel.googleSection[indexPath.section].contacts[indexPath.row].id
            }) {
                self.viewModel.selectedGoogleContacts.remove(at: index)
                self.selectAllButton.isSelected = false
                self.viewModel.remove(fromIndex: index, for: .google)
            }
            else {
                self.viewModel.selectedGoogleContacts.append(self.viewModel.googleSection[indexPath.section].contacts[indexPath.row])
                self.viewModel.add(for: .google)
                self.selectAllButton.isSelected = self.viewModel.selectedGoogleContacts.count >= self.viewModel.googleSection.count
            }
        }
    }
    
    // Return section Index For titles
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if self.currentlyUsingFor == .contacts {
            return self.viewModel.sections.map{$0.letter}
        } else if self.currentlyUsingFor == .facebook {
            return self.viewModel.facebookSection.map{$0.letter}
        } else if self.currentlyUsingFor == .google {
            return self.viewModel.googleSection.map{$0.letter}
        }
        return []
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if self.currentlyUsingFor == .contacts {
            return self.viewModel.sections[section].letter
        } else if self.currentlyUsingFor == .facebook {
            return self.viewModel.facebookSection[section].letter
        } else if self.currentlyUsingFor == .google {
            return self.viewModel.googleSection[section].letter
        }
        return nil
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
    func add(for usingFor: ContactListVC.UsingFor) {
        self.reloadList()
    }
    
    func remove(fromIndex: Int, for usingFor: ContactListVC.UsingFor) {
        self.reloadList()
    }
    
    func addAll(for usingFor: ContactListVC.UsingFor) {
        self.reloadList()
    }
    
    func removeAll(for usingFor: ContactListVC.UsingFor) {
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
        self.reloadList()
    }
}
