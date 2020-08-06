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
    func collectionViewContentOffset(offsetX: CGFloat)

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
    @IBOutlet weak var blurBackGroundView: UIView!
    @IBOutlet weak var filterContainerView: UIView!
    
    // MARK: - Private
    
    private var currentIndex: Int = 0
    
    // Parchment View
    fileprivate var parchmentView : PagingViewController?
    
    
    
    // MARK: - Variables
    var filtersTabs =  [MenuItem]()
    var selectedIndex: Int = HotelFilterVM.shared.lastSelectedIndex
    var isFilterApplied:Bool = false
    
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
        self.statusBarColor = AppColors.clear
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.statusBarColor = AppColors.clear
    }
    
    // MARK: - Overrider methods
    
    override func setupTexts() {
        self.clearAllButton.setTitle(LocalizedString.ClearAll.localized, for: .normal)
        self.doneButton.setTitle(LocalizedString.Done.localized, for: .normal)
        self.setNavigationTitle()
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
        blurBackGroundView.addBlurEffect(backgroundColor: AppColors.themeWhite.withAlphaComponent(0.85), style:  UIBlurEffect.Style.light, alpha: 1)
        filterContainerView.addBlurEffect(backgroundColor: AppColors.themeWhite.withAlphaComponent(0.85), style:  UIBlurEffect.Style.light, alpha: 1)

    }
    
    private func setNavigationTitle() {
        let navigationTitleText = HotelFilterVM.shared.totalHotelCount > 0 ? " \(HotelFilterVM.shared.filterHotelCount) of \(HotelFilterVM.shared.totalHotelCount) Results" : ""
        self.navigationTitleLabel.text = navigationTitleText
    }
    
    private func  setFilterButton() {
        self.isFilterApplied = false
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
        for i in 0..<(HotelFilterVM.shared.allTabsStr.count){
            let obj = MenuItem(title: HotelFilterVM.shared.allTabsStr[i], index: i, isSelected: true)
            filtersTabs.append(obj)
        }
    }
    
    private func show(animated: Bool) {
        UIView.animate(withDuration: animated ? AppConstants.kAnimationDuration : 0.0, animations: {
            self.mainContainerViewTopConstraint.constant = 0.0
            self.view.alpha = 1.0
            self.view.layoutIfNeeded()
        })
    }
    
    private func hide(animated: Bool, shouldRemove: Bool = false) {
        UIView.animate(withDuration: animated ? AppConstants.kAnimationDuration : 0.0, animations: {
            self.mainContainerViewTopConstraint.constant = -(self.mainContainerView.height)
            self.view.alpha = 0.0
            self.view.layoutIfNeeded()
        }, completion: { _ in
            if shouldRemove {
                self.removeFromParentVC
            }
        })
    }
    
    
    private func setupPagerView() {
        self.allChildVCs.removeAll()
//        self.selectedIndex = HotelFilterVM.shared.lastSelectedIndex
        
        for i in 0..<HotelFilterVM.shared.allTabsStr.count {
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
        //self.view.layoutIfNeeded()
        if let _ = self.parchmentView{
            self.parchmentView?.view.removeFromSuperview()
            self.parchmentView = nil
        }
        self.setBadgesOnAllCategories()
        setupParchmentPageController()
        
    }
    
    // Added to replace the existing page controller, added Hitesh Soni, 28-29Jan'2020
    private func setupParchmentPageController(){
        
        self.parchmentView = PagingViewController()
        self.parchmentView?.menuItemSpacing = 10.0
        self.parchmentView?.menuInsets = UIEdgeInsets(top: 0.0, left: 41.0, bottom: 0.0, right: 0.0)
        self.parchmentView?.menuItemSize = .sizeToFit(minWidth: 150, height: 52)
        self.parchmentView?.indicatorOptions = PagingIndicatorOptions.visible(height: 2, zIndex: Int.max, spacing: UIEdgeInsets(top: 0, left: 11.5, bottom: 0, right: 11.5), insets: UIEdgeInsets(top: 0, left: 0.0, bottom: 0, right: 0.0))
        self.parchmentView?.borderOptions = PagingBorderOptions.visible(
            height: 0.5,
            zIndex: Int.max - 1,
            insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        let nib = UINib(nibName: "MenuItemCollectionCell", bundle: nil)
//        self.parchmentView?.menuItemSource = PagingMenuItemSource.nib(nib: nib)
        self.parchmentView?.register(nib, for: MenuItem.self)
        self.parchmentView?.font = AppFonts.Regular.withSize(16.0)
        self.parchmentView?.selectedFont = AppFonts.SemiBold.withSize(16.0)
        self.parchmentView?.indicatorColor = AppColors.themeGreen
        self.parchmentView?.selectedTextColor = AppColors.themeBlack
       // self.parchmentView?.borderColor = AppColors.divider.color
        self.dataContainerView.addSubview(self.parchmentView!.view)
        self.parchmentView?.dataSource = self
        self.parchmentView?.delegate = self
        self.parchmentView?.sizeDelegate = self
        self.parchmentView?.select(index: selectedIndex)
        self.parchmentView?.reloadData()
        self.parchmentView?.reloadMenu()
        self.parchmentView?.menuBackgroundColor = UIColor.clear
        self.parchmentView?.collectionView.backgroundColor = UIColor.clear
        
    }
    
    
    private func setBadgesOnAllCategories() {
        
        initiateFilterTabs()
        for (idx,tab) in HotelFilterVM.shared.allTabsStr.enumerated() {
            
            switch tab.lowercased() {
            case LocalizedString.Sort.localized.lowercased():
                if HotelFilterVM.shared.isFilterAppliedForDestinetionFlow {
                    filtersTabs[idx].isSelected = (HotelFilterVM.shared.sortUsing == .DistanceNearestFirst(ascending: true)) ? true : false
                } else {
                    filtersTabs[idx].isSelected = (HotelFilterVM.shared.sortUsing == HotelFilterVM.shared.defaultSortUsing) ? true : false
                }
                
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
                let taDiff = HotelFilterVM.shared.tripAdvisorRatingCount.difference(from: HotelFilterVM.shared.defaultTripAdvisorRatingCount)
                if 1...5 ~= diff.count {
                    filtersTabs[idx].isSelected =  false
                }
                else if 1...5 ~= taDiff.count {
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
    
    private func saveAndApplyFilter() {
//        if UserInfo.hotelFilter == nil {
//            HotelFilterVM.shared.lastSelectedIndex = 0
//        }
        HotelFilterVM.shared.saveDataToUserDefaults()
        delegate?.doneButtonTapped()
        delegate?.collectionViewContentOffset(offsetX: self.parchmentView?.collectionView.contentOffset.x ?? 0)
    }
    
    // MARK: - IB Action
    
    @IBAction func clearAllButtonTapped(_ sender: Any) {
       // self.hide(animated: true, shouldRemove: true)
        delegate?.clearAllButtonTapped()
        self.updateFiltersTabs()
        self.allChildVCs.forEach { (viewController) in
            if let vc = viewController as? PriceVC {
                vc.setFilterValues()
            }
            else if let vc = viewController as? RangeVC {
                vc.setFilterValues()
            }
            else if let vc = viewController as? RatingVC {
                vc.setFilterValues()
            }
            else if let vc = viewController as? AmenitiesVC {
                vc.setFilterValues()
            }
            else if let vc = viewController as? RoomVC {
                vc.setFilterValues()
            }else if let vc = viewController as? SortVC {
                vc.setFilterValues()
            }
        }
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        saveAndApplyFilter()
        self.hide(animated: true, shouldRemove: true)
    }
    
    @objc func  outsideAreaTapped() {
        saveAndApplyFilter()
        self.hide(animated: true, shouldRemove: true)
        
    }
        
}

extension HotelFilterVC: HotelFilterVMDelegate {
    func updateHotelsCount() {
        self.setNavigationTitle()
    }
    
    func updateFiltersTabs() {
        printDebug("updateFiltersTabs")
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        perform(#selector(self.updateFilter), with: nil, afterDelay: 0.5)
    }
    
    @objc func updateFilter() {
        printDebug("updateFilter")
        self.setBadgesOnAllCategories()
        UIView.setAnimationsEnabled(false)
        UIView.animate(withDuration: 0, animations: {
            self.parchmentView?.reloadMenu()
        }) { (_) in
                    UIView.setAnimationsEnabled(true)
        }
        saveAndApplyFilter()
    }
}
