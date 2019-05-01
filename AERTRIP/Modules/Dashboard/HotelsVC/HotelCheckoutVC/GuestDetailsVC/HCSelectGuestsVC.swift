//
//  SelectGuestsVC.swift
//  AERTRIP
//
//  Created by Admin on 15/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol HCSelectGuestsVCDelegate: class {
    func didAddedContacts()
}

class HCSelectGuestsVC: BaseVC {
    
    //MARK:- IBOutlets
    //MARK:-
    
    @IBOutlet weak var topNavView: TopNavigationView!
    @IBOutlet weak var selectedContactsContainerView: UIView!
    @IBOutlet weak var selectedContactsContainerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchBar: ATSearchBar!
    @IBOutlet weak var listContainerView: UIView!
    @IBOutlet weak var selectedContactsCollectionView: UICollectionView!
    
    
    
    //MARK:- Properties
    //MARK:- Public
    weak var delegate: HCSelectGuestsVCDelegate?
    
    //MARK:- Private
    private let collectionLayout: ContactListCollectionFlowLayout = ContactListCollectionFlowLayout()
    fileprivate weak var categoryView: ATCategoryView!
    
    private(set) var viewModel = HCSelectGuestsVM.shared
    private var currentIndex: Int = 0 {
        didSet {
        }
    }
    
    private var allTabsStr: [HCGuestListVC.UsingFor] = []
    private var allTabs: [ATCategoryItem] {
        var temp = [ATCategoryItem]()
        
        for item in allTabsStr {
            var obj = ATCategoryItem()
            obj.title = item.title
            temp.append(obj)
        }
        
        return temp
    }
    
    private var allChildVCs: [HCGuestListVC] = [HCGuestListVC]()
    
    private var currentSelectedGuestIndex: IndexPath = IndexPath(item: 0, section: 0)
    
    private let oldGuestState = GuestDetailsVM.shared.guests
    
    //MARK:- ViewLifeCycle
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.initialSetups()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    override func bindViewModel() {
        self.viewModel.delegateCollection = self
    }
    
    override func dataChanged(_ note: Notification) {
        if let obj = note.object as? HCSelectGuestsVM.Notification {
            if obj == .contactFetched {
                self.fetchPhoneContactsSuccess()
            }
            else if obj == .contactSavedFail {
                self.contactSavedFail()
            }
            else if obj == .contactSavedSuccess {
                self.contactSavedSuccess()
            }
            else if obj == .phoneContactSavedFail {
                self.phoneContactSavedFail()
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.categoryView?.frame = self.listContainerView.bounds
        self.categoryView?.layoutIfNeeded()
    }
    
    deinit {
        printDebug("deinit")
    }
    
    //MARK:- Methods
    //MARK:- Private
    private func initialSetups() {
        self.viewModel.clearAllSelection()

        selectedContactsCollectionView.setCollectionViewLayout(self.collectionLayout, animated: false)
        
        self.topNavView.delegate = self
        self.topNavView.configureNavBar(title: LocalizedString.SelectGuests.localized, isLeftButton: true, isFirstRightButton: true, isSecondRightButton: false, isDivider: false)
        self.topNavView.configureLeftButton(normalImage: nil, selectedImage: nil, normalTitle: LocalizedString.Cancel.rawValue, selectedTitle: LocalizedString.Cancel.rawValue, normalColor: AppColors.themeGreen, selectedColor: AppColors.themeGreen)
        self.topNavView.configureFirstRightButton(normalImage: nil, selectedImage: nil, normalTitle: LocalizedString.Add.rawValue, selectedTitle: LocalizedString.Add.rawValue, normalColor: AppColors.themeGreen, selectedColor: AppColors.themeGreen, font: AppFonts.SemiBold.withSize(18.0))
        self.topNavView.firstRightButton.setTitleColor(AppColors.themeGreen, for: .normal)
        self.topNavView.firstRightButton.setTitleColor(AppColors.themeGreen, for: .selected)
        self.topNavView.firstRightButton.setTitleColor(AppColors.themeGray40, for: .disabled)
        
//        self.viewModel.selectedPhoneContacts.removeAll()
//        self.viewModel.selectedFacebookContacts.removeAll()
//        self.viewModel.selectedGoogleContacts.removeAll()
        
        self.searchBar.delegate = self
        self.searchBar.placeholder = LocalizedString.search.localized
        
        self.selectedContactsCollectionView.dataSource = self
        self.selectedContactsCollectionView.delegate = self
        
        self.selectedContactsCollectionView.register(UINib(nibName: "SectionHeader", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SectionHeader")
        
        if let _ = UserInfo.loggedInUserId {
            allTabsStr = [HCGuestListVC.UsingFor.travellers, HCGuestListVC.UsingFor.contacts, HCGuestListVC.UsingFor.facebook, HCGuestListVC.UsingFor.google]
        }
        else {
            allTabsStr = [HCGuestListVC.UsingFor.contacts, HCGuestListVC.UsingFor.facebook, HCGuestListVC.UsingFor.google]
        }
        
        for item in allTabsStr {
            let vc = HCGuestListVC.instantiate(fromAppStoryboard: .HotelCheckout)
            vc.currentlyUsingFor = item
            self.allChildVCs.append(vc)
        }
        
        self.setupPagerView()

        self.selectedContactsSetHidden(isHidden: false, animated: false)
    }
    
    
    private func setupPagerView() {
        
        var style = ATCategoryNavBarStyle()
        style.height = 45.0
        style.interItemSpace = 5.0
        style.itemPadding = 8.0
        style.isScrollable = false
        style.layoutAlignment = .center
        style.isEmbeddedToView = true
        style.showBottomSeparator = true
        style.bottomSeparatorColor = AppColors.themeGray40
        style.defaultFont = AppFonts.Regular.withSize(16.0)
        style.selectedFont = AppFonts.Regular.withSize(16.0)
        style.indicatorColor = AppColors.themeGreen
        style.normalColor = AppColors.themeBlack
        style.selectedColor = AppColors.themeBlack
        
        let categoryView = ATCategoryView(frame: self.listContainerView.bounds, categories: self.allTabs, childVCs: self.allChildVCs, parentVC: self, barStyle: style)
        categoryView.interControllerSpacing = 0.0
        categoryView.navBar.internalDelegate = self
        self.listContainerView.addSubview(categoryView)
        self.categoryView = categoryView
    }
    
    private func selectedContactsSetHidden(isHidden: Bool, animated: Bool) {
        UIView.animate(withDuration: animated ? AppConstants.kAnimationDuration : 0.0, animations: { [weak self] in
            self?.selectedContactsContainerHeightConstraint.constant = isHidden ? 0.0 : 100.0
            self?.view.layoutIfNeeded()
        }) { (isCompleted) in
        }
    }
    
    private func selectNextGuest() {
        //update the currentSelected IndexPath according to the data
        
        //increasing selection for next only
//        //setup item
//        let maxItemInCurrentSection = (GuestDetailsVM.shared.guests[currentSelectedGuestIndex.section].count - 1)
//        let newItem = (currentSelectedGuestIndex.item + 1)
//
//        //setup section
//        if (newItem > maxItemInCurrentSection) {
//            //increase section and make item 0
//            let maxSection = (GuestDetailsVM.shared.guests.count - 1)
//            if currentSelectedGuestIndex.section >= maxSection {
//                currentSelectedGuestIndex = IndexPath(item: maxItemInCurrentSection, section: maxSection)
//            }
//            else {
//                currentSelectedGuestIndex = IndexPath(item: 0, section: min((currentSelectedGuestIndex.section + 1), maxSection))
//            }
//        }
//        else {
//            //increase item in current section
//            currentSelectedGuestIndex = IndexPath(item: min(newItem, maxItemInCurrentSection), section: currentSelectedGuestIndex.section)
//        }
        
        
        //increasing next selection according to the selected data
        var idxPath: IndexPath?
        for (section, roomGuest) in GuestDetailsVM.shared.guests.enumerated() {
            for (item, guest) in roomGuest.enumerated() {
                if guest.firstName.isEmpty {
                    idxPath = IndexPath(item: item, section: section)
                    break
                }
            }
            if let idx = idxPath {
                currentSelectedGuestIndex = idx
                break
            }
        }
        
        selectedContactsCollectionView.reloadData()
    }
    
    //MARK:- Public
    
    
    //MARK:- Action
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        GuestDetailsVM.shared.guests = self.oldGuestState
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addButtonAction(_ sender: UIButton) {
        self.delegate?.didAddedContacts()
        self.dismiss(animated: true, completion: nil)
    }
}

extension HCSelectGuestsVC: ATCategoryNavBarDelegate {
    func categoryNavBar(_ navBar: ATCategoryNavBar, didSwitchIndexTo toIndex: Int) {
        self.currentIndex = toIndex
    }
}

extension HCSelectGuestsVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.viewModel.search(forText: searchText)
    }
}

extension HCSelectGuestsVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        self.cancelButtonAction(sender)
    }
    
    func topNavBarFirstRightButtonAction(_ sender: UIButton) {
        self.addButtonAction(sender)
    }
}

//MARK:- ViewModel Delegate
//MARK:-
extension HCSelectGuestsVC: HCSelectGuestsVMDelegate {
    
    func contactSavedFail() {
        AppToast.default.showToastMessage(message: "Not able to save contacts. Please try again.")
    }
    
    func contactSavedSuccess() {
        self.cancelButtonAction(self.topNavView.leftButton)
    }
    
    func phoneContactSavedFail() {
        AppToast.default.showToastMessage(message: "Not able to save contacts. Please try again.")
    }
    
    func willFetchPhoneContacts() {
        
    }
    
    func fetchPhoneContactsSuccess() {
        
        let currentlyUsingFor = HCGuestListVC.UsingFor(rawValue: self.currentIndex)
        if currentlyUsingFor == .contacts, self.viewModel.phoneContacts.isEmpty {
            AppToast.default.showToastMessage(message: "No contacts in this phone.")
        } else if currentlyUsingFor == .facebook, self.viewModel.facebookContacts.isEmpty {
            AppToast.default.showToastMessage(message: "No contacts in this facebook.")
        } else if currentlyUsingFor == .google, self.viewModel.googleContacts.isEmpty {
            AppToast.default.showToastMessage(message: "No contacts in this google.")
        }
    }
    
    private func scrollCollectionToEnd() {
        let newOffsetX = self.selectedContactsCollectionView.contentSize.width - self.selectedContactsCollectionView.width
        guard newOffsetX > 0 else {return}
        
        self.selectedContactsCollectionView.setContentOffset(CGPoint(x: newOffsetX, y: 0), animated: true)
    }
    
    func add(atIndex index: Int, for usingFor: HCGuestListVC.UsingFor) {
//        self.selectionDidChanged()
        var item = ATContact(json: [:])
        switch usingFor {
        case .travellers:
            item = self.viewModel._travellerContacts[index]

        case .contacts:
            item = self.viewModel._phoneContacts[index]

        case .facebook:
            item = self.viewModel._facebookContacts[index]

        case .google:
            item = self.viewModel._googleContacts[index]
        }
        
        item.passengerType = GuestDetailsVM.shared.guests[currentSelectedGuestIndex.section][currentSelectedGuestIndex.item].passengerType
        item.numberInRoom = GuestDetailsVM.shared.guests[currentSelectedGuestIndex.section][currentSelectedGuestIndex.item].numberInRoom
        item.age = GuestDetailsVM.shared.guests[currentSelectedGuestIndex.section][currentSelectedGuestIndex.item].age

        GuestDetailsVM.shared.guests[currentSelectedGuestIndex.section][currentSelectedGuestIndex.item] = item
        self.selectNextGuest()
    }
    
    func remove(atIndex index: Int, for usingFor: HCGuestListVC.UsingFor) {
//        GuestDetailsVM.shared.guests[indexPath.section][indexPath.item] = ATContact(json: [:])
        var indexPath: IndexPath?
        switch usingFor {
        case .travellers:
            indexPath = getCollectionIndexPath(forContact: self.viewModel._travellerContacts[index])
            
        case .contacts:
            indexPath = getCollectionIndexPath(forContact: self.viewModel._phoneContacts[index])

        case .facebook:
            indexPath = getCollectionIndexPath(forContact: self.viewModel._facebookContacts[index])

        case .google:
            indexPath = getCollectionIndexPath(forContact: self.viewModel._googleContacts[index])
        }
        
        if let idx = indexPath {
            removeContact(forIndexPath: idx)
            currentSelectedGuestIndex = idx
        }
        
        self.selectedContactsCollectionView.reloadData()
    }
    
    private func removeContact(forIndexPath indexPath: IndexPath) {
        GuestDetailsVM.shared.guests[indexPath.section][indexPath.item].salutation = ""
        GuestDetailsVM.shared.guests[indexPath.section][indexPath.item].firstName = ""
        GuestDetailsVM.shared.guests[indexPath.section][indexPath.item].lastName = ""
        GuestDetailsVM.shared.guests[indexPath.section][indexPath.item].profilePicture = ""
    }
    
    private func getCollectionIndexPath(forContact contact: ATContact) -> IndexPath? {
        var indexPath: IndexPath?
        for (section, roomGuest) in GuestDetailsVM.shared.guests.enumerated() {
            for (item, guest) in roomGuest.enumerated() {
                if guest.id == contact.id {
                    indexPath = IndexPath(item: item, section: section)
                    break
                }
            }
            if let _ = indexPath {
                break
            }
        }
        return indexPath
    }
}

//MARK:- CollectionView Delegate
//MARK:-
extension HCSelectGuestsVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return GuestDetailsVM.shared.guests.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.zero//CGSize(width: UIDevice.screenWidth / 5.0, height: 20.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionHeader, let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeader", for: indexPath) as? SectionHeader {
            
            header.sectionHeaderLabel.text = "\(LocalizedString.Room.localized) \(indexPath.section + 1)"
            
            return header
        }
        else {
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return GuestDetailsVM.shared.guests[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectedContactCollectionCell", for: indexPath) as? SelectedContactCollectionCell else {
            fatalError("SelectedContactCollectionCell not found")
        }
        
        cell.delegate = self
        
        cell.contact = nil
        
        cell.contact = GuestDetailsVM.shared.guests[indexPath.section][indexPath.item]
        cell.isUsingForGuest = true
        cell.isSelectedForGuest = false
        if (indexPath.section == currentSelectedGuestIndex.section) && (indexPath.item == currentSelectedGuestIndex.item){
            cell.isSelectedForGuest = true
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: UIDevice.screenWidth / 5.0, height: collectionView.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10.0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currentSelectedGuestIndex = indexPath
        collectionView.reloadData()
    }
}

extension HCSelectGuestsVC: SelectedContactCollectionCellDelegate {
    func crossButtonAction(_ sender: UIButton) {
        if let indexPath = self.selectedContactsCollectionView.indexPath(forItem: sender) {
            removeContact(forIndexPath: indexPath)
            let oldContact = GuestDetailsVM.shared.guests[indexPath.section][indexPath.item]
            switch oldContact.label {
            case .traveller:
                if let index = self.viewModel.selectedTravellerContacts.firstIndex(where: { (contact) -> Bool in
                    return oldContact.id == contact.id
                }) {
                    self.viewModel.selectedTravellerContacts.remove(at: index)
                }
                if let index = self.viewModel.travellerContacts.firstIndex(where: { (contact) -> Bool in
                    return oldContact.id == contact.id
                }) {
                    self.viewModel.remove(atIndex: index, for: .travellers)
                }
                
            case .phone:
                if let index = self.viewModel.selectedPhoneContacts.firstIndex(where: { (contact) -> Bool in
                    return oldContact.id == contact.id
                }) {
                    self.viewModel.selectedPhoneContacts.remove(at: index)
                }
                
                if let index = self.viewModel.phoneContacts.firstIndex(where: { (contact) -> Bool in
                    return oldContact.id == contact.id
                }) {
                    self.viewModel.remove(atIndex: index, for: .contacts)
                }
                
            case .facebook:
                if let index = self.viewModel.selectedFacebookContacts.firstIndex(where: { (contact) -> Bool in
                    return oldContact.id == contact.id
                }) {
                    self.viewModel.selectedFacebookContacts.remove(at: index)
                }
                if let index = self.viewModel.facebookContacts.firstIndex(where: { (contact) -> Bool in
                    return oldContact.id == contact.id
                }) {
                    self.viewModel.remove(atIndex: index, for: .facebook)
                }
                
            case .google:
                if let index = self.viewModel.selectedGoogleContacts.firstIndex(where: { (contact) -> Bool in
                    return oldContact.id == contact.id
                }) {
                    self.viewModel.selectedGoogleContacts.remove(at: index)
                }
                if let index = self.viewModel.googleContacts.firstIndex(where: { (contact) -> Bool in
                    return oldContact.id == contact.id
                }) {
                    self.viewModel.remove(atIndex: index, for: .google)
                }
            }
        }
    }
}

