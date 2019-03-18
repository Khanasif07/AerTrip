//
//  SelectGuestsVC.swift
//  AERTRIP
//
//  Created by Admin on 15/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

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
    
    //MARK:- Private
    private let collectionLayout: ContactListCollectionFlowLayout = ContactListCollectionFlowLayout()
    fileprivate weak var categoryView: ATCategoryView!
    
    private(set) var viewModel = ImportContactVM.shared
    private var currentIndex: Int = 0 {
        didSet {
        }
    }
    
    private let allTabsStr: [String] = [LocalizedString.Travellers.localized, LocalizedString.Contacts.localized, LocalizedString.Facebook.localized, LocalizedString.Google.localized]
    private var allTabs: [ATCategoryItem] {
        var temp = [ATCategoryItem]()
        
        for title in allTabsStr {
            var obj = ATCategoryItem()
            obj.title = title
            temp.append(obj)
        }
        
        return temp
    }
    
    private var allChildVCs: [HCGuestListVC] = [HCGuestListVC]()
    
    //MARK:- ViewLifeCycle
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.initialSetups()
    }
    
    override func bindViewModel() {
    }
    
    override func dataChanged(_ note: Notification) {
        
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
        self.topNavView.configureFirstRightButton(normalImage: nil, selectedImage: nil, normalTitle: LocalizedString.Add.rawValue, selectedTitle: LocalizedString.Add.rawValue, normalColor: AppColors.themeGreen, selectedColor: AppColors.themeGreen, font: AppFonts.SemiBold.withSize(18.0))
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
            let vc = HCGuestListVC.instantiate(fromAppStoryboard: .HotelCheckout)
            vc.currentlyUsingFor = HCGuestListVC.UsingFor(rawValue: idx) ?? .contacts
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
    
    //MARK:- Public
    
    
    //MARK:- Action
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addButtonAction(_ sender: UIButton) {
        
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

//MARK:- CollectionView Delegate
//MARK:-
extension HCSelectGuestsVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return GuestDetailsVM.shared.guests.count
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
        cell.guestDetail = GuestDetailsVM.shared.guests[indexPath.section][indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: UIDevice.screenWidth / 5.0, height: collectionView.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

extension HCSelectGuestsVC: SelectedContactCollectionCellDelegate {
    func crossButtonAction(_ sender: UIButton) {
        if let indexPath = self.selectedContactsCollectionView.indexPath(forItem: sender) {
            GuestDetailsVM.shared.guests[indexPath.section][indexPath.item].salutation = ""
            GuestDetailsVM.shared.guests[indexPath.section][indexPath.item].firstName = ""
            GuestDetailsVM.shared.guests[indexPath.section][indexPath.item].lastName = ""
            GuestDetailsVM.shared.guests[indexPath.section][indexPath.item].profilePicture = ""
        }
    }
}

