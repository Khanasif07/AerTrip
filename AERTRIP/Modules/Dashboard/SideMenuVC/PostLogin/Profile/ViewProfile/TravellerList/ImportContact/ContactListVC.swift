//
//  ContactListVC.swift
//  AERTRIP
//
//  Created by Admin on 09/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit
import Contacts

class ContactListVC: BaseVC {
    
    enum UsingFor: Int {
        case contacts = 0
        case facebook = 1
        case google = 2
    }
    
    //MARK:- IBOutlets
    //MARK:-
    @IBOutlet weak var bottomBackgroundView: UIView!
    @IBOutlet weak var tableView: ATTableView!
    @IBOutlet weak var selectAllButton: UIButton!
    @IBOutlet weak var containerBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var selectAllbtnBtmConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomHeaderTopDiverView: ATDividerView!
    
    //MARK:- Properties
    //MARK:- Public
    var currentlyUsingFor = UsingFor.contacts
    let viewModel = ImportContactVM.shared
    let serialQueue = DispatchQueue(label: "serialQueue")
    let selectDeselectQueue = DispatchQueue(label: "selectDeselectQueue", qos: .userInteractive, target: .main)

    private var workItem: DispatchWorkItem?
    
    //MARK:- Private
    lazy var allowEmptyView: EmptyScreenView = {
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
        //        if UIDevice.bottomPaddingFromSafeArea > 0.0 {
        //            self.selectAllbtnBtmConstraint.constant = 0
        //        } else {
        //            self.selectAllbtnBtmConstraint.constant = 34.0
        //        }
        //        self.containerBottomConstraint.constant = AppFlowManager.default.safeAreaInsets.bottom
    }
    
    override func setupColors() {
        self.selectAllButton.tintColor = AppColors.clear
        self.bottomBackgroundView.backgroundColor = AppColors.themeGray04
        self.bottomBackgroundView.isHidden = true
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
            if obj == .contactFetched {
                self.fetchPhoneContactsSuccess()
            }
            else if obj == .selectionChanged {
                self.reloadList()
            }
            else if obj == .searchDone {
                noResultemptyView.messageLabel.isHidden = false
                noResultemptyView.messageLabel.text = "\(LocalizedString.noResults.localized + " " + LocalizedString.For.localized) '\(self.viewModel.searchingFor)'"
                if self.currentlyUsingFor == .contacts, self.viewModel.isPhoneContactsAllowed {
                    tableView.backgroundView = noResultemptyView
                }
                else if self.currentlyUsingFor == .facebook, self.viewModel.isFacebookContactsAllowed {
                    tableView.backgroundView = noResultemptyView
                    
                }
                else if self.currentlyUsingFor == .google, self.viewModel.isGoogleContactsAllowed {
                    tableView.backgroundView = noResultemptyView
                }
                
                self.reloadList()
            }
            checkForCheckAllState()
        }
    }
    
    func checkForCheckAllState() {
        if self.currentlyUsingFor == .contacts {
            guard !self.viewModel.selectedPhoneContacts.isEmpty else {return}
            serialQueue.async {
                var totalCount = 0
                var contactMatched = 0
                let tempSelectedPhoneArray = self.viewModel.selectedPhoneContacts
                self.viewModel.sections.forEach { (section) in
                    if !tempSelectedPhoneArray.isEmpty {
                        for contact in section.cnContacts {
                            if tempSelectedPhoneArray.contains(contact) {
                                contactMatched += 1
                            }
                        }
                    }
                    totalCount += section.cnContacts.count
                }
                DispatchQueue.mainAsync {
                    self.selectAllButton.isSelected = totalCount == contactMatched
                }
            }
            
        }else if self.currentlyUsingFor == .facebook {
            guard !self.viewModel.selectedFacebookContacts.isEmpty else {return}
            serialQueue.async {
                var totalCount = 0
                var contactMatched = 0
                let tempSelectedFacebookArray = self.viewModel.selectedFacebookContacts
                self.viewModel.facebookSection.forEach { (section) in
                    if !tempSelectedFacebookArray.isEmpty {
                        for contact in section.contacts {
                            if tempSelectedFacebookArray.contains(where: { (model) -> Bool in
                                return contact.id == model.id
                            }) {
                                contactMatched += 1
                            }
                        }
                    }
                    totalCount += section.contacts.count
                }
                DispatchQueue.mainAsync {
                    self.selectAllButton.isSelected = totalCount == contactMatched
                }
            }
        }
        else if self.currentlyUsingFor == .google {
            guard !self.viewModel.selectedGoogleContacts.isEmpty else {return}
            serialQueue.async {
                var totalCount = 0
                var contactMatched = 0
                let tempSelectedGoogleArray = self.viewModel.selectedGoogleContacts
                self.viewModel.googleSection.forEach { (section) in
                    if !tempSelectedGoogleArray.isEmpty {
                        for contact in section.contacts {
                            if tempSelectedGoogleArray.contains(where: { (model) -> Bool in
                                return contact.id == model.id
                            }) {
                                contactMatched += 1
                            }
                        }
                    }
                    totalCount += section.contacts.count
                }
                DispatchQueue.mainAsync {
                    self.selectAllButton.isSelected = totalCount == contactMatched
                }
            }
        }
    }
    
    deinit {
        printDebug("deinit")
    }
    
    //MARK:- Methods
    //MARK:- Private
    private func initialSetups() {
        
        self.tableView.backgroundView = self.allowEmptyView
        self.tableView.sectionIndexColor = AppColors.themeGreen
        self.tableView.delegate = self
        self.tableView.dataSource = self
       // noResultemptyView.mainImageViewTopConstraint.constant = 400
        
        if self.currentlyUsingFor == .contacts {
            if CNContactStore.authorizationStatus(for: .contacts) == .authorized {
                self.viewModel.fetchPhoneContacts(forVC: self)
            }
        }
        
    }
    
    private func reloadList() {
        self.tableView?.reloadData()
        
    }
    
    func reloadVisibleCells() {
        guard let visibleRowsIndexs = tableView.indexPathsForVisibleRows else {return}
        visibleRowsIndexs.forEach { indexPath in
            guard  let cell = tableView.cellForRow(at: indexPath) as? ContactDetailsTableCell else {return}
            populateData(in: cell, indexPath: indexPath)
        }
    }
    
    
    private func hideSelectAllButton(isHidden: Bool = true) {
        self.bottomHeaderTopDiverView.isHidden = isHidden
        self.selectAllButton.isHidden = isHidden
        self.bottomBackgroundView.isHidden = isHidden
        tableView.backgroundView?.isHidden = !isHidden
    }
    
    //MARK:- Public
    
    
    //MARK:- Action
    func getIndexPath(contact: CNContact) -> IndexPath? {
        var index: IndexPath?
        switch self.currentlyUsingFor {
        case .contacts:
            if let section = self.viewModel.sections.firstIndex(where: { $0.letter == "\(contact.firstName.firstCharacter)" }) {
                
                if let row = self.viewModel.sections[section].cnContacts.firstIndex(where: { (cntc) -> Bool in
                    cntc.id == contact.id
                }) {
                    index = IndexPath(row: row, section: section)
                }
            }
            
        default:
            return nil
        }
        
        return index
    }
    func getIndexPath(contact: ATContact) -> IndexPath? {
        var index: IndexPath?
        switch self.currentlyUsingFor {
        case .contacts:
            if let section = self.viewModel.sections.firstIndex(where: { $0.letter == "\(contact.firstName.firstCharacter)" }) {
                
                if let row = self.viewModel.sections[section].cnContacts.firstIndex(where: { (cntc) -> Bool in
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
    
    func updateSelectAllState(for usingFor: ContactListVC.UsingFor) {
        if usingFor == .contacts {
            self.selectAllButton.isSelected = false
        } else if usingFor == .facebook {
            self.selectAllButton.isSelected = false
        } else if usingFor == .google {
            self.selectAllButton.isSelected = false
        }
    }
    
    @IBAction func selectAllButtonAction(_ sender: UIButton) {
        
        self.showLoaderOnView(view: sender, show: true, backgroundColor: AppColors.themeGray04,padding:  UIEdgeInsets(top: 2.0, left: 35.0, bottom: 2.0, right: 1.0))
        workItem?.cancel()
        if self.currentlyUsingFor == .contacts {
            if sender.isSelected {
                printDebug("isSelected true")
                //remove all
                if !self.viewModel.selectedPhoneContacts.isEmpty  {
                    workItem = DispatchWorkItem(block: {
                        printDebug("Operation Started At: \(Date().timeIntervalSince1970)")
                        let allContacts = self.viewModel.sections.reduce([]) { result, section in
                            result + section.cnContacts
                        }
                        self.viewModel.selectedPhoneContacts.removeObjects(array: allContacts)
                    })
                    workItem!.notify(queue: .main) {
                        DispatchQueue.mainAsync {
                            self.viewModel.remove(for: .contacts)
                            self.hideSelectAllLoader()
                            printDebug("Operation Completed At: \(Date().timeIntervalSince1970)")
                        }
                    }
                    selectDeselectQueue.async(execute: workItem!)
                } else {
                    self.hideSelectAllLoader()
                }

            } else {
                printDebug("isSelected false")
                if !self.viewModel.selectedPhoneContacts.isEmpty  {
                    workItem = DispatchWorkItem(block: {
                        printDebug("Operation Started At: \(Date().timeIntervalSince1970)")
                        var allContacts = self.viewModel.sections.reduce([]) { result, section in
                            result + section.cnContacts
                        }
                        allContacts.removeObjects(array: self.viewModel.selectedPhoneContacts)
                        self.viewModel.selectedPhoneContacts.append(contentsOf: allContacts)
                    })

                    workItem!.notify(queue: .main) {
                        DispatchQueue.mainAsync {
                            self.viewModel.add(for: .contacts)
                            self.hideSelectAllLoader()
                            printDebug("Operation Completed At: \(Date().timeIntervalSince1970)")
                        }
                    }
                    selectDeselectQueue.async(execute: workItem!)
                }else {
                    self.viewModel.selectedPhoneContacts = self.viewModel.phoneContacts
                    DispatchQueue.mainAsync {
                        self.viewModel.addAll(for: .contacts)
                    }

                }
            }
        }
        else if self.currentlyUsingFor == .facebook {
            if sender.isSelected {
                //remove all
                if !self.viewModel.selectedFacebookContacts.isEmpty  {
                    var isContactRemoved = false
                    workItem = DispatchWorkItem(block: {
                        self.viewModel.facebookSection.forEach { (section) in
                            section.contacts.forEach { (contact) in
                                if let contactIndex = self.viewModel.selectedFacebookContacts.firstIndex(where: { (model) -> Bool in
                                    contact.id == model.id
                                }) {
                                    self.viewModel.selectedFacebookContacts.remove(at: contactIndex)
                                    isContactRemoved = true

                                }
                            }
                        }
                        DispatchQueue.mainAsync {
                            if isContactRemoved {
                                self.viewModel.remove(for: .facebook)
                            }
                            self.hideSelectAllLoader()
                        }
                    })
                    if let item = workItem {
                        selectDeselectQueue.async(execute: item)
                    }
                } else {
                    self.hideSelectAllLoader()
                }

            }
            else {
                // remove all preselected facebook Items
                //                for contact in self.viewModel.facebookContacts {
                //                    if let index = self.getIndexPath(contact: contact) {
                //                        self.tableView(self.tableView, didSelectRowAt: index)
                //                    }
                //                }

                //                self.viewModel.selectedFacebookContacts = self.viewModel.facebookContacts
                //                //add all
                //                self.viewModel.addAll(for: .facebook)

                if !self.viewModel.selectedFacebookContacts.isEmpty  {
                    var isContactAdded = false
                    workItem = DispatchWorkItem(block: {
                        self.viewModel.facebookSection.forEach { (section) in
                            section.contacts.forEach { (contact) in
                                let contactIndex = self.viewModel.selectedFacebookContacts.firstIndex(of: contact)
                                if  contactIndex == nil {
                                    self.viewModel.selectedFacebookContacts.append(contact)
                                    isContactAdded = true
                                }
                            }
                        }
                        DispatchQueue.mainAsync {
                            if isContactAdded {
                                self.viewModel.add(for: .facebook)
                            }
                            self.self.hideSelectAllLoader()
                        }
                    })
                    if let item = workItem {
                        selectDeselectQueue.async(execute: item)
                    }

                }else {
                    self.viewModel.selectedFacebookContacts = self.viewModel.facebookContacts
                    DispatchQueue.mainAsync {
                        self.viewModel.addAll(for: .facebook)
                        self.hideSelectAllLoader()
                    }
                }
            }
        }
        else if self.currentlyUsingFor == .google {
            if sender.isSelected {
                //remove all
                if !self.viewModel.selectedGoogleContacts.isEmpty  {
                    var isContactRemoved = false
                    workItem = DispatchWorkItem(block: {
                        self.viewModel.googleSection.forEach { (section) in
                            section.contacts.forEach { (contact) in
                                if let contactIndex = self.viewModel.selectedGoogleContacts.firstIndex(where: { (model) -> Bool in
                                    contact.id == model.id
                                }) {
                                    self.viewModel.selectedGoogleContacts.remove(at: contactIndex)
                                    isContactRemoved = true
                                }
                            }
                        }
                        DispatchQueue.mainAsync {
                            if isContactRemoved {
                                self.viewModel.remove(for: .google)
                            }
                            self.hideSelectAllLoader()
                        }
                    })
                    if let item = workItem {
                        selectDeselectQueue.async(execute: item)
                    }
                } else {
                    self.hideSelectAllLoader()
                }

            }
            else {
                // remove all preselected google Contacts Items
                //                for contact in self.viewModel.selectedGoogleContacts {
                //                    if let index = self.getIndexPath(contact: contact) {
                //                        self.tableView(self.tableView, didSelectRowAt: index)
                //                    }
                //                }
                if !self.viewModel.selectedGoogleContacts.isEmpty  {
                    var isContactAdded = false
                    workItem = DispatchWorkItem(block: {
                        self.viewModel.googleSection.forEach { (section) in
                            section.contacts.forEach { (contact) in
                                let contactIndex = self.viewModel.selectedGoogleContacts.firstIndex(of: contact)
                                if  contactIndex == nil {
                                    self.viewModel.selectedGoogleContacts.append(contact)
                                    isContactAdded = true
                                }
                            }
                        }
                        DispatchQueue.mainAsync {
                            if isContactAdded {
                                self.viewModel.add(for: .google)
                            }
                            self.self.hideSelectAllLoader()
                        }
                    })
                    if let item = workItem {
                        selectDeselectQueue.async(execute: item)
                    }
                }

                else {
                    self.viewModel.selectedGoogleContacts = self.viewModel.googleContacts
                    //add all
                    DispatchQueue.mainAsync {
                        self.viewModel.addAll(for: .google)
                        self.hideSelectAllLoader()
                    }
                }

            }
        }
        sender.isSelected = !sender.isSelected
    }
    
    private func hideSelectAllLoader() {
        self.showLoaderOnView(view: self.selectAllButton, show: false)
    }
}

//MARK:- Table View Delegate and DataSource
//MARK:-
extension ContactListVC: UITableViewDelegate, UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        self.hideSelectAllLoader()
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
            return self.viewModel.sections[section].cnContacts.count
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactDetailsTableCell", for: indexPath) as! ContactDetailsTableCell
        return populateData(in: cell, indexPath: indexPath)

    }
    
    @discardableResult
    func populateData(in cell: ContactDetailsTableCell, indexPath: IndexPath) -> ContactDetailsTableCell {
        if self.currentlyUsingFor == .contacts {
            cell.contact = ATContact(contact: self.viewModel.sections[indexPath.section].cnContacts[indexPath.row])
            cell.selectionButton.isSelected = self.viewModel.selectedPhoneContacts.contains(where: { contact in
                contact.id == self.viewModel.sections[indexPath.section].cnContacts[indexPath.row].id
            })
            cell.dividerView.isHidden = indexPath.row == (self.viewModel.sections[indexPath.section].cnContacts.count - 1)
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
        AppGlobals.shared.startLoading()
        if self.currentlyUsingFor == .contacts {
            if let index = self.viewModel.selectedPhoneContacts.firstIndex(where: { (contact) -> Bool in
                contact.id == self.viewModel.sections[indexPath.section].cnContacts[indexPath.row].id
            }) {
                self.viewModel.selectedPhoneContacts.remove(at: index)
                self.selectAllButton.isSelected = false
                self.viewModel.remove(fromIndex: index, for: .contacts)
            }
            else {
                self.viewModel.selectedPhoneContacts.append(self.viewModel.sections[indexPath.section].cnContacts[indexPath.row])
                self.viewModel.add(for: .contacts)
                //self.selectAllButton.isSelected = self.viewModel.selectedPhoneContacts.count >= self.viewModel.sections.count
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
                // self.selectAllButton.isSelected = self.viewModel.selectedFacebookContacts.count >= self.viewModel.facebookSection.count
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
                // self.selectAllButton.isSelected = self.viewModel.selectedGoogleContacts.count >= self.viewModel.googleSection.count
            }
        }
        AppGlobals.shared.stopLoading()
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
    func firstButtonAction(sender: ATButton) {
        dismissKeyboard()
        if self.currentlyUsingFor == .contacts {
            sender.isLoading = true
            self.viewModel.fetchPhoneContacts(forVC: self) {
                sender.isLoading = false
            }
        }
        else if self.currentlyUsingFor == .facebook {
            sender.isLoading = true
            self.viewModel.fetchFacebookContacts(forVC: self) {
                sender.isLoading = false
            }
        }
        else if self.currentlyUsingFor == .google {
            sender.isLoading = true
            self.viewModel.fetchGoogleContacts(forVC: self) {
                sender.isLoading = false
            }
        }
    }
}

//MARK:- ViewModel Delegate
//MARK:-
extension ContactListVC: ImportContactVMDelegate {
    func remove(for usingFor: ContactListVC.UsingFor) {
//        self.reloadList()
         reloadVisibleCells()
    }
    
    func showLoader() {
    }
    
    func hideLoader() {
    }
    
    func add(for usingFor: ContactListVC.UsingFor) {
//        self.reloadList()
        reloadVisibleCells()
    }
    
    func remove(fromIndex: Int, for usingFor: ContactListVC.UsingFor) {
//        self.reloadList()
        reloadVisibleCells()
    }
    
    func addAll(for usingFor: ContactListVC.UsingFor) {
//        self.reloadList()
        reloadVisibleCells()
    }
    
    func removeAll(for usingFor: ContactListVC.UsingFor) {
//        self.reloadList()
        reloadVisibleCells()
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
                tableView?.backgroundView = allowEmptyView
            }
            else if self.viewModel.facebookContacts.isEmpty {
                tableView?.backgroundView = noResultemptyView
            }
            else {
                tableView?.backgroundView = nil
            }
            
        case .google:
            if !self.viewModel.isGoogleContactsAllowed {
                tableView?.backgroundView = allowEmptyView
            }
            else if self.viewModel.googleContacts.isEmpty {
                tableView?.backgroundView = noResultemptyView
            }
            else {
                tableView?.backgroundView = nil
            }
        }
        
        self.reloadList()
    }
}
/*
 {
     if sender.isSelected {
         printDebug("isSelected true")
         //remove all
         if !self.viewModel.selectedPhoneContacts.isEmpty  {
             workItem = DispatchWorkItem(block: {
                 printDebug("Operation Started At: \(Date().timeIntervalSince1970)")
                 self.viewModel.selectedPhoneContacts.removeAll { contact in
                     self.viewModel.sections.contains { section in
                         section.cnContacts.contains { $0 == contact }
                     }
                 }
             })
             workItem!.notify(queue: .main) {
                 DispatchQueue.mainAsync {
                     self.viewModel.remove(for: .contacts)
                     self.hideSelectAllLoader()
                     printDebug("Operation Completed At: \(Date().timeIntervalSince1970)")
                 }
             }
             selectDeselectQueue.async(execute: workItem!)
         } else {
             self.hideSelectAllLoader()
         }
         
     } else {
         printDebug("isSelected false")
         if !self.viewModel.selectedPhoneContacts.isEmpty  {
             workItem = DispatchWorkItem(block: {
                 printDebug("Operation Started At: \(Date().timeIntervalSince1970)")
                 let allContacts = self.viewModel.sections.reduce([]) { result, section in
                     result + section.cnContacts
                 }
                 let allContactsToAppend = allContacts.filter {
                     !self.viewModel.selectedPhoneContacts.contains($0)
                 }
                 self.viewModel.selectedPhoneContacts.append(contentsOf: allContactsToAppend)
             })
             
             workItem!.notify(queue: .main) {
                 DispatchQueue.mainAsync {
                     self.viewModel.add(for: .contacts)
                     self.hideSelectAllLoader()
                     printDebug("Operation Completed At: \(Date().timeIntervalSince1970)")
                 }
             }
             selectDeselectQueue.async(execute: workItem!)
             
             
         }else {
             self.viewModel.selectedPhoneContacts = self.viewModel.phoneContacts
             DispatchQueue.mainAsync {
                 self.viewModel.addAll(for: .contacts)
             }
             
         }
     }
 }
 */
