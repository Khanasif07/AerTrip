//
//  ImportContactVC.swift
//  AERTRIP
//
//  Created by Admin on 09/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit
import Parchment


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
  
    private var itemsCounts: [Int] = [0, 0, 0]
    
// Parchment View
       fileprivate var parchmentView : PagingViewController<PagingIndexItem>?
    
    private(set) var viewModel = ImportContactVM.shared
    private var currentIndex: Int = 0 {
        didSet {
            self.updateNavTitle()
        }
    }
    
    private let allTabsStr: [String] = [LocalizedString.Contacts.localized, LocalizedString.Facebook.localized, LocalizedString.Google.localized]


    var allChildVCs: [ContactListVC] = [ContactListVC]()
    
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
        printDebug("viewDidLayoutSubviews")
        self.parchmentView?.view.frame = self.listContainerView.bounds
        self.parchmentView?.loadViewIfNeeded()
    }
    
    deinit {
        printDebug("deinit")
    }
    
    //MARK:- Methods
    //MARK:- Private
    private func initialSetups() {
        
        selectedContactsCollectionView.setCollectionViewLayout(self.collectionLayout, animated: false)

        self.topNavView.delegate = self
        self.topNavView.configureNavBar(title: LocalizedString.AllowContacts.localized, isLeftButton: true, isFirstRightButton: true, isSecondRightButton: false, isDivider: false,backgroundType: .color(color: AppColors.themeWhite))
        self.topNavView.configureLeftButton(normalImage: nil, selectedImage: nil, normalTitle: LocalizedString.Cancel.rawValue, selectedTitle: LocalizedString.Cancel.rawValue, normalColor: AppColors.themeGreen, selectedColor: AppColors.themeGreen)
        self.topNavView.configureFirstRightButton(normalImage: nil, selectedImage: nil, normalTitle: LocalizedString.Import.rawValue, selectedTitle: LocalizedString.Import.rawValue, normalColor: AppColors.themeGreen, selectedColor: AppColors.themeGreen, font: AppFonts.SemiBold.withSize(18.0))
        self.topNavView.firstRightButton.setTitleColor(AppColors.themeGreen, for: .normal)
        self.topNavView.firstRightButton.setTitleColor(AppColors.themeGreen, for: .selected)
        self.topNavView.firstRightButton.setTitleColor(AppColors.themeGray20, for: .disabled)
        
        self.viewModel.selectedPhoneContacts.removeAll()
        self.viewModel.selectedFacebookContacts.removeAll()
        self.viewModel.selectedGoogleContacts.removeAll()
        
        self.searchBar.delegate = self
        self.searchBar.placeholder = LocalizedString.search.localized
        
        self.selectedContactsCollectionView.dataSource = self
        self.selectedContactsCollectionView.delegate = self
        
        delay(seconds: 0.1) {[weak self] in
            //self?.setupPagerView()
            guard let self = self else  {return}
            self.setUpViewPager()
            self.updateNavTitle()
        }
        
        self.selectedContactsSetHidden(isHidden: true, animated: false)
        self.selectedContactsCollectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
    }
    
    private func setUpViewPager() {
        self.currentIndex = 0
        self.allChildVCs.removeAll()
        for idx in 0..<allTabsStr.count {
            let vc = ContactListVC.instantiate(fromAppStoryboard: .TravellerList)
            vc.currentlyUsingFor = ContactListVC.UsingFor(rawValue: idx) ?? .contacts
            self.allChildVCs.append(vc)
        }
        self.view.layoutIfNeeded()
        if let _ = self.parchmentView{
            self.parchmentView?.view.removeFromSuperview()
            self.parchmentView = nil
        }
        setupParchmentPageController()
    }
    
    // Added to replace the existing page controller, added Hitesh Soni, 28-29Jan'2020
    private func setupParchmentPageController(){
        
        self.parchmentView = PagingViewController<PagingIndexItem>()
        self.parchmentView?.menuItemSpacing = 60.0
        self.parchmentView?.menuInsets = UIEdgeInsets(top: 0.0, left: 33.0, bottom: 0.0, right: 33.0)
        self.parchmentView?.menuItemSize = .sizeToFit(minWidth: 150, height: 51)
        self.parchmentView?.indicatorOptions = PagingIndicatorOptions.visible(height: 2, zIndex: Int.max, spacing: UIEdgeInsets.zero, insets: UIEdgeInsets(top: 0, left: 0.0, bottom: 0, right: 0.0))
        self.parchmentView?.borderOptions = PagingBorderOptions.visible(
            height: 0.5,
            zIndex: Int.max - 1,
            insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        self.parchmentView?.borderColor = AppColors.themeBlack.withAlphaComponent(0.16)
        self.parchmentView?.font = AppFonts.Regular.withSize(16.0)
        self.parchmentView?.selectedFont = AppFonts.SemiBold.withSize(16.0)
        self.parchmentView?.indicatorColor = AppColors.themeGreen
        self.parchmentView?.selectedTextColor = AppColors.themeBlack
        self.listContainerView.addSubview(self.parchmentView!.view)
        
        self.parchmentView?.dataSource = self
        self.parchmentView?.delegate = self
        self.parchmentView?.select(index: 0)
        
        self.parchmentView?.reloadData()
        self.parchmentView?.reloadMenu()
    }
    
    private func selectedContactsSetHidden(isHidden: Bool, animated: Bool) {
        let value: CGFloat = self.selectedContactsContainerHeightConstraint.constant
        let newValue: CGFloat = isHidden ? 0.0 : 100.0
        if newValue == value {
            return
        }
        UIView.animate(withDuration: animated ? AppConstants.kAnimationDuration : 0.0, animations: { [weak self] in
            guard let selff = self else { return }
            selff.selectedContactsContainerHeightConstraint.constant = newValue
            selff.selectedContactsCollectionView.layoutIfNeeded()
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
   
    func showLoader() {
        AppGlobals.shared.startLoading(loaderBgColor: AppColors.clear)
    }
    
    func hideLoader() {
        AppGlobals.shared.stopLoading()
    }
    
    
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
        
        var item = 0
        var section = 0
        switch usingFor {
        case .contacts:
            item = self.viewModel.selectedPhoneContacts.count
            section = 0
        case .facebook:
            item = self.viewModel.selectedFacebookContacts.count
            section = 1
        case .google:
            item = self.viewModel.selectedGoogleContacts.count
            section = 2
        default:
            item = 0
        }
//        self.selectedContactsCollectionView.performBatchUpdates({
//            self.selectedContactsCollectionView.insertItems(at: [IndexPath(item: item, section: usingFor.rawValue)])
//            self.itemsCounts[usingFor.rawValue] += 1
//        }, completion: { (isDone) in
//                self.scrollCollectionToEnd()
//        })
        self.itemsCounts[usingFor.rawValue] = item
        self.selectionDidChanged()
        delay(seconds: 0.2) { [weak self] in
            self?.selectedContactsCollectionView.reloadSection(section: section)
        }
        
        //self.scrollCollectionToEnd()
        
    }
    
    func remove(fromIndex: Int, for usingFor: ContactListVC.UsingFor) {
        
//        self.selectedContactsCollectionView.performBatchUpdates({
//            self.selectedContactsCollectionView.deleteItems(at: [IndexPath(item: fromIndex, section: usingFor.rawValue)])
//            self.itemsCounts[usingFor.rawValue] -= 1
//        }, completion: { (isDone) in
//            self.selectionDidChanged()
//        })
        self.itemsCounts[usingFor.rawValue] -= 1
        self.selectedContactsCollectionView.reloadData()
        self.selectionDidChanged()
    }
    func remove(for usingFor: ContactListVC.UsingFor) {
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
        //        self.selectedContactsCollectionView.performBatchUpdates({
        //            self.selectedContactsCollectionView.insertItems(at: [IndexPath(item: item, section: usingFor.rawValue)])
        //            self.itemsCounts[usingFor.rawValue] += 1
        //        }, completion: { (isDone) in
        //                self.scrollCollectionToEnd()
        //        })
        self.itemsCounts[usingFor.rawValue] = item
        self.selectionDidChanged()
        self.selectedContactsCollectionView.reloadData()
        
    }
    func addAll(for usingFor: ContactListVC.UsingFor) {

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
        
        /*
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
         */
        self.itemsCounts[usingFor.rawValue] = item
        self.selectionDidChanged()
        self.selectedContactsCollectionView.reloadData()
        

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
        
        /*
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
         */
        self.itemsCounts[usingFor.rawValue] = item
        self.selectionDidChanged()
        self.selectedContactsCollectionView.reloadData()
        
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
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectedContactImportCollectionCell", for: indexPath) as? SelectedContactImportCollectionCell else {
            fatalError("SelectedContactImportCollectionCell not found")
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
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
                self.allChildVCs[0].updateSelectAllState(for: .contacts)
                
            case 1:
                //facebook
                self.viewModel.selectedFacebookContacts.remove(at: indexPath.item)
                self.viewModel.remove(fromIndex: indexPath.item, for: .facebook)
                self.allChildVCs[1].updateSelectAllState(for: .facebook)
                
            case 2:
                //google
                self.viewModel.selectedGoogleContacts.remove(at: indexPath.item)
                self.viewModel.remove(fromIndex: indexPath.item, for: .google)
                self.allChildVCs[2].updateSelectAllState(for: .google)
                
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

extension ImportContactVC: PagingViewControllerDataSource , PagingViewControllerDelegate {
    func numberOfViewControllers<T>(in pagingViewController: PagingViewController<T>) -> Int where T : PagingItem, T : Comparable, T : Hashable {
         self.allTabsStr.count
    }
    
    func pagingViewController<T>(_ pagingViewController: PagingViewController<T>, viewControllerForIndex index: Int) -> UIViewController where T : PagingItem, T : Comparable, T : Hashable {
         return self.allChildVCs[index]
    }
    
    func pagingViewController<T>(_ pagingViewController: PagingViewController<T>, pagingItemForIndex index: Int) -> T where T : PagingItem, T : Comparable, T : Hashable {
        return PagingIndexItem(index: index, title:  self.allTabsStr[index]) as! T
    }
    
    func pagingViewController<T>(_ pagingViewController: PagingViewController<T>, widthForPagingItem pagingItem: T, isSelected: Bool) -> CGFloat? where T : PagingItem, T : Comparable, T : Hashable {

        // depending onthe text size, give the width of the menu item
        if let pagingIndexItem = pagingItem as? PagingIndexItem{
            let text = pagingIndexItem.title
            
            let font = AppFonts.SemiBold.withSize(16.0)
            return text.widthOfString(usingFont: font)
        }
        
        return 100.0
    }
    
    func pagingViewController<T>(_ pagingViewController: PagingViewController<T>, didScrollToItem pagingItem: T, startingViewController: UIViewController?, destinationViewController: UIViewController, transitionSuccessful: Bool) where T : PagingItem, T : Comparable, T : Hashable {
           
           let pagingIndexItem = pagingItem as! PagingIndexItem
           self.currentIndex = pagingIndexItem.index
       }
}


