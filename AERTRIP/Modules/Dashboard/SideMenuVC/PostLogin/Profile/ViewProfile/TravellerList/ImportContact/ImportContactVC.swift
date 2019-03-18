//
//  ImportContactVC.swift
//  AERTRIP
//
//  Created by Admin on 09/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class ImportContactVC: BaseVC {
    
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
    
    //MARK:- Private
    private let collectionLayout: ContactListCollectionFlowLayout = ContactListCollectionFlowLayout()
    fileprivate weak var categoryView: ATCategoryView!
    private var itemsCounts: [Int] = [0, 0, 0]
    
    private(set) var viewModel = ImportContactVM.shared
    private var currentIndex: Int = 0 {
        didSet {
            self.updateNavTitle()
        }
    }
    
    private let allTabsStr: [String] = [LocalizedString.Contacts.localized, LocalizedString.Facebook.localized, LocalizedString.Google.localized]
    private var allTabs: [ATCategoryItem] {
        var temp = [ATCategoryItem]()
        
        for title in allTabsStr {
            var obj = ATCategoryItem()
            obj.title = title
            temp.append(obj)
        }
        
        return temp
    }

    private var allChildVCs: [ContactListVC] = [ContactListVC]()
    
    //MARK:- ViewLifeCycle
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.initialSetups()
    }

    override func bindViewModel() {
        self.viewModel.delegateCollection = self
    }
    
    override func dataChanged(_ note: Notification) {
        if let obj = note.object as? ImportContactVM.Notification {
            if obj == .phoneContactFetched {
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
        
        selectedContactsCollectionView.setCollectionViewLayout(self.collectionLayout, animated: false)

        self.topNavView.delegate = self
        self.topNavView.configureNavBar(title: LocalizedString.AllowContacts.localized, isLeftButton: true, isFirstRightButton: true, isSecondRightButton: false, isDivider: false)
        self.topNavView.configureLeftButton(normalImage: nil, selectedImage: nil, normalTitle: LocalizedString.Cancel.rawValue, selectedTitle: LocalizedString.Cancel.rawValue, normalColor: AppColors.themeGreen, selectedColor: AppColors.themeGreen)
        self.topNavView.configureFirstRightButton(normalImage: nil, selectedImage: nil, normalTitle: LocalizedString.Import.rawValue, selectedTitle: LocalizedString.Import.rawValue, normalColor: AppColors.themeGreen, selectedColor: AppColors.themeGreen, font: AppFonts.SemiBold.withSize(18.0))
        self.topNavView.firstRightButton.setTitleColor(AppColors.themeGreen, for: .normal)
        self.topNavView.firstRightButton.setTitleColor(AppColors.themeGreen, for: .selected)
        self.topNavView.firstRightButton.setTitleColor(AppColors.themeGray40, for: .disabled)
        
        self.viewModel.selectedPhoneContacts.removeAll()
        self.viewModel.selectedFacebookContacts.removeAll()
        self.viewModel.selectedGoogleContacts.removeAll()
        
        self.searchBar.delegate = self
        self.searchBar.placeholder = LocalizedString.search.localized
        
        self.selectedContactsCollectionView.dataSource = self
        self.selectedContactsCollectionView.delegate = self
        
        for idx in 0..<allTabsStr.count {
            let vc = ContactListVC.instantiate(fromAppStoryboard: .TravellerList)
            vc.currentlyUsingFor = ContactListVC.UsingFor(rawValue: idx) ?? .contacts
            self.allChildVCs.append(vc)
        }
        
        self.setupPagerView()
        delay(seconds: 0.2) {[weak self] in
            self?.updateNavTitle()
        }
        
        self.selectedContactsSetHidden(isHidden: true, animated: false)
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
    
    private func updateNavTitle() {
        
        if self.allChildVCs[self.currentIndex].isPermissionGiven, self.viewModel.totalSelectedContacts == 0 {
            self.topNavView.navTitleLabel.text = LocalizedString.SelectContactsToImport.localized
        }
        else if self.viewModel.totalSelectedContacts <= 0 {
            self.topNavView.firstRightButton.isEnabled = false
            switch self.currentIndex {
            case 0:
                //phone
                self.topNavView.navTitleLabel.text = LocalizedString.AllowContacts.localized
                
            case 1:
                //facebook
                self.topNavView.navTitleLabel.text = LocalizedString.ConnectWithFB.localized
                
            case 2:
                //google
                self.topNavView.navTitleLabel.text = LocalizedString.ConnectWithGoogle.localized
                
            default:
                self.topNavView.navTitleLabel.text = LocalizedString.AllowContacts.localized
            }
        }
        else {
            self.topNavView.firstRightButton.isEnabled = true
            self.topNavView.navTitleLabel.text = "\(self.viewModel.totalSelectedContacts) \(LocalizedString.ContactsSelected.localized)"
        }
    }
    
    //MARK:- Public
    
    
    //MARK:- Action
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func importButtonAction(_ sender: UIButton) {
        self.viewModel.saveContacts()
    }
}

extension ImportContactVC: ATCategoryNavBarDelegate {
    func categoryNavBar(_ navBar: ATCategoryNavBar, didSwitchIndexTo toIndex: Int) {
        self.currentIndex = toIndex
    }
}

extension ImportContactVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.viewModel.search(forText: searchText)
    }
}

extension ImportContactVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        self.cancelButtonAction(sender)
    }
    
    func topNavBarFirstRightButtonAction(_ sender: UIButton) {
        self.importButtonAction(sender)
    }
}

//MARK:- ViewModel Delegate
//MARK:-
extension ImportContactVC: ImportContactVMDelegate {
    
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
        delay(seconds: 0.2) { [weak self] in
            self?.updateNavTitle()
        }
        
        let currentlyUsingFor = ContactListVC.UsingFor(rawValue: self.currentIndex)
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
    
    func add(for usingFor: ContactListVC.UsingFor) {
        self.selectionDidChanged()
        var item = 0
        switch usingFor {
        case .contacts:
            item = self.viewModel.selectedPhoneContacts.count - 1
            
        case .facebook:
            item = self.viewModel.selectedFacebookContacts.count - 1
            
        case .google:
            item = self.viewModel.selectedGoogleContacts.count - 1
            
        default:
            item = 0
        }
        self.selectedContactsCollectionView.performBatchUpdates({
            self.selectedContactsCollectionView.insertItems(at: [IndexPath(item: item, section: usingFor.rawValue)])
            self.itemsCounts[usingFor.rawValue] += 1
        }, completion: { (isDone) in
                self.scrollCollectionToEnd()
        })
    }
    
    func remove(fromIndex: Int, for usingFor: ContactListVC.UsingFor) {
        
        self.selectedContactsCollectionView.performBatchUpdates({
            self.selectedContactsCollectionView.deleteItems(at: [IndexPath(item: fromIndex, section: usingFor.rawValue)])
            self.itemsCounts[usingFor.rawValue] -= 1
        }, completion: { (isDone) in
            self.selectionDidChanged()
        })
    }
    
    func addAll(for usingFor: ContactListVC.UsingFor) {
        self.selectionDidChanged()

        var item = 0
        switch usingFor {
        case .contacts:
            item = self.viewModel.selectedPhoneContacts.count

        case .facebook:
            item = self.viewModel.selectedFacebookContacts.count

        case .google:
            item = self.viewModel.selectedGoogleContacts.count
            
        default:
            item = 0
        }
        
        if self.itemsCounts[usingFor.rawValue] > 0 {
            for idx in 0..<self.itemsCounts[usingFor.rawValue] {
                self.remove(fromIndex: idx, for: usingFor)
            }
        }
        
        self.selectedContactsCollectionView.performBatchUpdates({
            for idx in 0..<item {
                self.selectedContactsCollectionView.insertItems(at: [IndexPath(item: idx, section: usingFor.rawValue)])
                self.itemsCounts[usingFor.rawValue] += 1
            }
        }, completion: nil)
    }
    
    func removeAll(for usingFor: ContactListVC.UsingFor) {
        
        var item = 0
        switch usingFor {
        case .contacts:
            item = self.viewModel.selectedPhoneContacts.count
            
        case .facebook:
            item = self.viewModel.selectedFacebookContacts.count
            
        case .google:
            item = self.viewModel.selectedGoogleContacts.count
            
        default:
            item = 0
        }
        
        self.selectedContactsCollectionView.performBatchUpdates({
            for idx in 1...item {
                self.selectedContactsCollectionView.deleteItems(at: [IndexPath(item: idx, section: usingFor.rawValue)])
                self.itemsCounts[usingFor.rawValue] -= 1
            }
        }, completion: { (isDone) in
            self.itemsCounts = [0, 0, 0]
            self.selectedContactsCollectionView.reloadData()
            self.selectionDidChanged()
        })
    }
    
    func selectionDidChanged() {
        self.updateNavTitle()
        self.selectedContactsSetHidden(isHidden: self.viewModel.totalSelectedContacts <= 0, animated: true)
    }
}

extension ImportContactVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.itemsCounts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.itemsCounts[section]
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectedContactCollectionCell", for: indexPath) as? SelectedContactCollectionCell else {
            fatalError("SelectedContactCollectionCell not found")
        }
        
        cell.delegate = self
        
        switch indexPath.section {
        case 0:
            //phone
            cell.contact = self.viewModel.selectedPhoneContacts[indexPath.item]

        case 1:
            //facebook
            cell.contact = self.viewModel.selectedFacebookContacts[indexPath.item]

        case 2:
            //google
            cell.contact = self.viewModel.selectedGoogleContacts[indexPath.item]

        default:
            cell.contact = nil
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

            return CGSize(width: UIDevice.screenWidth / 5.0, height: collectionView.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

extension ImportContactVC: SelectedContactCollectionCellDelegate {
    func crossButtonAction(_ sender: UIButton) {
        if let indexPath = self.selectedContactsCollectionView.indexPath(forItem: sender) {
            switch indexPath.section {
            case 0:
                //phone
                self.viewModel.selectedPhoneContacts.remove(at: indexPath.item)
                self.viewModel.remove(fromIndex: indexPath.item, for: .contacts)
                
            case 1:
                //facebook
                self.viewModel.selectedFacebookContacts.remove(at: indexPath.item)
                self.viewModel.remove(fromIndex: indexPath.item, for: .facebook)
                
            case 2:
                //google
                self.viewModel.selectedGoogleContacts.remove(at: indexPath.item)
                self.viewModel.remove(fromIndex: indexPath.item, for: .google)
                
            default:
                printDebug("not a correct index")
            }
        }
    }
}



//MARK:- Collection View Custom Flow Layout
//MARK:-
class ContactListCollectionFlowLayout : UICollectionViewFlowLayout {

    var insertingIndexPaths = [IndexPath]()

    override init() {
        super.init()

        self.initialSetup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.initialSetup()
    }

    private func initialSetup() {
        self.scrollDirection = .horizontal
    }

    override func prepare() {
        super.prepare()

    }

    override func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
        super.prepare(forCollectionViewUpdates: updateItems)

        insertingIndexPaths.removeAll()

        for update in updateItems {
            if let indexPath = update.indexPathAfterUpdate,
                update.updateAction == .insert {
                insertingIndexPaths.append(indexPath)
            }
        }
    }

    override func finalizeCollectionViewUpdates() {
        super.finalizeCollectionViewUpdates()

        insertingIndexPaths.removeAll()
    }

    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = super.initialLayoutAttributesForAppearingItem(at: itemIndexPath)

        attributes?.alpha = 0.0
        attributes?.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)

        return attributes
    }
}
