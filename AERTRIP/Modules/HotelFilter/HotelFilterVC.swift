//
//  HotelFilterVC.swift
//  AERTRIP
//
//  Created by apple on 31/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit
import PKCategoryView

protocol HotelFilteVCDelegate: class {
    func doneButtonTapped()
    func clearAllButtonTapped()
    
}

class HotelFilterVC: BaseVC {
    // MARK:- IB Outlets
    
    @IBOutlet weak var clearAllButton: UIButton!
    @IBOutlet weak var navigationTitleLabel: UILabel!
    
    @IBOutlet weak var doneButton: UIButton!
    
    @IBOutlet weak var dataContainerView: UIView!
    @IBOutlet weak var mainContainerViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var navigationViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainBackView: UIView!
    
    // MARK: - Private
    
    private var currentIndex: Int = 0 {
        didSet {
            
        }
    }
    
    //    fileprivate weak var categoryView: PKCategoryView!
    fileprivate weak var categoryView: ATCategoryView!
    
    
    // MARK: - Variables
    
    private let allTabsStr: [String] = [LocalizedString.Sort.localized, LocalizedString.Range.localized, LocalizedString.Price.localized, LocalizedString.Ratings.localized, LocalizedString.Amenities.localized,LocalizedString.Room.localized]
    //    private var allTabs: [PKCategoryItem] {
    //        var temp = [PKCategoryItem]()
    //        for title in self.allTabsStr {
    //            let obj = PKCategoryItem(title: title, normalImage: nil, selectedImage: nil)
    //            temp.append(obj)
    //        }
    //
    //        return temp
    //    }
    private var allTabs: [ATCategoryItem] {
        var temp = [ATCategoryItem]()
        for title in self.allTabsStr {
            let obj = ATCategoryItem(title: title, normalImage: nil, selectedImage: nil)
            temp.append(obj)
        }
        return temp
    }
    
    private var allChildVCs: [UIViewController] = [UIViewController]()
    weak var delegate : HotelFilteVCDelegate?
    
    // MARK: - View Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.layoutIfNeeded()
        self.dataContainerView.layoutIfNeeded()
        self.initialSetups()
        self.setupGesture()
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.categoryView?.frame = self.dataContainerView.bounds
        self.categoryView?.layoutIfNeeded()
        self.categoryView?.layoutSubviews()
        self.categoryView?.navBar?.layoutSubviews()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.categoryView?.frame = self.dataContainerView.bounds
        self.categoryView?.layoutIfNeeded()
        self.categoryView?.layoutSubviews()
        self.categoryView?.navBar?.layoutSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        delay(seconds: 0.5) { [weak self] in
            self?.show(animated: true)
        }
    }
    
    // MARK: - Overrider methods
    
    override func setupTexts() {
        let navigationTitleText = HotelFilterVM.shared.totalHotelCount > 0 ? " \(HotelFilterVM.shared.filterHotelCount) of \(HotelFilterVM.shared.totalHotelCount) Results" : ""
        self.clearAllButton.setTitle(LocalizedString.ClearAll.localized, for: .normal)
        self.doneButton.setTitle(LocalizedString.Done.localized, for: .normal)
        self.navigationTitleLabel.text = navigationTitleText
    }
    
    override func setupFonts() {
        self.clearAllButton.titleLabel?.font = AppFonts.Regular.withSize(18.0)
        self.doneButton.titleLabel?.font = AppFonts.SemiBold.withSize(18.0)
        self.navigationTitleLabel.font = AppFonts.Regular.withSize(16.0)
    }
    
    override func setupColors() {
        self.clearAllButton.setTitleColor(AppColors.themeGreen, for: .normal)
        self.doneButton.setTitleColor(AppColors.themeGreen, for: .normal)
        self.navigationTitleLabel.textColor = AppColors.themeGray40
    }
    
    
    override func bindViewModel() {
        HotelFilterVM.shared.delegate = self
        if UserInfo.hotelFilter != nil {
            self.setBadgesOnAllCategories()
        }
    }
    
    // MARK: - Helper methods
    
    private func initialSetups() {
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        
        
        let height = UIApplication.shared.statusBarFrame.height
        self.navigationViewTopConstraint.constant = CGFloat(height)
        self.setupPagerView()
        //        self.categoryView.selectTab(atIndex: HotelFilterVM.shared.lastSelectedIndex)
        self.hide(animated: false)
        delay(seconds: 0.01) { [weak self] in
            //  self?.show(animated: true)
            self?.mainContainerView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 10.0)
        }
    }
    
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
        
        //        var style = PKCategoryViewConfiguration()
        //        style.navBarHeight = 50.0
        //        style.interItemSpace = 5.0
        //        style.itemPadding = 8.0
        //        style.isNavBarScrollEnabled = true
        //        style.isEmbeddedToView = true
        //        style.showBottomSeparator = true
        //        style.bottomSeparatorColor = AppColors.themeGray20
        //        style.defaultFont = AppFonts.Regular.withSize(16.0)
        //        style.selectedFont = AppFonts.SemiBold.withSize(16.0)
        //        style.indicatorColor = AppColors.themeGreen
        //        style.indicatorHeight = 2.0
        //
        //        style.normalColor = AppColors.textFieldTextColor51
        //        style.selectedColor = AppColors.themeBlack
        //
        //        style.badgeDotSize = CGSize(width: 4.0, height: 4.0)
        //        style.badgeBackgroundColor = AppColors.themeGreen
        //        style.badgeBorderColor = AppColors.clear
        //        style.badgeBorderWidth = 0.0
        var style = ATCategoryNavBarStyle()
        style.height = 50.0
        style.interItemSpace = 5.0
        style.itemPadding = 8.0
        style.isScrollable = true
//        style.layoutAlignment = .center
        style.isEmbeddedToView = true
        style.showBottomSeparator = true
        style.bottomSeparatorColor = AppColors.themeGray20
        style.defaultFont = AppFonts.Regular.withSize(16.0)
        style.selectedFont = AppFonts.SemiBold.withSize(16.0)
        style.indicatorColor = AppColors.themeGreen
        style.indicatorHeight = 2.0
        style.normalColor = AppColors.textFieldTextColor51
        style.selectedColor = AppColors.themeBlack
        style.badgeDotSize = CGSize(width: 4.0, height: 4.0)
        style.badgeBackgroundColor = AppColors.themeGreen
        style.badgeBorderColor = AppColors.clear
        style.badgeBorderWidth = 0.0
        
        
        for i in 0..<self.allTabsStr.count {
            if i == 1 {
                let vc = RangeVC.instantiate(fromAppStoryboard: .Filter)
                self.allChildVCs.append(vc)
            } else if i == 2 {
                let vc = PriceVC.instantiate(fromAppStoryboard: .Filter)
                self.allChildVCs.append(vc)
            } else if i == 3 {
                let vc = RatingVC.instantiate(fromAppStoryboard: .Filter)
                self.allChildVCs.append(vc)
            } else if i == 4 {
                let vc = AmenitiesVC.instantiate(fromAppStoryboard: .Filter)
                self.allChildVCs.append(vc)
            } else if i == 5 {
                let vc = RoomVC.instantiate(fromAppStoryboard: .Filter)
                self.allChildVCs.append(vc)
            } else {
                let vc = SortVC.instantiate(fromAppStoryboard: .Filter)
                self.allChildVCs.append(vc)
            }
        }
        if let _ = self.categoryView {
            self.categoryView.removeFromSuperview()
            self.categoryView = nil
        }
        //        let categoryView = PKCategoryView(frame: self.dataContainerView.bounds, categories: self.allTabs, childVCs: self.allChildVCs, configuration: style, parentVC: self)
        //        categoryView.delegate = self
        //        self.dataContainerView.addSubview(categoryView)
        //        self.categoryView = categoryView
        
        let categoryView = ATCategoryView(frame: self.dataContainerView.bounds, categories: self.allTabs, childVCs: self.allChildVCs, parentVC: self, barStyle: style)
        categoryView.navBar.internalDelegate = self
        self.dataContainerView.addSubview(categoryView)
        self.categoryView = categoryView
        // Set last Selected Index on Nav bar
        //                categoryView.select(HotelFilterVM.shared.lastSelectedIndex)
        delay(seconds: 0.1) {
            //            self.categoryView.selectTab(atIndex: HotelFilterVM.shared.lastSelectedIndex)
            self.categoryView.select(at: HotelFilterVM.shared.lastSelectedIndex)
        }
        self.setBadgesOnAllCategories()
    }
    
    private func setBadgesOnAllCategories() {
        
        for (idx,tab) in self.allTabsStr.enumerated() {
            
            var badgeCount = 0
            switch tab.lowercased() {
            case LocalizedString.Sort.localized.lowercased():
                badgeCount = (HotelFilterVM.shared.sortUsing == HotelFilterVM.shared.defaultSortUsing) ? 0 : 1
                
            case LocalizedString.Range.localized.lowercased():
                badgeCount = (HotelFilterVM.shared.distanceRange == HotelFilterVM.shared.defaultDistanceRange) ? 0 : 1
                
            case LocalizedString.Price.localized.lowercased():
                if HotelFilterVM.shared.leftRangePrice != HotelFilterVM.shared.defaultLeftRangePrice {
                    badgeCount = 1
                }
                else if HotelFilterVM.shared.rightRangePrice != HotelFilterVM.shared.defaultRightRangePrice {
                    badgeCount = 1
                }
                else if HotelFilterVM.shared.priceType != HotelFilterVM.shared.defaultPriceType {
                    badgeCount = 1
                }
                
            case LocalizedString.Ratings.localized.lowercased():
                
                
                let diff = HotelFilterVM.shared.ratingCount.difference(from: HotelFilterVM.shared.defaultRatingCount)
                if 1...4 ~= diff.count {
                    badgeCount = 1
                }
                else if !HotelFilterVM.shared.tripAdvisorRatingCount.difference(from: HotelFilterVM.shared.defaultTripAdvisorRatingCount).isEmpty {
                    badgeCount = 1
                }
                else if HotelFilterVM.shared.isIncludeUnrated != HotelFilterVM.shared.defaultIsIncludeUnrated {
                    badgeCount = 1
                }
            case LocalizedString.Amenities.localized.lowercased():
                if !HotelFilterVM.shared.amenitites.difference(from: HotelFilterVM.shared.defaultAmenitites).isEmpty {
                    badgeCount = 1
                }
                
            case LocalizedString.Room.localized.lowercased():
                if !HotelFilterVM.shared.roomMeal.difference(from: HotelFilterVM.shared.defaultRoomMeal).isEmpty {
                    badgeCount = 1
                }
                else if !HotelFilterVM.shared.roomCancelation.difference(from: HotelFilterVM.shared.defaultRoomCancelation).isEmpty {
                    badgeCount = 1
                }
                else if !HotelFilterVM.shared.roomOther.difference(from: HotelFilterVM.shared.defaultRoomOther).isEmpty {
                    badgeCount = 1
                }
                
            default:
                printDebug("not useable case")
            }
            
            //            self.categoryView?.setBadge(count: badgeCount, atIndex: idx)
            self.categoryView?.setBadge(atIndex: idx, badgeNumber: badgeCount)
        }
    }
    
    private func setupGesture() {
        let gestureRecognizer = UITapGestureRecognizer(target: self,action: #selector(outsideAreaTapped))
        gestureRecognizer.cancelsTouchesInView = false
        gestureRecognizer.numberOfTapsRequired = 1
        gestureRecognizer.numberOfTouchesRequired = 1
        gestureRecognizer.delegate = self
        mainBackView.addGestureRecognizer(gestureRecognizer)
    }
    
    // MARK: - IB Action
    
    @IBAction func clearAllButtonTapped(_ sender: Any) {
        self.hide(animated: true, shouldRemove: true)
        delegate?.clearAllButtonTapped()
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        self.hide(animated: true, shouldRemove: true)
        delegate?.doneButtonTapped()
    }
    
    @objc func  outsideAreaTapped() {
        self.hide(animated: true, shouldRemove: true)
        if UserInfo.hotelFilter == nil {
            HotelFilterVM.shared.lastSelectedIndex = 0
        }
    }
    
    
    
}

// MARK: - PKCategoryViewDelegate

//extension HotelFilterVC: PKCategoryViewDelegate {
//    func categoryView(_ view: PKCategoryView, willSwitchIndexFrom fromIndex: Int, to toIndex: Int) {
//        printDebug("Manage will switch to next index ")
//    }
//
//    func categoryView(_ view: PKCategoryView, didSwitchIndexTo toIndex: Int) {
//        self.currentIndex = toIndex
//        HotelFilterVM.shared.lastSelectedIndex = toIndex
//    }
//
//}

extension HotelFilterVC: ATCategoryNavBarDelegate {
    
    func categoryNavBar(_ navBar: ATCategoryNavBar, willSwitchIndexFrom fromIndex: Int, to toIndex: Int) {
        printDebug("Manage will switch to next index ")
    }
    func categoryNavBar(_ navBar: ATCategoryNavBar, didSwitchIndexTo toIndex: Int) {
        self.currentIndex = toIndex
        HotelFilterVM.shared.lastSelectedIndex = toIndex
    }
    
    
    
}



extension HotelFilterVC: HotelFilterVMDelegate {
    func updateFiltersTabs() {
        self.setBadgesOnAllCategories()
    }
}
