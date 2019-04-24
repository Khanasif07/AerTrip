//
//  MyBookingFilterVC.swift
//  AERTRIP
//
//  Created by Admin on 15/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class MyBookingFilterVC: BaseVC {
    
    //MARK:- Variables
    //MARK:- Private
    private var currentIndex: Int = 0
    fileprivate weak var categoryView: ATCategoryView!
    private let allTabsStr: [String] = [LocalizedString.TravelDate.localized, LocalizedString.EventType.localized, LocalizedString.BookingDate.localized]
    private var allTabs: [ATCategoryItem] {
        var temp = [ATCategoryItem]()
        for title in self.allTabsStr {
            var obj = ATCategoryItem()
            obj.title = title
            temp.append(obj)
        }
        return temp
    }
    private var allChildVCs: [UIViewController] = [UIViewController]()
    
    //MARK:- IBOutlets
    @IBOutlet var topNavBar: TopNavigationView!{
        didSet {
            self.topNavBar.delegate = self
        }
    }
    @IBOutlet var childContainerView: UIView!
    @IBOutlet var mainContainerViewTopConstraint: NSLayoutConstraint!
    @IBOutlet var mainContainerView: UIView!
    @IBOutlet var navigationViewTopConstraint: NSLayoutConstraint!
    
    
    //MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func initialSetup() {
        self.topNavBar.configureNavBar(title: "2230 of 3000 Results", isLeftButton: true, isFirstRightButton: true, isDivider: false)
        self.topNavBar.configureLeftButton(normalTitle: LocalizedString.ClearAll.localized, selectedTitle: LocalizedString.ClearAll.localized, normalColor: AppColors.themeGreen, selectedColor: AppColors.themeGreen, font: AppFonts.Regular.withSize(18.0))
        self.topNavBar.configureFirstRightButton(normalTitle: LocalizedString.Done.localized, selectedTitle: LocalizedString.Done.localized, normalColor: AppColors.themeGreen, selectedColor: AppColors.themeGreen, font: AppFonts.SemiBold.withSize(18.0))
        
        self.mainContainerView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 10.0)
        self.edgesForExtendedLayout = UIRectEdge(rawValue: 4)
        for i in 0..<self.allTabsStr.count {
            if i == 0 {
                let vc = TravelDateVC.instantiate(fromAppStoryboard: .Bookings)
                self.allChildVCs.append(vc)
            } else if i == 1 {
                let vc = EventTypeVC.instantiate(fromAppStoryboard: .Bookings)
                self.allChildVCs.append(vc)
            } else {
                let vc = BookingDateVC.instantiate(fromAppStoryboard: .Bookings)
                self.allChildVCs.append(vc)
            }
        }
        
        let height = UIApplication.shared.statusBarFrame.height
        self.navigationViewTopConstraint.constant = CGFloat(height)
        self.setupPagerView()
        self.hide(animated: false)
        delay(seconds: 0.01) { [weak self] in
            self?.show(animated: true)
        }
        self.setupGesture()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.categoryView?.frame = self.childContainerView.bounds
        self.categoryView?.layoutIfNeeded()
    }
    
    override func setupTexts() {
    }
    
    override func setupFonts() {
        self.topNavBar.navTitleLabel.font = AppFonts.Regular.withSize(16.0)
    }
    
    override func setupColors() {
        self.topNavBar.navTitleLabel.textColor = AppColors.themeGray40
    }
    
    //MARK:- Functions
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
    
    
    private func setupPagerView() {
        var style = ATCategoryNavBarStyle()
        style.height = 50.0
        style.interItemSpace = 21.8
        style.itemPadding = 12.8
        style.isScrollable = true
        style.layoutAlignment = .left
        style.isEmbeddedToView = true
        style.showBottomSeparator = true
        style.bottomSeparatorColor = AppColors.themeGray40
        style.defaultFont = AppFonts.Regular.withSize(16.0)
        style.selectedFont = AppFonts.SemiBold.withSize(16.0)
        style.indicatorColor = AppColors.themeGreen
        style.normalColor = AppColors.textFieldTextColor51
        style.selectedColor = AppColors.themeBlack
        style.badgeDotSize = CGSize(width: 4.0, height: 4.0)
        style.badgeBackgroundColor = AppColors.themeGreen
        style.badgeBorderColor = AppColors.clear
        style.badgeBorderWidth = 0.0
        
        
        let categoryView = ATCategoryView(frame: self.childContainerView.bounds, categories: self.allTabs, childVCs: self.allChildVCs, parentVC: self, barStyle: style)
        categoryView.interControllerSpacing = 0.0
        categoryView.navBar.internalDelegate = self
        self.childContainerView.addSubview(categoryView)
        self.categoryView = categoryView
        
        // Set last Selected Index on Nav bar
        self.categoryView.select(at: 0)
        self.setBadgesOnAllCategories()
    }
    
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
    
    //MARK:- IBActions
    @objc func  outsideAreaTapped() {
        self.hide(animated: true, shouldRemove: true)
    }
}

//MARK:- Extensions
extension MyBookingFilterVC: TopNavigationViewDelegate {
    
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        self.hide(animated: true, shouldRemove: true)
    }
}

//MARK:- ATCategoryNavBarDelegate
extension MyBookingFilterVC: ATCategoryNavBarDelegate {
    func categoryNavBar(_ navBar: ATCategoryNavBar, didSwitchIndexTo toIndex: Int) {
        self.currentIndex = toIndex
//        HotelFilterVM.shared.lastSelectedIndex = toIndex
    }
}

//MARK:- UIGestureRecognizerDelegate Method
extension MyBookingFilterVC {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return (touch.view === self.view)
    }
}
