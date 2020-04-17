//
//  ADEventFilterVC.swift
//  AERTRIP
//
//  Created by Admin on 22/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit
import Parchment

struct AccountSelectedFilter {
    var fromDate: Date? = nil
    var toDate: Date? = nil
    var voucherType: String = ""
}

protocol ADEventFilterVCDelegate: class {
    func adEventFilterVC(filterVC: ADEventFilterVC, didChangedFilter filter: AccountSelectedFilter?)
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
    
    //MARK:- Properties
    //MARK:- Public
    var voucherTypes: [String] = []
    weak var delegate: ADEventFilterVCDelegate?
    var oldFilter: AccountSelectedFilter?
    var minFromDate: Date?
    
    //MARK:- Private
    private var selectedFilter: AccountSelectedFilter = AccountSelectedFilter()
    private var currentIndex: Int = 0
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
    
    //MARK:- ViewLifeCycle
    //MARK:-
    override func initialSetup() {
        
        if !self.voucherTypes.isEmpty {
            self.voucherTypes.insert("All", at: 0)
        }
        
        self.topNavBar.configureNavBar(title: "", isLeftButton: true, isFirstRightButton: true, isDivider: false)
        
        let clearAll = "  \(LocalizedString.ClearAll.localized)"
        self.topNavBar.configureLeftButton(normalTitle: clearAll, selectedTitle: clearAll, normalColor: AppColors.themeGreen, selectedColor: AppColors.themeGreen, font: AppFonts.Regular.withSize(18.0))
        
        let done = "\(LocalizedString.Done.localized)  "
        self.topNavBar.configureFirstRightButton(normalTitle: done, selectedTitle: done, normalColor: AppColors.themeGreen, selectedColor: AppColors.themeGreen, font: AppFonts.SemiBold.withSize(18.0))
        self.mainContainerView.roundBottomCorners(cornerRadius: 10.0)
        
        if let old = self.oldFilter {
            self.selectedFilter = old
        }
        else {
            self.selectedFilter = AccountSelectedFilter()
            self.selectedFilter.fromDate = self.minFromDate
            self.selectedFilter.toDate = Date()
        }
    
        travelDateVC.oldToDate = self.oldFilter?.toDate
        travelDateVC.oldFromDate = self.oldFilter?.fromDate
        travelDateVC.minFromDate = self.minFromDate
        
        travelDateVC.delegate = self
        
        
        adVoucherTypeVC.delegate = self
        adVoucherTypeVC.viewModel.allTypes = self.voucherTypes
        
        
        if self.selectedFilter.voucherType.isEmpty {
            self.didSelect(voucher: self.voucherTypes.first ?? "")
        }
        
        if let vchr = self.oldFilter?.voucherType, let indx = self.voucherTypes.firstIndex(of: vchr) {
            adVoucherTypeVC.viewModel.selectedIndexPath = IndexPath(row: indx, section: 0)
        }
        else {
            adVoucherTypeVC.viewModel.selectedIndexPath = IndexPath(row: 0, section: 0)
        }
        
        let height = UIApplication.shared.statusBarFrame.height
        self.navigationViewTopConstraint.constant = CGFloat(height)

        self.hide(animated: false)
        delay(seconds: 0.01) { [weak self] in
            self?.setUpViewPager()
        }
        self.setupGesture()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.show(animated: true)
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
        self.topNavBar.navTitleLabel.textColor = AppColors.themeGray40
    }
    
    //MARK:- Methods
    //MARK:- Private
    private func show(animated: Bool) {
        UIView.animate(withDuration: animated ? AppConstants.kAnimationDuration : 0.0, animations: {
            self.mainContainerViewTopConstraint.constant = 0.0
            self.view.layoutIfNeeded()
        })
    }
    
    private func hide(animated: Bool, shouldRemove: Bool = false) {
        UIView.animate(withDuration: animated ? AppConstants.kAnimationDuration : 0.0, animations: {
            self.mainContainerViewTopConstraint.constant = -(self.mainContainerView.height)
            self.view.layoutIfNeeded()
        }, completion: { _ in
            if shouldRemove {
                self.removeFromParentVC
            }
        })
    }
    
    
    private func setUpViewPager() {
        self.currentIndex = 0
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
        self.parchmentView?.menuItemSpacing = (UIDevice.screenWidth - 268.0)
        self.parchmentView?.menuInsets = UIEdgeInsets(top: 0.0, left: 59.0, bottom: 0.0, right: 46.0)
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
        
        self.parchmentView?.dataSource = self
        self.parchmentView?.delegate = self
        self.parchmentView?.sizeDelegate = self
        self.parchmentView?.select(index: 0)
        
        self.parchmentView?.reloadData()
        self.parchmentView?.reloadMenu()
      }
    
//    private func setupPagerView() {
//        var style = ATCategoryNavBarStyle()
//        style.height = 50.0
//        style.interItemSpace = (self.allTabsStr.count > 2) ? 50.0 : 55.0
//        style.itemPadding = (self.allTabsStr.count > 2) ? 25.0 : 28.0
//        style.isScrollable = false
//        style.layoutAlignment = .left
//        style.isEmbeddedToView = true
//        style.showBottomSeparator = true
//        style.bottomSeparatorColor = AppColors.themeGray40
//        style.defaultFont = AppFonts.Regular.withSize(16.0)
//        style.selectedFont = AppFonts.SemiBold.withSize(16.0)
//        style.indicatorColor = AppColors.themeGreen
//        style.normalColor = AppColors.textFieldTextColor51
//        style.selectedColor = AppColors.themeBlack
//        style.badgeDotSize = CGSize(width: 4.0, height: 4.0)
//        style.badgeBackgroundColor = AppColors.themeGreen
//        style.badgeBorderColor = AppColors.clear
//        style.badgeBorderWidth = 0.0
//
//
//        let categoryView = ATCategoryView(frame: self.childContainerView.bounds, categories: self.allTabs, childVCs: [travelDateVC, adVoucherTypeVC], parentVC: self, barStyle: style)
//        categoryView.interControllerSpacing = 0.0
//        categoryView.navBar.internalDelegate = self
//        self.childContainerView.addSubview(categoryView)
//        self.categoryView = categoryView
//
//        // Set last Selected Index on Nav bar
//        self.categoryView.select(at: 0)
//        self.setBadgesOnAllCategories()
//    }
    
    private func setBadgesOnAllCategories() {
    }
    
    private func setupGesture() {
        let gestureRecognizer = UITapGestureRecognizer(target: self,action: #selector(outsideAreaTapped))
        gestureRecognizer.cancelsTouchesInView = false
        gestureRecognizer.numberOfTapsRequired = 1
        gestureRecognizer.numberOfTouchesRequired = 1
        gestureRecognizer.delegate = self
        view.addGestureRecognizer(gestureRecognizer)
    }

    //MARK:- Public
    
    
    //MARK:- Action
    @objc func  outsideAreaTapped() {
        
        self.hide(animated: true, shouldRemove: true)
    }
}

//MARK:- Extensions
extension ADEventFilterVC: TopNavigationViewDelegate {
    
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        //clear all
        self.delegate?.adEventFilterVC(filterVC: self, didChangedFilter: nil)
        self.hide(animated: true, shouldRemove: true)
    }
    
    func topNavBarFirstRightButtonAction(_ sender: UIButton) {
        //done
        self.delegate?.adEventFilterVC(filterVC: self, didChangedFilter: self.selectedFilter)
        self.hide(animated: true, shouldRemove: true)
    }
}

//MARK:- ATCategoryNavBarDelegate
extension ADEventFilterVC: ATCategoryNavBarDelegate {
    func categoryNavBar(_ navBar: ATCategoryNavBar, didSwitchIndexTo toIndex: Int) {
        self.currentIndex = toIndex
    }
}

//MARK:- UIGestureRecognizerDelegate Method
extension ADEventFilterVC {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return (touch.view === self.view)
    }
}

extension ADEventFilterVC: ADVoucherTypeVCDelegate, TravelDateVCDelegate {

    func didSelect(voucher: String) {
        if !voucher.isEmpty, voucher.lowercased() != "all" {
            self.selectedFilter.voucherType = voucher
        }
        else {
            self.selectedFilter.voucherType = ""
        }
    }
    
    func didSelect(toDate: Date, forType: TravelDateVC.UsingFor) {
        self.selectedFilter.toDate = toDate
    }
    
    func didSelect(fromDate: Date, forType: TravelDateVC.UsingFor) {
        self.selectedFilter.fromDate = fromDate
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
        return MenuItem(title: self.allTabsStr[index], index: index, isSelected:false)
    }
    
    func pagingViewController(_: PagingViewController, widthForPagingItem pagingItem: PagingItem, isSelected: Bool) -> CGFloat {
        
        // depending onthe text size, give the width of the menu item
        if let pagingIndexItem = pagingItem as? MenuItem{
            let text = pagingIndexItem.title
            
            let font = isSelected ? AppFonts.SemiBold.withSize(16.0) : AppFonts.Regular.withSize(16.0)
            return text.widthOfString(usingFont: font)
        }
        
        return 100.0
    }
    
    func pagingViewController(_ pagingViewController: PagingViewController, didScrollToItem pagingItem: PagingItem, startingViewController: UIViewController?, destinationViewController: UIViewController, transitionSuccessful: Bool)  {
        
        if let pagingIndexItem = pagingItem as?  MenuItem {
        self.currentIndex = pagingIndexItem.index
        }
    }
    
}


