//
//  FavouriteHotelsVC.swift
//  AERTRIP
//
//  Created by Admin on 07/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit
import Foundation
//import PKCategoryView

class FavouriteHotelsVC: BaseVC {
    
    //MARK:- IBOutlets
    //MARK:-
    
    @IBOutlet weak var dataContainerView: UIView!
    @IBOutlet weak var shimmerView: UIView!
    @IBOutlet weak var topNavView: TopNavigationView!
    
    
    //MARK:- Properties
    //MARK:- Public
    private(set) var viewModel = FavouriteHotelsVM()
    private var currentIndex: Int = 0
    private let selectedIndex:Int = 0
    
    //==============
    var viewPager: WormTabStrip!
    
    //==============
    
    var tabs:[FavouriteHotelsListVC] = []
    
    private lazy var emptyView: EmptyScreenView = {
        let newEmptyView = EmptyScreenView()
        newEmptyView.vType = .hotelPreferences
        return newEmptyView
    }()
    
    //fileprivate weak var categoryView: PKCategoryView!
    
    
    
    
    
    private var allChildVCs: [FavouriteHotelsListVC] = [FavouriteHotelsListVC]()
    
    //MARK:- Private
    
    //MARK:- ViewLifeCycle
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.webserviceForGetHotelPreferenceList()
        // Do any additional setup after loading the view.
        self.initialSetups()
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        //        self.categoryView?.frame = self.dataContainerView.bounds
        //        self.categoryView?.layoutIfNeeded()
    }
    
    override func bindViewModel() {
        self.viewModel.delegate = self
    }
    
    override func dataChanged(_ note: Notification) {
        if let _ = note.object as? SearchFavouriteHotelsVC {
            self.viewModel.webserviceForGetHotelPreferenceList()
        }
    }
    
    //MARK:- Methods
    //MARK:- Private
    private func initialSetups() {
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        
        self.topNavView.delegate = self
        self.topNavView.configureNavBar(title: LocalizedString.FavouriteHotels.localized, isLeftButton: true, isFirstRightButton: true, isSecondRightButton: false, isDivider: false)
        self.topNavView.configureFirstRightButton(normalImage: #imageLiteral(resourceName: "addHotel"), selectedImage: #imageLiteral(resourceName: "addHotel"))
        self.setUpViewPager()
    }
    
    private func setUpViewPager() {
        if self.viewModel.hotels.isEmpty {
            self.allChildVCs.removeAll()
        } else {
            self.currentIndex = 0
            self.emptyView.removeFromSuperview()
            self.shimmerView.removeFromSuperview()
            self.allChildVCs.removeAll()
            if self.viewPager != nil {
                self.viewPager.removeFromSuperview()
            }
            for idx in 0..<self.viewModel.hotels.count {
                let vc = FavouriteHotelsListVC.instantiate(fromAppStoryboard: .HotelPreferences)
                vc.delegate = self
                let hotels = self.viewModel.hotels[idx]
                vc.viewModel.forCity = hotels
                
                self.allChildVCs.append(vc)
            }
            self.view.layoutIfNeeded()
            viewPager = WormTabStrip(frame: self.dataContainerView.bounds)
            self.dataContainerView.addSubview(viewPager)
            viewPager.delegate = self
            viewPager.eyStyle.isWormEnable = true
            viewPager.eyStyle.wormStyel = .LINE
            viewPager.eyStyle.kHeightOfWorm = 2.0
            viewPager.eyStyle.kHeightOfDivider = 0.0
            viewPager.eyStyle.kPaddingOfIndicator = 0.0
            viewPager.eyStyle.WormColor =  AppColors.themeGreen
            viewPager.eyStyle.dividerBackgroundColor = .clear
            viewPager.eyStyle.tabItemSelectedColor = AppColors.themeBlack
            viewPager.eyStyle.tabItemDefaultColor = AppColors.themeBlack.withAlphaComponent(1.0)
            viewPager.eyStyle.topScrollViewBackgroundColor = UIColor.white
            viewPager.eyStyle.tabItemDefaultFont = AppFonts.Regular.withSize(16.0)
            viewPager.eyStyle.tabItemSelectedFont = AppFonts.SemiBold.withSize(16.0)
            viewPager.eyStyle.kHeightOfTopScrollView = 51.0
            viewPager.eyStyle.kPaddingOfIndicator = 8.0
            viewPager.eyStyle.spacingBetweenTabs = 5.0
            viewPager.eyStyle.contentScrollViewBackgroundColor = .clear
            viewPager.currentTabIndex = 0
            viewPager.buildUI()
        }
    }
    
    //    private func setupPagerView() {
    //        self.currentIndex = 0
    //
    //        if self.viewModel.hotels.isEmpty {
    //            self.emptyView.frame = CGRect(x: 0.0, y: 0.0, width: self.dataContainerView.width, height: self.dataContainerView.height)
    //            self.dataContainerView.addSubview(self.emptyView)
    //        }
    //        else {
    //            self.emptyView.removeFromSuperview()
    //            self.shimmerView.removeFromSuperview()
    //            var style = PKCategoryViewConfiguration()
    //            style.navBarHeight = 51.0
    //            style.interItemSpace = 5.0
    //            style.itemPadding = 8.0
    //            style.isNavBarScrollEnabled = true
    //            style.isEmbeddedToView = true
    //            style.showBottomSeparator = true
    //            style.bottomSeparatorColor = AppColors.divider.color
    //            style.defaultFont = AppFonts.Regular.withSize(16.0)
    //            style.selectedFont = AppFonts.SemiBold.withSize(16.0)
    //            style.indicatorColor = AppColors.themeGreen
    //            style.indicatorHeight = 2.0
    //            style.normalColor = AppColors.themeBlack
    //            style.selectedColor = AppColors.themeBlack
    //
    //            self.allChildVCs.removeAll()
    //
    //            for idx in 0..<self.viewModel.hotels.count {
    //                let vc = FavouriteHotelsListVC.instantiate(fromAppStoryboard: .HotelPreferences)
    //                vc.delegate = self
    //                let hotels = self.viewModel.hotels[idx]
    //                vc.viewModel.forCity = hotels
    //
    //                self.allChildVCs.append(vc)
    //            }
    //
    //            if let _ = self.categoryView {
    //                self.categoryView.removeFromSuperview()
    //                self.categoryView = nil
    //            }
    //            let categoryView = PKCategoryView(frame: self.dataContainerView.bounds, categories: self.viewModel.allTabs, childVCs: self.allChildVCs, configuration: style, parentVC: self)
    //            self.dataContainerView.addSubview(categoryView)
    //            self.categoryView = categoryView
    //        }
    //
    //    }
    //    func setUpTabs(){
    //        for idx in 0..<self.viewModel.hotels.count {
    //            let vc = FavouriteHotelsListVC.instantiate(fromAppStoryboard: .HotelPreferences)
    //            let hotels = self.viewModel.hotels[idx]
    //            vc.viewModel.forCity = hotels
    //
    //            self.tabs.append(vc)
    //        }
    //    }
    
    private func reloadList() {
        //self.setupPagerView()
        if self.viewModel.hotels.isEmpty {
           self.viewPager.removeFromSuperview()
           self.emptyView.removeFromSuperview()
           setEmptyState()
        } else {
             self.setUpViewPager()
        }
    }
    
    //MARK:- Public
}


extension FavouriteHotelsVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        AppFlowManager.default.popViewController(animated: true)
    }
    
    func topNavBarFirstRightButtonAction(_ sender: UIButton) {
        AppFlowManager.default.moveToSearchFavouriteHotelsVC()
    }
}

//extension FavouriteHotelsVC: PKCategoryViewDelegate {
//    func categoryView(_ view: PKCategoryView, willSwitchIndexFrom fromIndex: Int, to toIndex: Int) {
//        self.currentIndex = toIndex
//    }
//
//    func categoryView(_ view: PKCategoryView, didSwitchIndexTo toIndex: Int) {
//        self.currentIndex = toIndex
//        self.allChildVCs[toIndex].delegate = self
//    }
//
//
//}

extension FavouriteHotelsVC: ViewAllHotelsVMDelegate {
    func willGetHotelPreferenceList() {
        self.dataContainerView.addSubview(self.shimmerView)
    }
    
    func getHotelPreferenceListSuccess() {
        self.shimmerView.removeFromSuperview()
        setEmptyState()
        self.reloadList()
    }
    
    func getHotelPreferenceListFail() {
        self.shimmerView.removeFromSuperview()
        setEmptyState()
    }
    
    func setEmptyState() {
        if self.viewModel.hotels.isEmpty {
            self.emptyView.frame = CGRect(x: 0.0, y: 0.0, width: self.dataContainerView.width, height: self.dataContainerView.height)
            self.dataContainerView.addSubview(self.emptyView)
        }
    }
    
    func willUpdateFavourite() {
        
    }
    
    func updateFavouriteSuccess() {
        self.viewModel.removeAllHotels(forCityIndex: self.currentIndex)
        self.sendDataChangedNotification(data: self)
        self.reloadList()
    }
    
    func updateFavouriteFail() {
        
    }
}

extension FavouriteHotelsVC: FavouriteHotelsListVCDelegate {
    func updatedFavourite(forCity: CityHotels, forHotelAtIndex: Int) {
        
        if forCity.holetList.count > 1 {
            self.viewModel.removeHotel(forCity: forCity, cityIndex: self.currentIndex, forHotelAtIndex: forHotelAtIndex)
            //reload list at current city index
            self.allChildVCs[self.currentIndex].viewModel.forCity = self.viewModel.hotels[self.currentIndex]
            self.allChildVCs[self.currentIndex].collectionView.reloadData()
        }
        else {
            //reload complete list
            self.updateFavouriteSuccess()
            // self.sendDataChangedNotification(data: self)
        }
    }
    
    
    func removeAllForCurrentPage() {
        let buttons = AppGlobals.shared.getPKAlertButtons(forTitles: [LocalizedString.Remove.localized], colors: [AppColors.themeRed])
        _ = PKAlertController.default.presentActionSheet(nil, message: "\(LocalizedString.DoYouWishToRemoveAllHotelsFrom.localized) \(self.viewModel.hotels[self.currentIndex].cityName)?", sourceView: self.view, alertButtons: buttons, cancelButton: AppGlobals.shared.pKAlertCancelButton) { (alert, index) in
            if index == 0 {
                self.viewModel.updateFavourite(forHotels: self.viewModel.hotels[self.currentIndex].holetList)
            }
        }
    }
}


extension FavouriteHotelsVC: WormTabStripDelegate {
    func WTSNumberOfTabs() -> Int {
        return self.viewModel.hotels.count
    }
    
    func WTSViewOfTab(index: Int) -> UIView {
        return self.allChildVCs[index].view
    }
    
    func WTSTitleForTab(index: Int) -> String {
        self.viewModel.hotels[index].cityName
    }
    
    
    func WTSReachedLeftEdge(panParam: UIPanGestureRecognizer) {
    }
    
    func WTSReachedRightEdge(panParam: UIPanGestureRecognizer) {
        
    }
    
    func WTSSelectedTabIndex(index: Int) {
        viewPager.currentTabIndex = index
        self.currentIndex = index
    }
    
}
