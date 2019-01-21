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
    @IBOutlet weak var importButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var navTitleLabel: UILabel!
    @IBOutlet weak var selectedContactsContainerView: UIView!
    @IBOutlet weak var selectedContactsContainerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchBar: ATSearchBar!
    @IBOutlet weak var listContainerView: UIView!
    @IBOutlet weak var selectedContactsCollectionView: UICollectionView!
    
    
    //MARK:- Properties
    //MARK:- Public
    
    //MARK:- Private
    private(set) var viewModel = ImportContactVM.shared
    private var viewPager:PKViewPagerController!
    private var options:PKViewPagerOptions!
    private var currentIndex: Int = 0 {
        didSet {
            self.updateNavTitle()
        }
    }
    private let allTabs: [PKViewPagerTab] = [PKViewPagerTab(title: LocalizedString.Contacts.localized, image: nil), PKViewPagerTab(title: LocalizedString.Facebook.localized, image: nil), PKViewPagerTab(title: LocalizedString.Google.localized, image: nil)]
    
    private var listVCs: [UIViewController] = []
    
    //MARK:- ViewLifeCycle
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.initialSetups()
    }
    
    override func setupFonts() {
        self.cancelButton.titleLabel?.font = AppFonts.Regular.withSize(18.0)
        self.importButton.titleLabel?.font = AppFonts.SemiBold.withSize(18.0)
        self.navTitleLabel.font = AppFonts.SemiBold.withSize(18.0)
    }
    
    override func setupTexts() {
        self.cancelButton.setTitle(LocalizedString.Cancel.localized, for: .normal)
        self.cancelButton.setTitle(LocalizedString.Cancel.localized, for: .selected)
        
        self.importButton.setTitle(LocalizedString.Import.localized, for: .normal)
        self.importButton.setTitle(LocalizedString.Import.localized, for: .selected)
        
        self.navTitleLabel.text = LocalizedString.AllowContacts.localized
    }
    
    override func setupColors() {
        self.cancelButton.setTitleColor(AppColors.themeGreen, for: .normal)
        self.cancelButton.setTitleColor(AppColors.themeGreen, for: .selected)
        
        self.importButton.setTitleColor(AppColors.themeGreen, for: .normal)
        self.importButton.setTitleColor(AppColors.themeGreen, for: .selected)
        self.importButton.setTitleColor(AppColors.themeGray40, for: .disabled)
        
        self.navTitleLabel.textColor = AppColors.themeBlack
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
    
    deinit {
        printDebug("deinit")
    }
    
    //MARK:- Methods
    //MARK:- Private
    private func initialSetups() {
        
        self.viewModel.selectedPhoneContacts.removeAll()
        self.viewModel.selectedFacebookContacts.removeAll()
        self.viewModel.selectedGoogleContacts.removeAll()
        
        self.searchBar.delegate = self
        self.searchBar.placeholder = LocalizedString.search.localized
        
        self.listVCs = Array(repeating: UIViewController(), count: self.allTabs.count)
        
        self.selectedContactsCollectionView.dataSource = self
        self.selectedContactsCollectionView.delegate = self
        self.selectedContactsSetHidden(isHidden: true, animated: false)
        
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        
        options = PKViewPagerOptions(viewPagerWithFrame: listContainerView.bounds)
        options.tabType = PKViewPagerTabType.basic
        options.tabViewImageSize = CGSize.zero
        options.tabViewTextFont = AppFonts.Regular.withSize(16.0)
        options.tabViewPaddingLeft = 5
        options.tabViewPaddingRight = 5
        options.isTabHighlightAvailable = true
        options.tabViewBackgroundDefaultColor = AppColors.themeWhite
        options.tabViewBackgroundHighlightColor = AppColors.themeWhite
        options.tabViewTextDefaultColor = AppColors.themeBlack
        options.tabViewTextHighlightColor = AppColors.themeBlack
        options.tabIndicatorViewHeight = 2.0
        options.tabIndicatorViewBackgroundColor = AppColors.themeGreen
        options.fitAllTabsInView = true
        
        viewPager = PKViewPagerController()
        viewPager.options = options
        viewPager.dataSource = self
        viewPager.delegate = self
        
        self.addChild(viewPager)
        self.listContainerView.addSubview(viewPager.view)
        viewPager.didMove(toParent: self)
        
        self.updateNavTitle()
    }
    
    private func selectedContactsSetHidden(isHidden: Bool, animated: Bool) {
        let listVC = self.listVCs[currentIndex] as? ContactListVC
        UIView.animate(withDuration: animated ? AppConstants.kAnimationDuration : 0.0, animations: { [weak self] in
            self?.selectedContactsContainerHeightConstraint.constant = isHidden ? 0.0 : 100.0
            listVC?.containerBottomConstraint.constant = isHidden ? 10.0 : 110.0
            self?.view.layoutIfNeeded()
            listVC?.view.layoutIfNeeded()
        }) { (isCompleted) in
        }
    }
    
    private func updateNavTitle() {
        
        if self.viewModel.totalContacts <= 0 {
            self.importButton.isEnabled = false
            switch self.currentIndex {
            case 0:
                //phone
                self.navTitleLabel.text = LocalizedString.AllowContacts.localized
                
            case 1:
                //facebook
                self.navTitleLabel.text = LocalizedString.ConnectWithFB.localized
                
            case 2:
                //google
                self.navTitleLabel.text = LocalizedString.ConnectWithGoogle.localized
                
            default:
                self.navTitleLabel.text = LocalizedString.AllowContacts.localized
            }
        }
        else {
            self.importButton.isEnabled = true
            self.navTitleLabel.text = "\(self.viewModel.totalContacts) \(LocalizedString.ContactsSelected.localized)"
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

extension ImportContactVC: PKViewPagerControllerDataSource {
    
    func numberOfPages() -> Int {
        return self.allTabs.count
    }
    
    func viewControllerAtPosition(position: Int) -> UIViewController {
        if let obj = self.listVCs[position] as? ContactListVC {
            return obj
        }
        else {
            let vc = ContactListVC.instantiate(fromAppStoryboard: .TravellerList)
            vc.currentlyUsingFor = ContactListVC.UsingFor(rawValue: position) ?? .contacts
            self.listVCs[position] = vc
            return vc
        }
    }
    
    func tabsForPages() -> [PKViewPagerTab] {
        return self.allTabs
    }
    
    func startViewPagerAtIndex() -> Int {
        return 0
    }
}

extension ImportContactVC: PKViewPagerControllerDelegate {
    
    func willMoveToControllerAtIndex(index:Int) {
        print("Moving to page \(index)")
    }
    
    func didMoveToControllerAtIndex(index: Int) {
        self.currentIndex = index
        print("Moved to page \(index)")
    }
}

extension ImportContactVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.viewModel.search(forText: searchText)
    }
}

//MARK:- ViewModel Delegate
//MARK:-
extension ImportContactVC: ImportContactVMDelegate {
    func contactSavedFail() {
        AppToast.default.showToastMessage(message: "Not able to save contacts. Please try again.", vc: self)
    }
    
    func contactSavedSuccess() {
        self.cancelButtonAction(self.cancelButton)
    }
    
    func phoneContactSavedFail() {
        AppToast.default.showToastMessage(message: "Not able to save contacts. Please try again.", vc: self)
    }
    
    func willFetchPhoneContacts() {
        
    }
    
    func fetchPhoneContactsSuccess() {

    }
    
    func selectionDidChanged() {
        self.updateNavTitle()
        self.selectedContactsCollectionView.reloadData()
        self.selectedContactsSetHidden(isHidden: self.viewModel.totalContacts <= 0, animated: true)
    }
}

extension ImportContactVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return [self.viewModel.selectedPhoneContacts.count, self.viewModel.selectedFacebookContacts.count, self.viewModel.selectedGoogleContacts.count][section]
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
                
            case 1:
                //facebook
                self.viewModel.selectedFacebookContacts.remove(at: indexPath.item)
                
            case 2:
                //google
                self.viewModel.selectedGoogleContacts.remove(at: indexPath.item)
                
            default:
                printDebug("not a correct index")
            }
        }
    }
}
