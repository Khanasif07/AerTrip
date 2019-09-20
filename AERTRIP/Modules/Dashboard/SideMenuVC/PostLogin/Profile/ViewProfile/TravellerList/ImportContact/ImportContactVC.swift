//
//  ImportContactVC.swift
//  AERTRIP
//
//  Created by Admin on 09/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit
import PKCategoryView

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
    fileprivate weak var categoryView: PKCategoryView!
    private var itemsCounts: [Int] = [0, 0, 0]
    
    private(set) var viewModel = ImportContactVM.shared
    private var currentIndex: Int = 0 {
        didSet {
            self.updateNavTitle()
        }
    }
    
    private let allTabsStr: [String] = [LocalizedString.Contacts.localized, LocalizedString.Facebook.localized, LocalizedString.Google.localized]
    private var allTabs: [PKCategoryItem] {
        var temp = [PKCategoryItem]()
        
        for title in allTabsStr {
            let obj = PKCategoryItem(title: title, normalImage: nil, selectedImage: nil)
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
        self.categoryView?.layoutSubviews()
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
        
        delay(seconds: 0.1) {[weak self] in
            self?.setupPagerView()
            self?.updateNavTitle()
        }
        
        self.selectedContactsSetHidden(isHidden: true, animated: false)
    }
    
    
    private func setupPagerView() {

        var style = PKCategoryViewConfiguration()
        style.navBarHeight = 45.0
        style.interItemSpace = 5.0
        style.itemPadding = 8.0
        style.isNavBarScrollEnabled = false
        style.isEmbeddedToView = true
        style.showBottomSeparator = true
        style.bottomSeparatorColor = AppColors.divider.color
        style.defaultFont = AppFonts.Regular.withSize(16.0)
        style.selectedFont = AppFonts.SemiBold.withSize(16.0)
        style.indicatorColor = AppColors.themeGreen
        style.normalColor = AppColors.themeBlack
        style.selectedColor = AppColors.themeBlack
        
        let categoryView = PKCategoryView(frame: self.listContainerView.bounds, categories: self.allTabs, childVCs: self.allChildVCs, configuration: style, parentVC: self)
        categoryView.delegate = self
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
        
        if self.viewModel.totalSelectedContacts <= 0 {
            self.topNavView.firstRightButton.isEnabled = false
            switch self.currentIndex {
            case 0:
                //phone
                self.topNavView.navTitleLabel.text = self.viewModel.sections.isEmpty ? LocalizedString.AllowContacts.localized : LocalizedString.SelectContactsToImport.localized
                
            case 1:
                //facebook
                self.topNavView.navTitleLabel.text = self.viewModel.facebookSection.isEmpty ? LocalizedString.ConnectWithFB.localized : LocalizedString.SelectContactsToImport.localized
                
            case 2:
                //google
                self.topNavView.navTitleLabel.text = self.viewModel.facebookSection.isEmpty ? LocalizedString.ConnectWithGoogle.localized : LocalizedString.SelectContactsToImport.localized
                
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
        self.viewModel.search(forText: "")
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func importButtonAction(_ sender: UIButton) {
        self.viewModel.saveContacts()
    }
}

extension ImportContactVC: PKCategoryViewDelegate {
    func categoryView(_ view: PKCategoryView, willSwitchIndexFrom fromIndex: Int, to toIndex: Int) {
    }
    
    func categoryView(_ view: PKCategoryView, didSwitchIndexTo toIndex: Int) {
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
        AppToast.default.showToastMessage(message: LocalizedString.NotAbleToSaveContactTryAgain.localized)
    }
    
    func contactSavedSuccess() {
        self.cancelButtonAction(self.topNavView.leftButton)
    }
    
    func phoneContactSavedFail() {
        AppToast.default.showToastMessage(message: LocalizedString.NotAbleToSaveContactTryAgain.localized)
    }
    
    func willFetchPhoneContacts() {
        
    }
    
    func fetchPhoneContactsSuccess() {
        delay(seconds: 0.2) { [weak self] in
            self?.updateNavTitle()
        }
        
        let currentlyUsingFor = ContactListVC.UsingFor(rawValue: self.currentIndex)
        if currentlyUsingFor == .contacts, self.viewModel.phoneContacts.isEmpty {
            AppToast.default.showToastMessage(message: LocalizedString.NoContactFoundInDevice.localized)
        } else if currentlyUsingFor == .facebook, self.viewModel.facebookContacts.isEmpty {
            AppToast.default.showToastMessage(message: LocalizedString.NoContactFoundInFB.localized)
        } else if currentlyUsingFor == .google, self.viewModel.googleContacts.isEmpty {
            AppToast.default.showToastMessage(message: LocalizedString.NoContactFoundInGoogle.localized)
        }
        
        //applying the search on the new fetched data, if any
        if let text = self.searchBar.text, !text.isEmpty {
            self.viewModel.search(forText: text)
        }
    }
    
    private func scrollCollectionToEnd() {
        let newOffsetX = self.selectedContactsCollectionView.contentSize.width - self.selectedContactsCollectionView.width
        guard newOffsetX > 0 else {return}
        
        //self.selectedContactsCollectionView.setContentOffset(CGPoint(x: newOffsetX, y: 0), animated: true)
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
    
        }
        
        self.selectedContactsCollectionView.performBatchUpdates({
            for idx in 0..<item {
                self.selectedContactsCollectionView.deleteItems(at: [IndexPath(item: idx, section: usingFor.rawValue)])
                self.itemsCounts[usingFor.rawValue] -= 1
            }
        }, completion: { (isDone) in
            self.itemsCounts[usingFor.rawValue] = 0
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
            cell.contact = ATContact(contact: self.viewModel.selectedPhoneContacts[indexPath.item])

        case 1:
            //facebook
            cell.contact = self.viewModel.selectedFacebookContacts[indexPath.item]

        case 2:
            //google
            cell.contact = self.viewModel.selectedGoogleContacts[indexPath.item]

        default:
            cell.contact = nil
        }
        cell.isUsingForGuest = false
        
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
class ContactListCollectionFlowLayout: UICollectionViewFlowLayout {

    var insertingIndexPaths = [IndexPath]()
    var deletingIndexPaths = [IndexPath]()

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
        deletingIndexPaths.removeAll()

        for update in updateItems {
            if update.updateAction == .insert, let indexPath = update.indexPathAfterUpdate {
                insertingIndexPaths.append(indexPath)
            }
            else if update.updateAction == .delete, let indexPath = update.indexPathBeforeUpdate {
                deletingIndexPaths.append(indexPath)
            }
        }
    }

    override func finalizeCollectionViewUpdates() {
        super.finalizeCollectionViewUpdates()

        insertingIndexPaths.removeAll()
        deletingIndexPaths.removeAll()
    }
    
    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = super.initialLayoutAttributesForAppearingItem(at: itemIndexPath)
        
        if insertingIndexPaths.contains(itemIndexPath) {
            attributes?.alpha = 0.0
            attributes?.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        }
        
        return attributes
    }
    
    override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = super.finalLayoutAttributesForDisappearingItem(at: itemIndexPath)
        
        if deletingIndexPaths.contains(itemIndexPath) {
            attributes?.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            attributes?.alpha = 0.0
        }
        
        return attributes
    }
}
