//
//  BookingFlightDetailVC.swift
//  AERTRIP
//
//  Created by apple on 09/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit
import Parchment

enum BookingDetailType {
    case flightInfo
    case baggage
    case fareInfo
}


class BookingFlightDetailVC: BaseVC {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var topNavigationView: TopNavigationView!
    @IBOutlet weak var containerView: UIView!
    
    // MARK: - Variables
    private var currentIndex: Int = 0
    private var allTabsStr: [String] = []
    // Parchment View
    fileprivate var parchmentView : PagingViewController?
    private var allChildVCs :[UIViewController] = []
    
    let viewModel = BookingDetailVM()
    
    override func initialSetup() {
        self.view.layoutIfNeeded()
        //self.viewModel.getBookingFees()
        configureNavBar()
        delay(seconds: 0.1) {[weak self] in
        
        guard let self = self else  {return}
            self.setUpViewPager()
        }
    }
        
    override func bindViewModel() {
        self.viewModel.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        self.parchmentView?.view.frame = self.containerView.bounds
        self.parchmentView?.loadViewIfNeeded()
    }
    
    private func configureNavBar() {
        
        self.topNavigationView.configureNavBar(title: "", isLeftButton: true, isFirstRightButton: false, isSecondRightButton: false, isDivider: false)
        self.topNavigationView.navTitleLabel.attributedText = self.viewModel.tripStr
        self.topNavigationView.delegate = self
        self.topNavigationView.dividerView.isHidden = true
    }
    
    // Asif Change
    private func setUpViewPager() {
        self.currentIndex = 0
        self.allChildVCs.removeAll()
        self.allTabsStr.removeAll()
        self.allTabsStr.append(LocalizedString.FlightInfo.localized)
        self.allTabsStr.append(LocalizedString.Baggage.localized)
        self.allTabsStr.append(LocalizedString.FareInfo.localized)
        
        let flightInfoVC = FlightInfoVC.instantiate(fromAppStoryboard: .Bookings)
        flightInfoVC.viewModel.bookingDetail = self.viewModel.bookingDetail
        self.allChildVCs.append(flightInfoVC)
        
        let flightBaggageInfoVC = FlightBaggageInfoVC.instantiate(fromAppStoryboard: .Bookings)
        flightBaggageInfoVC.viewModel.bookingDetail = self.viewModel.bookingDetail
        self.allChildVCs.append(flightBaggageInfoVC)
        
        let flightFareInfoVC = FlightFareInfoVC.instantiate(fromAppStoryboard: .Bookings)
        flightFareInfoVC.viewModel.bookingDetail = self.viewModel.bookingDetail
        self.allChildVCs.append(flightFareInfoVC)
        
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
        self.parchmentView?.menuItemSpacing =  (UIDevice.screenWidth - 273.0)/2
        self.parchmentView?.menuInsets = UIEdgeInsets(top: 0.0, left:  35.0, bottom: 0.0, right:   35)
        self.parchmentView?.indicatorOptions = PagingIndicatorOptions.visible(height: 2, zIndex: Int.max, spacing: UIEdgeInsets.zero, insets: UIEdgeInsets.zero)
        self.parchmentView?.menuItemSize = .sizeToFit(minWidth: 150, height: 50)
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
        self.containerView.addSubview(self.parchmentView!.view)
        
        self.parchmentView?.dataSource = self
        self.parchmentView?.delegate = self
        self.parchmentView?.sizeDelegate = self
        self.parchmentView?.select(index: 0)
        
        self.parchmentView?.reloadData()
        self.parchmentView?.reloadMenu()
        
        self.parchmentView?.menuBackgroundColor = UIColor.clear
        self.parchmentView?.collectionView.backgroundColor = UIColor.clear
    }
}


// MARK: - Top Navigation View Delegate

extension BookingFlightDetailVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        AppFlowManager.default.mainNavigationController.popViewController(animated: true)
    }
}



// MARK:- PagingViewController DataSource
extension BookingFlightDetailVC : PagingViewControllerDataSource , PagingViewControllerDelegate, PagingViewControllerSizeDelegate {
    
    func numberOfViewControllers(in pagingViewController: PagingViewController) -> Int{
        self.allTabsStr.count
    }
    
    func pagingViewController(_ pagingViewController: PagingViewController, viewControllerAt index: Int) -> UIViewController {
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
        
        if let pagingIndexItem = pagingItem as? MenuItem {
            self.currentIndex = pagingIndexItem.index
        }
    }
}
extension BookingFlightDetailVC: BookingDetailVMDelegate {
    func willGetBookingFees() {}

    func getBookingFeesSuccess() {
    }

    func getBookingFeesFail() {}
}
