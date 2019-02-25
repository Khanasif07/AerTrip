//
//  FavouriteHotelsVC.swift
//  AERTRIP
//
//  Created by Admin on 07/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class FavouriteHotelsVC: BaseVC {
    
    //MARK:- IBOutlets
    //MARK:-

    @IBOutlet weak var dataContainerView: UIView!
    @IBOutlet var shimmerView: UIView!
    @IBOutlet weak var topNavView: TopNavigationView!
    @IBOutlet weak var viewPagerNavBar: BmoViewPagerNavigationBar!
    @IBOutlet weak var viewPager: BmoViewPager!
    
    
    //MARK:- Properties
    //MARK:- Public
    private(set) var viewModel = FavouriteHotelsVM()
    private var currentIndex: Int = 0
    private let selectedIndex:Int = 0
    
    private lazy var emptyView: EmptyScreenView = {
        let newEmptyView = EmptyScreenView()
        newEmptyView.vType = .hotelPreferences
        return newEmptyView
    }()
    
    fileprivate weak var categoryView: ATCategoryView!
    
    private var allChildVCs: [FavouriteHotelsListVC] = [FavouriteHotelsListVC]()
    
    //MARK:- Private
    
    //MARK:- ViewLifeCycle
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.initialSetups()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.categoryView?.frame = self.dataContainerView.bounds
        self.categoryView?.layoutIfNeeded()
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
        
        self.currentIndex = 0
        self.topNavView.delegate = self
        self.topNavView.configureNavBar(title: LocalizedString.FavouriteHotels.localized, isLeftButton: true, isFirstRightButton: true, isSecondRightButton: false, isDivider: false)
        self.topNavView.configureFirstRightButton(normalImage: #imageLiteral(resourceName: "addHotel"), selectedImage: #imageLiteral(resourceName: "addHotel"))
        
        self.setupPagerView()
        self.viewModel.webserviceForGetHotelPreferenceList()
    }
    
    private func setupPagerView() {
        viewPager.dataSource = self
        viewPager.presentedPageIndex = 0
        viewPagerNavBar.viewPager = viewPager
        viewPagerNavBar.itemInterSpace = 20.0
        viewPagerNavBar.selectedFont = AppFonts.SemiBold.withSize(16.0)
        viewPagerNavBar.deSelectedFont = AppFonts.Regular.withSize(16.0)
    }
    
    private func reloadList() {
        if self.viewModel.hotels.isEmpty {
            self.emptyView.frame = CGRect(x: 0.0, y: 0.0, width: self.dataContainerView.width, height: self.dataContainerView.height)
            self.dataContainerView.addSubview(self.emptyView)
        }
        else {
            self.emptyView.removeFromSuperview()
            self.shimmerView.removeFromSuperview()
            self.allChildVCs.removeAll()
            self.viewPager.reloadData()
        }
    }
    
    //MARK:- Public
}


extension FavouriteHotelsVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        AppFlowManager.default.popViewController(animated: true)
    }
    
    func topNavBarFirstRightButtonAction(_ sender: UIButton) {
        AppFlowManager.default.moveToHotelSearchVC()
    }
}

extension FavouriteHotelsVC: ATCategoryNavBarDelegate {
    func categoryNavBar(_ navBar: ATCategoryNavBar, didSwitchIndexTo toIndex: Int) {
        self.currentIndex = toIndex
        self.allChildVCs[toIndex].delegate = self
    }
}

extension FavouriteHotelsVC: ViewAllHotelsVMDelegate {
    func willGetHotelPreferenceList() {
        
    }
    
    func getHotelPreferenceListSuccess() {
        self.shimmerView.removeFromSuperview()
        self.reloadList()
    }
    
    func getHotelPreferenceListFail() {
         self.shimmerView.removeFromSuperview()
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
        
        self.viewModel.removeHotel(forCity: forCity, cityIndex: self.currentIndex, forHotelAtIndex: forHotelAtIndex)
        if forCity.holetList.count > 1 {
            //reload list at current city index
            self.allChildVCs[self.currentIndex].viewModel.forCity = self.viewModel.hotels[self.currentIndex]
            self.allChildVCs[self.currentIndex].collectionView.reloadData()
        }
        else {
            //reload complete list
            self.updateFavouriteSuccess()
            self.sendDataChangedNotification(data: self)
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

extension FavouriteHotelsVC: BmoViewPagerDataSource {
    func bmoViewPagerDataSourceNumberOfPage(in viewPager: BmoViewPager) -> Int {
        return self.viewModel.hotels.count
    }
    
    func bmoViewPagerDataSourceNaviagtionBarItemTitle(_ viewPager: BmoViewPager, navigationBar: BmoViewPagerNavigationBar, forPageListAt page: Int) -> String? {
        
        return self.viewModel.hotels[page].cityName
    }
    
    func bmoViewPagerDataSourceNaviagtionBarItemHighlightedBackgroundView(_ viewPager: BmoViewPager, navigationBar: BmoViewPagerNavigationBar, forPageListAt page: Int) -> UIView? {
        let view = ATUnderLineView()
        view.lineWidth = 2.0
        view.margin = UIEdgeInsets(top: 0.0, left: viewPagerNavBar.itemInterSpace, bottom: 0.0, right: viewPagerNavBar.itemInterSpace)
        view.strokeColor = AppColors.themeGreen
        return view
    }

    func bmoViewPagerDataSource(_ viewPager: BmoViewPager, viewControllerForPageAt page: Int) -> UIViewController {
        
        if self.allChildVCs.count > page {
            let vc = self.allChildVCs[page]
            vc.viewModel.forCity = self.viewModel.hotels[page]
            return vc
        }
        else {
            let vc = FavouriteHotelsListVC.instantiate(fromAppStoryboard: .HotelPreferences)
            vc.delegate = self
            vc.viewModel.forCity = self.viewModel.hotels[page]
            self.allChildVCs.append(vc)
            return vc
        }
    }
}

