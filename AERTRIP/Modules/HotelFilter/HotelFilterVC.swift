//
//  HotelFilterVC.swift
//  AERTRIP
//
//  Created by apple on 31/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit
import Parchment

protocol HotelFilteVCDelegate: class {
    func doneButtonTapped()
    func clearAllButtonTapped()
    
}

class HotelFilterVC: BaseVC {
    // MARK:- IB Outlets
    
    @IBOutlet weak var isFilterAppliedBtn: UIButton!
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
    
    // Parchment View
    fileprivate var parchmentView : PagingViewController<MenuItem>?
    
    
    
    // MARK: - Variables
    var filtersTabs =  [MenuItem]()
    var selectedIndex: Int = 0
    var isFilterApplied:Bool = false
    
    
    let allTabsStr: [String] = [LocalizedString.Sort.localized, LocalizedString.Range.localized, LocalizedString.Price.localized, LocalizedString.Ratings.localized, LocalizedString.Amenities.localized,LocalizedString.Room.localized]
    
    
    var allChildVCs: [UIViewController] = [UIViewController]()
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
        self.parchmentView?.view.frame = self.dataContainerView.bounds
        self.parchmentView?.loadViewIfNeeded()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.parchmentView?.view.frame = self.dataContainerView.bounds
        self.parchmentView?.loadViewIfNeeded()
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
        setFilterButton()
        self.setupPagerView()
        self.hide(animated: false)
        delay(seconds: 0.01) { [weak self] in
            //  self?.show(animated: true)
            self?.mainContainerView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 10.0)
        }
    }
    
    private func  setFilterButton() {
        filtersTabs.forEach { (Item) in
            if Item.isSelected == false {
                self.isFilterApplied = true
            }
        }
        self.isFilterAppliedBtn.setImage(isFilterApplied  ? #imageLiteral(resourceName: "ic_hotel_filter_applied") : #imageLiteral(resourceName: "ic_hotel_filter"), for: .normal)
        self.isFilterAppliedBtn.setImage(isFilterApplied  ? #imageLiteral(resourceName: "ic_hotel_filter_applied") : #imageLiteral(resourceName: "ic_hotel_filter"), for: .selected)
    }
    
    private func initiateFilterTabs() {
        filtersTabs.removeAll()
        for i in 0..<(self.allTabsStr.count){
            let obj = MenuItem(title: allTabsStr[i], index: i, isSelected: true)
            filtersTabs.append(obj)
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
        self.allChildVCs.removeAll()
        self.selectedIndex = HotelFilterVM.shared.lastSelectedIndex
        
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
        self.view.layoutIfNeeded()
        if let _ = self.parchmentView{
            self.parchmentView?.view.removeFromSuperview()
            self.parchmentView = nil
        }
        self.setBadgesOnAllCategories()
        setupParchmentPageController()
        
    }
    
    // Added to replace the existing page controller, added Hitesh Soni, 28-29Jan'2020
    private func setupParchmentPageController(){
        
        self.parchmentView = PagingViewController<MenuItem>()
        self.parchmentView?.menuItemSpacing = 10.0
        self.parchmentView?.menuInsets = UIEdgeInsets(top: 0.0, left: 51.0, bottom: 0.0, right: 0.0)
        self.parchmentView?.menuItemSize = .sizeToFit(minWidth: 150, height: 52)
        self.parchmentView?.indicatorOptions = PagingIndicatorOptions.visible(height: 2, zIndex: Int.max, spacing: UIEdgeInsets(top: 0, left: 7.5, bottom: 0, right: 7.5), insets: UIEdgeInsets(top: 0, left: 0.0, bottom: 0, right: 0.0))
        self.parchmentView?.borderOptions = PagingBorderOptions.visible(
            height: 0.5,
            zIndex: Int.max - 1,
            insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        let nib = UINib(nibName: "MenuItemCollectionCell", bundle: nil)
        self.parchmentView?.menuItemSource = PagingMenuItemSource.nib(nib: nib)
        self.parchmentView?.font = AppFonts.Regular.withSize(16.0)
        self.parchmentView?.selectedFont = AppFonts.SemiBold.withSize(16.0)
        self.parchmentView?.indicatorColor = AppColors.themeGreen
        self.parchmentView?.selectedTextColor = AppColors.themeBlack
        self.dataContainerView.addSubview(self.parchmentView!.view)
        self.parchmentView?.dataSource = self
        self.parchmentView?.delegate = self
        self.parchmentView?.select(index: selectedIndex)
        
        self.parchmentView?.reloadData()
        self.parchmentView?.reloadMenu()
    }
    
    
    private func setBadgesOnAllCategories() {
        
        initiateFilterTabs()
        for (idx,tab) in self.allTabsStr.enumerated() {
            
            switch tab.lowercased() {
            case LocalizedString.Sort.localized.lowercased():
                filtersTabs[idx].isSelected = (HotelFilterVM.shared.sortUsing == HotelFilterVM.shared.defaultSortUsing) ? true : false
                
            case LocalizedString.Range.localized.lowercased():
                filtersTabs[idx].isSelected  = (HotelFilterVM.shared.distanceRange == HotelFilterVM.shared.defaultDistanceRange) ? true : false
                
            case LocalizedString.Price.localized.lowercased():
                if HotelFilterVM.shared.leftRangePrice != HotelFilterVM.shared.defaultLeftRangePrice {
                    filtersTabs[idx].isSelected =  false
                }
                else if HotelFilterVM.shared.rightRangePrice != HotelFilterVM.shared.defaultRightRangePrice {
                    filtersTabs[idx].isSelected =  false
                }
                else if HotelFilterVM.shared.priceType != HotelFilterVM.shared.defaultPriceType {
                    filtersTabs[idx].isSelected =  false
                }
                
            case LocalizedString.Ratings.localized.lowercased():
                
                
                let diff = HotelFilterVM.shared.ratingCount.difference(from: HotelFilterVM.shared.defaultRatingCount)
                if 1...4 ~= diff.count {
                    filtersTabs[idx].isSelected =  false
                }
                else if !HotelFilterVM.shared.tripAdvisorRatingCount.difference(from: HotelFilterVM.shared.defaultTripAdvisorRatingCount).isEmpty {
                    filtersTabs[idx].isSelected =  false
                }
                else if HotelFilterVM.shared.isIncludeUnrated != HotelFilterVM.shared.defaultIsIncludeUnrated {
                    filtersTabs[idx].isSelected =  false
                }
            case LocalizedString.Amenities.localized.lowercased():
                if !HotelFilterVM.shared.amenitites.difference(from: HotelFilterVM.shared.defaultAmenitites).isEmpty {
                    filtersTabs[idx].isSelected =  false
                }
                
            case LocalizedString.Room.localized.lowercased():
                if !HotelFilterVM.shared.roomMeal.difference(from: HotelFilterVM.shared.defaultRoomMeal).isEmpty {
                    filtersTabs[idx].isSelected =  false
                }
                else if !HotelFilterVM.shared.roomCancelation.difference(from: HotelFilterVM.shared.defaultRoomCancelation).isEmpty {
                    filtersTabs[idx].isSelected =  false
                }
                else if !HotelFilterVM.shared.roomOther.difference(from: HotelFilterVM.shared.defaultRoomOther).isEmpty {
                    filtersTabs[idx].isSelected =  false
                }
                
            default:
                printDebug("not useable case")
            }
        }
        self.setFilterButton()
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
