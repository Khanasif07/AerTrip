//
//  FavouriteHotelsVC.swift
//  AERTRIP
//
//  Created by Admin on 07/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit
import Foundation
import Parchment

class FavouriteHotelsVC: BaseVC {
    
    //MARK:- IBOutlets
    //MARK:-
    
    @IBOutlet weak var dataContainerView: UIView!
    @IBOutlet weak var shimmerView: UIView!
    @IBOutlet weak var topNavView: TopNavigationView!
    
    
    //MARK:- Properties
    //MARK:- Public
    private(set) var viewModel = FavouriteHotelsVM()
    internal var currentIndex: Int = 0
    private let selectedIndex:Int = 0
    
    //==============
    // Parchment View
    fileprivate var parchmentView : PagingViewController?
    
    
    private lazy var emptyView: EmptyScreenView = {
        let newEmptyView = EmptyScreenView()
        newEmptyView.vType = .hotelPreferences
        return newEmptyView
    }()
    
    internal var allChildVCs: [FavouriteHotelsListVC] = [FavouriteHotelsListVC]()
    
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
        self.parchmentView?.view.frame = self.dataContainerView.bounds
        self.parchmentView?.loadViewIfNeeded()
        self.shimmerView.frame = self.dataContainerView.bounds
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
       self.topNavView.configureFirstRightButton(normalImage: AppImages.greenAdd, selectedImage: AppImages.greenAdd)
       // self.setUpViewPager()
    }
    
    private func setUpViewPager() {
        if self.viewModel.hotels.isEmpty {
            self.allChildVCs.removeAll()
        } else {
            self.currentIndex = 0
            self.emptyView.removeFromSuperview()
            self.shimmerView.removeFromSuperview()
            self.allChildVCs.removeAll()
            for idx in 0..<self.viewModel.hotels.count {
                let vc = FavouriteHotelsListVC.instantiate(fromAppStoryboard: .HotelPreferences)
                vc.delegate = self
                var hotels = self.viewModel.hotels[idx]
                hotels.holetList.sort(by: { $0.preferenceId < $1.preferenceId })
                vc.viewModel.forCity = hotels

                self.allChildVCs.append(vc)
            }
            self.view.layoutIfNeeded()
            if let _ = self.parchmentView{
                self.parchmentView?.view.removeFromSuperview()
                self.parchmentView = nil
            }
            setupParchmentPageController()
        }
    }
  
    // Added to replace the existing page controller, added Hitesh Soni, 28-29Jan'2020
       private func setupParchmentPageController(){
           
        self.parchmentView = PagingViewController()
           self.parchmentView?.menuItemSpacing = 40.0
           self.parchmentView?.menuInsets = UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.0, right: 16.0)
           self.parchmentView?.menuItemSize = .sizeToFit(minWidth: 150, height: 51)
           self.parchmentView?.indicatorOptions = PagingIndicatorOptions.visible(height: 2, zIndex: Int.max, spacing: UIEdgeInsets.zero, insets: UIEdgeInsets.zero)
           self.parchmentView?.borderOptions = PagingBorderOptions.visible(
                                           height: 0,
                                           zIndex: Int.max - 1,
                                           insets: UIEdgeInsets.zero)
            let nib = UINib(nibName: "MenuItemCollectionCell", bundle: nil)
            self.parchmentView?.register(nib, for: MenuItem.self)
           self.parchmentView?.font = AppFonts.Regular.withSize(16.0)
           self.parchmentView?.selectedFont = AppFonts.SemiBold.withSize(16.0)
           self.parchmentView?.indicatorColor = AppColors.themeGreen
           self.parchmentView?.selectedTextColor = AppColors.themeBlack
           self.dataContainerView.addSubview(self.parchmentView!.view)
        
           self.parchmentView?.dataSource = self
           self.parchmentView?.delegate = self
           self.parchmentView?.sizeDelegate = self
           self.parchmentView?.select(index: 0)
           
           self.parchmentView?.reloadData()
           self.parchmentView?.reloadMenu()
       }


    
    private func reloadList() {
        if self.viewModel.hotels.isEmpty {
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
//            self.allChildVCs[self.currentIndex].collectionView.reloadData()
            self.allChildVCs[self.currentIndex].collectionView.deleteItems(at: [IndexPath(item: forHotelAtIndex, section: 0)])
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
                self.viewModel.logFirebaseEvent(with: .RemoveAllHotels)
            }
        }
    }
}
