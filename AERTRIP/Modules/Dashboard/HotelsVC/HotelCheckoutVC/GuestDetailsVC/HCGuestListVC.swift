//
//  HCGuestListVC.swift
//  AERTRIP
//
//  Created by Admin on 15/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit
import Contacts
import FBSDKCoreKit

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
    @IBOutlet weak var apiProgressBar: UIProgressView!
    
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
    
    lazy var noResultemptyView: EmptyScreenView = {
        let newEmptyView = EmptyScreenView()
        newEmptyView.vType = .noResult
        return newEmptyView
    }()
    
    private var atButton : ATButton?
    
    //MARK:- ViewLifeCycle
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.apiProgressBar.progressTintColor = UIColor.AertripColor
        self.apiProgressBar.trackTintColor = .clear
        self.apiProgressBar.progress = 0.0
        self.initialSetups()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let atButton = self.atButton {
            atButton.isLoading = false
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //self.containerBottomConstraint.constant = AppFlowManager.default.safeAreaInsets.bottom
        
        if !self.viewModel.searchText.isEmpty {
            self.noResultemptyView.messageLabel.text = "\(LocalizedString.noResults.localized + " " + LocalizedString.For.localized) '\(self.viewModel.searchText)'"
        }
        self.noResultemptyView.layoutSubviews()
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
    
    func showProgressView(){
        self.apiProgressBar.isHidden = false
        UIView.animate(withDuration: 2) {[weak self] in
            guard let self = self else {return}
            self.apiProgressBar.setProgress(0.25, animated: true)
        }
    }
    
    func animateProgressBar(){
        self.apiProgressBar.setProgress(1.0, animated: true)
        delay(seconds: 1){
            self.apiProgressBar.isHidden = true
        }
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
                //                delay(seconds: 0.3) { [weak self] in
                //                    guard let `self` = self else {
                //                        return
                //                    }
                self.noResultemptyView.messageLabel.isHidden = false
                self.noResultemptyView.messageLabel.text = "\(LocalizedString.noResults.localized + " " + LocalizedString.For.localized) '\(self.viewModel.searchText)'"
                self.noResultemptyView.messageLabel.numberOfLines = 0
                //self.noResultemptyView.messageLabelTopConstraint.constant = 30
                if self.currentlyUsingFor == .travellers && self.viewModel.travellerContacts.isEmpty {
                    self.tableView?.backgroundView = self.noResultemptyView
                }
                else if self.currentlyUsingFor == .contacts && self.viewModel.phoneContacts.isEmpty {
                    self.tableView?.backgroundView = self.noResultemptyView
                    
                }
                else if self.currentlyUsingFor == .facebook && self.viewModel.facebookContacts.isEmpty {
                    self.tableView?.backgroundView = self.noResultemptyView
                    
                }
                else if self.currentlyUsingFor == .google && self.viewModel.googleContacts.isEmpty {
                    self.tableView?.backgroundView = self.noResultemptyView
                }
                self.reloadList()
                //                }
                
                
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
        self.tableView.registerCell(nibName: EmptyTableViewCell.reusableIdentifier)
        delay(seconds: 0.3) { [weak self] in
            guard let `self` = self else {
                return
            }
            self.noResultemptyView.messageLabel.text = ""
            //self.noResultemptyView.messageLabelTopConstraint.constant = 30
        }
        
//        self.tableView.backgroundView = self.allowEmptyView
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = AppColors.themeGray04
        //noResultemptyView.mainImageViewTopConstraint.constant = 200
        
//        if self.currentlyUsingFor == .contacts {
//            if self.viewModel.phoneContacts.isEmpty, CNContactStore.authorizationStatus(for: .contacts) == .authorized {
//                self.viewModel.fetchPhoneContacts(forVC: self)
//            }
//        }
        if self.currentlyUsingFor == .contacts {
            if self.viewModel.phoneContacts.isEmpty {
                if CNContactStore.authorizationStatus(for: .contacts) == .authorized {
                    delay(seconds: 0.4) { [weak self] in
                        guard let strongSelf = self else {return}
                        strongSelf.viewModel.fetchPhoneContacts(forVC: strongSelf)
                    }
                } else {
                    self.tableView.backgroundView = self.allowEmptyView
                }
            } else {
                tableView.backgroundView = nil
            }
        }else if self.currentlyUsingFor == .facebook {
            if self.viewModel.facebookContacts.isEmpty {
                if AccessToken.isCurrentAccessTokenActive {
                    self.showProgressView()
                    delay(seconds: 0.4) { [weak self] in
                        guard let strongSelf = self else {return}
                        strongSelf.viewModel.fetchFacebookContacts(forVC: strongSelf)
                    }
                } else {
                    self.tableView.backgroundView = self.allowEmptyView
                }
            } else {
                tableView.backgroundView = nil
            }
        } else {
            self.tableView.backgroundView = self.allowEmptyView
        }
        self.tableView.showsVerticalScrollIndicator = true
    }
    
    private func reloadList() {
        self.tableView?.reloadData()
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
            return (self.viewModel.travellerContacts.count != 0) ? self.viewModel.travellerContacts.count + 1: 0
        }
        else if self.currentlyUsingFor == .contacts {
            
            tableView.backgroundView?.isHidden = !self.viewModel.phoneContacts.isEmpty
            return (self.viewModel.phoneContacts.count != 0) ? self.viewModel.phoneContacts.count + 1 : 0
        }
        else if self.currentlyUsingFor == .facebook {
            tableView.backgroundView?.isHidden = !self.viewModel.facebookContacts.isEmpty
            return (self.viewModel.facebookContacts.count != 0) ? self.viewModel.facebookContacts.count + 1 : 0
        }
        else if self.currentlyUsingFor == .google {
            tableView.backgroundView?.isHidden = !self.viewModel.googleContacts.isEmpty
            return (self.viewModel.googleContacts.count != 0) ? self.viewModel.googleContacts.count + 1 : 0
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch self.currentlyUsingFor {
        case .travellers: return (self.viewModel.travellerContacts.count != indexPath.row) ? 50.0 : 35.0
        case .contacts: return (self.viewModel.phoneContacts.count != indexPath.row) ? 50.0 : 35.0
        case .facebook: return (self.viewModel.facebookContacts.count != indexPath.row) ? 50.0 : 35.0
        case .google: return (self.viewModel.googleContacts.count != indexPath.row) ? 50.0 : 35.0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let emptyCell = self.tableView.dequeueReusableCell(withIdentifier: EmptyTableViewCell.reusableIdentifier) as? EmptyTableViewCell ?? EmptyTableViewCell()
        emptyCell.backgroundColor = AppColors.themeGray04
        emptyCell.bottomDividerView.isHidden = true
        switch self.currentlyUsingFor {
        case .travellers: return (self.viewModel.travellerContacts.count != indexPath.row) ? returnCellForContact(with: indexPath) : emptyCell
        case .contacts: return (self.viewModel.phoneContacts.count != indexPath.row) ? returnCellForContact(with: indexPath) : emptyCell
        case .facebook: return (self.viewModel.facebookContacts.count != indexPath.row) ? returnCellForContact(with: indexPath) : emptyCell
        case .google: return (self.viewModel.googleContacts.count != indexPath.row) ? returnCellForContact(with: indexPath) : emptyCell
        }
        
    }
    
    
    func returnCellForContact(with indexPath: IndexPath)-> UITableViewCell{
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ContactDetailsTableCell") as? ContactDetailsTableCell else {
            return UITableViewCell()
        }
        
        
        switch self.currentlyUsingFor {
        case .travellers:
            cell.showSalutationImage = true
            cell.contact = self.viewModel.travellerContacts[indexPath.row]
            
            // Get age str based on date of birth
            //            let dateStr = AppGlobals.shared.getAgeLastString(dob: self.viewModel.travellerContacts[indexPath.row].dob, formatter: "yyyy-MM-dd")
            //            // get attributed date str
            //            let attributedDateStr = AppGlobals.shared.getAttributedBoldText(text: dateStr, boldText: dateStr,color: AppColors.themeGray40)
            //
            //            // add a UILabel for Age string
            //            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 45, height: 30))
            //            label.attributedText = attributedDateStr
            //            cell.accessoryView = label
            cell.dividerView.isHidden = indexPath.row == (self.viewModel.travellerContacts.count - 1)
            cell.selectionButton.isSelected = self.viewModel.selectedTravellerContacts.contains(where: { (contact) -> Bool in
                contact.id == self.viewModel.travellerContacts[indexPath.row].id
            })
        case .contacts:
            cell.contact = self.viewModel.phoneContacts[indexPath.row]
            cell.dividerView.isHidden = indexPath.row == (self.viewModel.phoneContacts.count - 1)
            cell.selectionButton.isSelected = self.viewModel.selectedPhoneContacts.contains(where: { (contact) -> Bool in
                contact.id == self.viewModel.phoneContacts[indexPath.row].id
            })
        case .facebook:
            cell.contact = self.viewModel.facebookContacts[indexPath.row]
            cell.dividerView.isHidden = indexPath.row == (self.viewModel.facebookContacts.count - 1)
            cell.selectionButton.isSelected = self.viewModel.selectedFacebookContacts.contains(where: { (contact) -> Bool in
                contact.id == self.viewModel.facebookContacts[indexPath.row].id
            })
        case .google:
            cell.contact = self.viewModel.googleContacts[indexPath.row]
            cell.dividerView.isHidden = indexPath.row == (self.viewModel.googleContacts.count - 1)
            cell.selectionButton.isSelected = self.viewModel.selectedGoogleContacts.contains(where: { (contact) -> Bool in
                contact.id == self.viewModel.googleContacts[indexPath.row].id
            })
        }
        
//        if self.currentlyUsingFor == .travellers {
//            cell.showSalutationImage = true
//            cell.contact = self.viewModel.travellerContacts[indexPath.row]
//
//            // Get age str based on date of birth
//            //            let dateStr = AppGlobals.shared.getAgeLastString(dob: self.viewModel.travellerContacts[indexPath.row].dob, formatter: "yyyy-MM-dd")
//            //            // get attributed date str
//            //            let attributedDateStr = AppGlobals.shared.getAttributedBoldText(text: dateStr, boldText: dateStr,color: AppColors.themeGray40)
//            //
//            //            // add a UILabel for Age string
//            //            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 45, height: 30))
//            //            label.attributedText = attributedDateStr
//            //            cell.accessoryView = label
//            cell.dividerView.isHidden = indexPath.row == (self.viewModel.travellerContacts.count - 1)
//            cell.selectionButton.isSelected = self.viewModel.selectedTravellerContacts.contains(where: { (contact) -> Bool in
//                contact.id == self.viewModel.travellerContacts[indexPath.row].id
//            })
//        }
//        else if self.currentlyUsingFor == .contacts {
//            cell.contact = self.viewModel.phoneContacts[indexPath.row]
//            cell.dividerView.isHidden = indexPath.row == (self.viewModel.phoneContacts.count - 1)
//            cell.selectionButton.isSelected = self.viewModel.selectedPhoneContacts.contains(where: { (contact) -> Bool in
//                contact.id == self.viewModel.phoneContacts[indexPath.row].id
//            })
//        }
//        else if self.currentlyUsingFor == .facebook {
//            cell.contact = self.viewModel.facebookContacts[indexPath.row]
//            cell.dividerView.isHidden = indexPath.row == (self.viewModel.facebookContacts.count - 1)
//            cell.selectionButton.isSelected = self.viewModel.selectedFacebookContacts.contains(where: { (contact) -> Bool in
//                contact.id == self.viewModel.facebookContacts[indexPath.row].id
//            })
//        }
//        else if self.currentlyUsingFor == .google {
//            cell.contact = self.viewModel.googleContacts[indexPath.row]
//            cell.dividerView.isHidden = indexPath.row == (self.viewModel.googleContacts.count - 1)
//            cell.selectionButton.isSelected = self.viewModel.selectedGoogleContacts.contains(where: { (contact) -> Bool in
//                contact.id == self.viewModel.googleContacts[indexPath.row].id
//            })
//        }
        
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.currentlyUsingFor == .travellers {
            guard self.viewModel.travellerContacts.count > indexPath.row else {return}
            if let oIndex = self.viewModel.originalIndex(forContact: self.viewModel.travellerContacts[indexPath.row], forType: .travellers) {
                
                if let index = self.viewModel.selectedTravellerContacts.firstIndex(where: { (contact) -> Bool in
                    contact.id == self.viewModel.travellerContacts[indexPath.row].id
                }) {
                    self.viewModel.selectedTravellerContacts.remove(at: index)
                    self.viewModel.remove(atIndex: indexPath.row, for: .travellers)
                }
                else if self.viewModel.totalGuestCount > self.viewModel.allSelectedCount {
                    self.viewModel.selectedTravellerContacts.append(self.viewModel.travellerContacts[indexPath.row])
                    self.viewModel.add(atIndex: oIndex, for: .travellers)
                } else {
                    self.viewModel.selectedTravellerContacts.append(self.viewModel.travellerContacts[indexPath.row])
                    self.viewModel.update(atIndex: oIndex, for: .travellers)
                }
            }
        }
        else if self.currentlyUsingFor == .contacts {
            guard self.viewModel.phoneContacts.count > indexPath.row else {return}
            if let index = self.viewModel.selectedPhoneContacts.firstIndex(where: { (contact) -> Bool in
                contact.id == self.viewModel.phoneContacts[indexPath.row].id
            }) {
                self.viewModel.selectedPhoneContacts.remove(at: index)
                self.viewModel.remove(atIndex: indexPath.row, for: .contacts)
            }
            else {
                
                let newContact = self.viewModel.phoneContacts[indexPath.row]
                
                if let index = self.viewModel._phoneContacts.firstIndex(where: { (contact) -> Bool in
                    contact.id == newContact.id
                }) {
                    if HotelsSearchVM.hotelFormData.totalGuestCount > self.viewModel.allSelectedCount {
                        self.viewModel.selectedPhoneContacts.append(newContact)
                        //get the original index of the contact
                        self.viewModel.add(atIndex: index, for: .contacts)
                    } else {
                        self.viewModel.selectedPhoneContacts.append(self.viewModel.phoneContacts[indexPath.row])
                        self.viewModel.update(atIndex: index, for: .contacts)
                    }
                }
            }
        }
        else if self.currentlyUsingFor == .facebook {
             guard self.viewModel.facebookContacts.count > indexPath.row else {return}
            if let index = self.viewModel.selectedFacebookContacts.firstIndex(where: { (contact) -> Bool in
                contact.id == self.viewModel.facebookContacts[indexPath.row].id
            }) {
                self.viewModel.selectedFacebookContacts.remove(at: index)
                self.viewModel.remove(atIndex: indexPath.row, for: .facebook)
            }
            else {
                
                let newContact = self.viewModel.facebookContacts[indexPath.row]
                if let index = self.viewModel._facebookContacts.firstIndex(where: { (contact) -> Bool in
                    contact.id == newContact.id
                }) {
                    if  HotelsSearchVM.hotelFormData.totalGuestCount > self.viewModel.allSelectedCount {
                        self.viewModel.selectedFacebookContacts.append(newContact)
                        //get the original index of the contact
                        self.viewModel.add(atIndex: index, for: .facebook)
                        
                    }else {
                        self.viewModel.selectedFacebookContacts.append(self.viewModel.facebookContacts[indexPath.row])
                        self.viewModel.update(atIndex: index, for: .facebook)
                    }
                }
            }
        }
        else if self.currentlyUsingFor == .google {
             guard self.viewModel.googleContacts.count > indexPath.row else {return}
            if let index = self.viewModel.selectedGoogleContacts.firstIndex(where: { (contact) -> Bool in
                contact.id == self.viewModel.googleContacts[indexPath.row].id
            }) {
                self.viewModel.selectedGoogleContacts.remove(at: index)
                self.viewModel.remove(atIndex: indexPath.row, for: .google)
            }
            else {
                
                let newContact = self.viewModel.googleContacts[indexPath.row]
                if let index = self.viewModel._googleContacts.firstIndex(where: { (contact) -> Bool in
                    contact.id == newContact.id
                }) {
                    
                    if HotelsSearchVM.hotelFormData.totalGuestCount > self.viewModel.allSelectedCount {
                        self.viewModel.selectedGoogleContacts.append(newContact)
                        //get the original index of the contact
                        self.viewModel.add(atIndex: index, for: .google)
                    } else {
                        self.viewModel.selectedGoogleContacts.append(self.viewModel.googleContacts[indexPath.row])
                        self.viewModel.update(atIndex: index, for: .google)
                    }
                }
            }
        }
    }
}

//MARK:- ViewModel Delegate
//MARK:-
extension HCGuestListVC: EmptyScreenViewDelegate {
    func firstButtonAction(sender: ATButton) {
        atButton = sender
        if self.currentlyUsingFor == .travellers {
            self.viewModel.fetchTravellersContact()
        }
        else if self.currentlyUsingFor == .contacts {
            sender.isLoading = true
            delay(seconds: 0.1) { [weak self] in
                guard let `self` = self else {return}
                self.viewModel.fetchPhoneContacts(forVC: self, sender: sender, cancled: {
                    sender.isLoading = false
                })
            }
        }
        else if self.currentlyUsingFor == .facebook {
            sender.isLoading = true
            self.viewModel.fetchFacebookContacts(forVC: self,sender: sender)
        }
        else if self.currentlyUsingFor == .google {
            sender.isLoading = true
            self.viewModel.fetchGoogleContacts(forVC: self, sender: sender)
        }
    }
}

//MARK:- ViewModel Delegate
//MARK:-
extension HCGuestListVC: HCSelectGuestsVMDelegate {
    func update(atIndex index: Int, for usingFor: HCGuestListVC.UsingFor) {
        self.reloadList()
    }
    
    
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
                tableView?.backgroundView = noResultemptyView
            }
            else {
                tableView?.backgroundView = nil
            }
            
        case .contacts:
            if !self.viewModel.isPhoneContactsAllowed {
                tableView?.backgroundView = allowEmptyView
            }
            else if self.viewModel.phoneContacts.isEmpty {
                tableView?.backgroundView = noResultemptyView
            }
            else {
                tableView?.backgroundView = nil
            }
            
        case .facebook:
            self.animateProgressBar()
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
