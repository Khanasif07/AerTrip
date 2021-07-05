//
//  ADEventFilterVC.swift
//  AERTRIP
//
//  Created by Admin on 22/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit
import Parchment



protocol ADEventFilterVCDelegate: class {
    func applyFilter()
    func clearAllFilter()
}

class ADEventFilterVC: BaseVC {
    
    //MARK:- IBOutlets
    //MARK:-
    @IBOutlet weak var topNavBar: TopNavigationView!{
        didSet {
            self.topNavBar.delegate = self
        }
    }
    @IBOutlet weak var childContainerView: UIView!
    @IBOutlet weak var mainContainerViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var navigationViewTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var mainBackView: UIView!
    //MARK:- Properties
    //MARK:- Public
    weak var delegate: ADEventFilterVCDelegate?
    
    //MARK:- Private
    //    fileprivate weak var categoryView: ATCategoryView!
    
    // Parchment View
    private var parchmentView : PagingViewController?
    private let allTabsStr: [String] = [LocalizedString.DateSpan.localized, LocalizedString.VoucherType.localized]
    //    private var allTabs: [ATCategoryItem] {
    //        var temp = [ATCategoryItem]()
    //        for title in self.allTabsStr {
    //            var obj = ATCategoryItem()
    //            obj.title = title
    //            temp.append(obj)
    //        }
    //        return temp
    //    }
    private var allChildVCs: [UIViewController] = [UIViewController(), UIViewController()]
    
    private var travelDateVC = TravelDateVC.instantiate(fromAppStoryboard: .Bookings)
    private var adVoucherTypeVC = ADVoucherTypeVC.instantiate(fromAppStoryboard: .Account)
    private var filtersTabs =  [MenuItem]()

    //MARK:- ViewLifeCycle
    //MARK:-
    override func initialSetup() {
        
//        if !ADEventFilterVM.shared.voucherTypes.isEmpty {
//            ADEventFilterVM.shared.voucherTypes.insert(LocalizedString.ALL.localized, at: 0)
//        }
        
        self.topNavBar.configureNavBar(title: "", isLeftButton: true, isFirstRightButton: true, isDivider: false)
        
        let clearAll = "  \(LocalizedString.ClearAll.localized)"
        self.topNavBar.configureLeftButton(normalTitle: clearAll, selectedTitle: clearAll, normalColor: AppColors.themeGreen, selectedColor: AppColors.themeGreen, font: AppFonts.Regular.withSize(18.0))
        
        let done = "\(LocalizedString.Done.localized)  "
        self.topNavBar.configureFirstRightButton(normalTitle: done, selectedTitle: done, normalColor: AppColors.themeGreen, selectedColor: AppColors.themeGreen, font: AppFonts.SemiBold.withSize(18.0))
        self.mainContainerView.roundBottomCorners(cornerRadius: 10.0)
        
        
        
        travelDateVC.oldToDate = ADEventFilterVM.shared.toDate
        travelDateVC.oldFromDate = ADEventFilterVM.shared.fromDate
        travelDateVC.minFromDate = ADEventFilterVM.shared.minFromDate
        travelDateVC.minDate = ADEventFilterVM.shared.minDate
        travelDateVC.maxDate = ADEventFilterVM.shared.maxDate

        
        travelDateVC.delegate = self
        
        
        adVoucherTypeVC.delegate = self
        
        
        //        if self.selectedFilter.voucherType.isEmpty {
        //            self.didSelect(voucher: self.voucherTypes.first ?? "")
        //        }
//        let vchr = ADEventFilterVM.shared.voucherType
//        if let indx = ADEventFilterVM.shared.voucherTypes.firstIndex(of: vchr) {
//            adVoucherTypeVC.viewModel.selectedIndexPath = IndexPath(row: indx, section: 0)
//        }
//        else {
//            adVoucherTypeVC.viewModel.selectedIndexPath = IndexPath(row: 0, section: 0)
//        }
        
        let height = UIApplication.shared.statusBarFrame.height
        self.navigationViewTopConstraint.constant = CGFloat(height)
        
//        self.hide(animated: false)
//        self.mainContainerView.transform = CGAffineTransform(translationX: 0, y: -self.mainContainerView.height)
        //        delay(seconds: 0.01) { [weak self] in
        self.setUpViewPager()
        //        }
        //for header blur
        // self.view.backgroundColor = AppColors.themeWhite.withAlphaComponent(0.85)
        topNavBar.backgroundColor = AppColors.clear
        mainBackView.backgroundColor = AppColors.themeBlack.withAlphaComponent(0.4)
        DispatchQueue.main.async {
            self.setupGesture()
            self.checkDoneBtnState()
        }
        self.hide(animated: false)
        self.show(animated: true)
    }
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.show(animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.parchmentView?.view.frame = self.childContainerView.bounds
        self.parchmentView?.loadViewIfNeeded()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.parchmentView?.view.frame = self.childContainerView.bounds
        self.parchmentView?.loadViewIfNeeded()
    }
    
    override func setupTexts() {
    }
    
    override func setupFonts() {
        self.topNavBar.navTitleLabel.font = AppFonts.Regular.withSize(16.0)
    }
    
    override func setupColors() {
//        self.topNavBar.navTitleLabel.textColor = AppColors.themeGray40
        self.topNavBar.navTitleLabel.textColor = AppColors.themeGray153
        self.mainBackView.backgroundColor = AppColors.unicolorBlack.withAlphaComponent(0.4)
        self.mainContainerView.backgroundColor = AppColors.themeWhiteDashboard
        self.childContainerView.backgroundColor = AppColors.themeWhiteDashboard
        
    }
    
    //MARK:- Methods
    //MARK:- Private
    private func show(animated: Bool) {
        UIView.animate(withDuration: animated ? AppConstants.kAnimationDuration : 0.0, animations: {
            self.mainContainerView.transform = .identity
//            self.mainContainerViewTopConstraint.constant = 0.0
            self.mainBackView.alpha = 1.0
            self.view.layoutIfNeeded()
        })
    }
    
    private func hide(animated: Bool, shouldRemove: Bool = false) {
        UIView.animate(withDuration: animated ? AppConstants.kAnimationDuration : 0.0, animations: {
//            self.mainContainerViewTopConstraint.constant = -(self.mainContainerView.height)
            self.mainContainerView.transform = CGAffineTransform(translationX: 0, y: -self.mainContainerView.height)
            self.mainBackView.alpha = 0.0
            self.view.layoutIfNeeded()
        }, completion: { _ in
            if shouldRemove {
                self.removeFromParentVC
            }
        })
    }
    
    
    private func setUpViewPager() {
        for i in 0..<(allTabsStr.count){
            let obj = MenuItem(title: HotelFilterVM.shared.allTabsStr[i], index: i, isSelected: false)
            filtersTabs.append(obj)
        }
        setBadgesOnAllCategories()
        self.allChildVCs.removeAll()
        self.allChildVCs.append(travelDateVC)
        self.allChildVCs.append(adVoucherTypeVC)
        self.view.layoutIfNeeded()
        if let _ = self.parchmentView{
            self.parchmentView?.view.removeFromSuperview()
            self.parchmentView = nil
        }
        setupParchmentPageController()
    }
    
    // Added to replace the existing page controller, added Asif Khan
    private func setupParchmentPageController(){
        
        self.parchmentView = PagingViewController()
        var textWidth: CGFloat = 0
         allTabsStr.forEach { (str) in
            textWidth += str.widthOfString(usingFont: AppFonts.Regular.withSize(16.0)) + 22
         }
         var menuItemSpacing: CGFloat = 0
         if self.allTabsStr.count > 2 {
             menuItemSpacing = (UIDevice.screenWidth - (textWidth))/4 //(textWidth + 28 + 28)/2 (screen width - textspace + leading and trailing constant space) / number of tabs - 1
         } else {
             menuItemSpacing = (UIDevice.screenWidth - (textWidth))/3 //(textWidth + 59.0 + 59.0)
         }
         self.parchmentView?.menuItemSpacing = menuItemSpacing
         self.parchmentView?.menuInsets = UIEdgeInsets(top: 0.0, left: menuItemSpacing, bottom: 0.0, right:  menuItemSpacing)
        self.parchmentView?.menuItemSize = .sizeToFit(minWidth: 150, height: 50.0)
        self.parchmentView?.indicatorOptions = PagingIndicatorOptions.visible(height: 2, zIndex: Int.max, spacing: UIEdgeInsets.zero, insets: UIEdgeInsets(top: 0, left: 0.0, bottom: 0, right: 0.0))
        self.parchmentView?.borderOptions = PagingBorderOptions.visible(
            height: 0.5,
            zIndex: Int.max - 1,
            insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        let nib = UINib(nibName: "MenuItemCollectionCell", bundle: nil)
        self.parchmentView?.register(nib, for: MenuItem.self)
        self.parchmentView?.borderColor = AppColors.themeBlack.withAlphaComponent(0.16)
        self.parchmentView?.font = AppFonts.Regular.withSize(16.0)
        self.parchmentView?.selectedFont = AppFonts.SemiBold.withSize(16.0)
        self.parchmentView?.indicatorColor = AppColors.themeGreen
        self.parchmentView?.selectedTextColor = AppColors.themeBlack
        self.childContainerView.addSubview(self.parchmentView!.view)
        self.parchmentView?.menuBackgroundColor = AppColors.clear
        self.parchmentView?.dataSource = self
        self.parchmentView?.delegate = self
        self.parchmentView?.sizeDelegate = self
        self.parchmentView?.select(index: ADEventFilterVM.shared.currentIndex)
        
        self.parchmentView?.reloadData()
        self.parchmentView?.reloadMenu()
    }
    
    
    
    private func setBadgesOnAllCategories() {
        
        for (idx,tab) in self.allTabsStr.enumerated() {
            
            switch tab.lowercased() {
            case LocalizedString.DateSpan.localized.lowercased():
                if ADEventFilterVM.shared.toDate != nil || ADEventFilterVM.shared.fromDate != nil {
                    filtersTabs[idx].isSelected = false
                } else {
                    filtersTabs[idx].isSelected = true
                }
                
            case LocalizedString.VoucherType.localized.lowercased():
                filtersTabs[idx].isSelected  = ADEventFilterVM.shared.selectedVoucherType.isEmpty
                
            default:
                printDebug("not useable case")
            }
        }
    }
    
    private func setupGesture() {
        let gestureRecognizer = UITapGestureRecognizer(target: self,action: #selector(outsideAreaTapped))
        gestureRecognizer.cancelsTouchesInView = false
        gestureRecognizer.numberOfTapsRequired = 1
        gestureRecognizer.numberOfTouchesRequired = 1
        gestureRecognizer.delegate = self
        self.mainBackView.addGestureRecognizer(gestureRecognizer)
    }
    
    //MARK:- Public
    
    
    //MARK:- Action
    @objc func  outsideAreaTapped() {
        
        self.hide(animated: true, shouldRemove: true)
    }
    
    private func checkDoneBtnState() {
        if  ADEventFilterVM.shared.isFilterAplied {
            self.topNavBar.leftButton.isEnabled = true
            self.topNavBar.leftButton.setTitleColor(AppColors.themeGreen, for: .normal)
        } else {
            self.topNavBar.leftButton.isEnabled = false
            self.topNavBar.leftButton.setTitleColor(AppColors.themeGray40, for: .normal)
        }
    }
}

//MARK:- Extensions
extension ADEventFilterVC: TopNavigationViewDelegate {
    
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        //clear all
        ADEventFilterVM.shared.setToDefault()
        self.delegate?.clearAllFilter()
        self.allChildVCs.forEach { (viewController) in
            if let vc = viewController as? TravelDateVC {
                vc.oldToDate = ADEventFilterVM.shared.toDate
                vc.oldFromDate = ADEventFilterVM.shared.fromDate
//                vc.minFromDate = ADEventFilterVM.shared.minFromDate
                vc.minDate  = ADEventFilterVM.shared.minFromDate
                vc.maxDate = ADEventFilterVM.shared.maxDate
                vc.setFilterValues()
            }
            else if let vc = viewController as? ADVoucherTypeVC {
                vc.setFilterValues()
            }
        }
        checkDoneBtnState()
        reloadMenu()
        // self.hide(animated: true, shouldRemove: true)
    }
    
    func topNavBarFirstRightButtonAction(_ sender: UIButton) {
        //done
        self.delegate?.applyFilter()
        self.hide(animated: true, shouldRemove: true)
    }
}


//MARK:- UIGestureRecognizerDelegate Method
extension ADEventFilterVC {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return (touch.view === self.mainBackView)
    }
}

extension ADEventFilterVC: ADVoucherTypeVCDelegate, TravelDateVCDelegate {
    
    func didSelect() {
//        if !voucher.isEmpty, voucher.lowercased() != "all" {
//            ADEventFilterVM.shared.voucherType = voucher
//        }
//        else {
//            ADEventFilterVM.shared.voucherType = ""
//        }
        self.delegate?.applyFilter()
        checkDoneBtnState()
        reloadMenu()
    }
    
    func didSelect(toDate: Date?, forType: TravelDateVC.UsingFor) {
        ADEventFilterVM.shared.toDate = toDate
        self.delegate?.applyFilter()
        checkDoneBtnState()
        reloadMenu()
    }
    
    func didSelect(fromDate: Date?, forType: TravelDateVC.UsingFor) {
        ADEventFilterVM.shared.fromDate = fromDate
        self.delegate?.applyFilter()
        checkDoneBtnState()
        reloadMenu()
    }
    
    func reloadMenu(){
        DispatchQueue.main.async {
        self.setBadgesOnAllCategories()
        UIView.setAnimationsEnabled(false)
        UIView.animate(withDuration: 0, animations: {
            self.parchmentView?.reloadMenu()
        }) { (_) in
            UIView.setAnimationsEnabled(true)
        }
        }
    }
}

extension ADEventFilterVC : PagingViewControllerDataSource , PagingViewControllerDelegate, PagingViewControllerSizeDelegate {
    func numberOfViewControllers(in pagingViewController: PagingViewController) -> Int {
        self.allTabsStr.count
    }
    
    func pagingViewController(_ pagingViewController: PagingViewController, viewControllerAt index: Int) -> UIViewController  {
        return self.allChildVCs[index]
    }
    
    func pagingViewController(_: PagingViewController, pagingItemAt index: Int) -> PagingItem {
        return MenuItem(title: self.allTabsStr[index], index: index, isSelected: filtersTabs[index].isSelected )
    }
    
    func pagingViewController(_: PagingViewController, widthForPagingItem pagingItem: PagingItem, isSelected: Bool) -> CGFloat {
        
        // depending onthe text size, give the width of the menu item
        if let pagingIndexItem = pagingItem as? MenuItem{
            let text = pagingIndexItem.title
            
            let font = isSelected ? AppFonts.SemiBold.withSize(16.0) : AppFonts.Regular.withSize(16.0)
            return text.widthOfString(usingFont: font) + 20
        }
        
        return 100.0
    }
    
    func pagingViewController(_ pagingViewController: PagingViewController, didScrollToItem pagingItem: PagingItem, startingViewController: UIViewController?, destinationViewController: UIViewController, transitionSuccessful: Bool)  {
        
        if let pagingIndexItem = pagingItem as?  MenuItem {
            ADEventFilterVM.shared.currentIndex = pagingIndexItem.index
        }
    }
    
}


