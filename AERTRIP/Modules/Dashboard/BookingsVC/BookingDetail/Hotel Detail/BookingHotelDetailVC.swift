//
//  BookingHotelDetailVC.swift
//  AERTRIP
//
//  Created by apple on 14/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class BookingHotelDetailVC: BaseVC {
    // MARK: - IBOutlet
    
    @IBOutlet weak var hotelDetailTableView: ATTableView!
    @IBOutlet weak var topNavigationView: TopNavigationView!
    
    // MARK: - Variables
    @IBOutlet weak var topNavBarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableViewTopConstraint: NSLayoutConstraint!
    
    let viewModel = BookingHotelDetailVM()
    let headerIdentifier = "BookingHDRoomDetailHeaderView"
    let footerViewIdentifier = "BookingInfoEmptyFooterView"
    private var navBarHeight: CGFloat {
        return AppFlowManager.default.mainNavigationController.navigationBar.bounds.height + AppFlowManager.default.safeAreaInsets.top
    }
    
    // MARK: - Override methods
    
    override func initialSetup() {
        
        self.tableViewTopConstraint.constant = -navBarHeight
        self.registerXib()
        self.hotelDetailTableView.dataSource = self
        self.hotelDetailTableView.delegate = self
        self.hotelDetailTableView.reloadData()
        self.configureNavBar()
    }
    
    // Register xib file
    private func registerXib() {
        self.hotelDetailTableView.registerCell(nibName: HotelDetailsImgSlideCell.reusableIdentifier)
        self.hotelDetailTableView.registerCell(nibName:
            HotelNameRatingTableViewCell.reusableIdentifier)
        self.hotelDetailTableView.registerCell(nibName: BookingCancellationPolicyTableViewCell.reusableIdentifier)
        self.hotelDetailTableView.registerCell(nibName: HotelInfoAddressCell.reusableIdentifier)
        
        self.hotelDetailTableView.registerCell(nibName: HotelDetailAmenitiesCell.reusableIdentifier)
        self.hotelDetailTableView.registerCell(nibName: TripAdvisorTableViewCell.reusableIdentifier)
        
        self.hotelDetailTableView.registerCell(nibName: BookingHDWebPhoneTableViewCell.reusableIdentifier)
        self.hotelDetailTableView.registerCell(nibName: BookingHDRoomDetailTableViewCell.reusableIdentifier)
        
        self.hotelDetailTableView.register(UINib(nibName: self.headerIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: self.headerIdentifier)
        self.hotelDetailTableView.registerCell(nibName: FareInfoNoteTableViewCell.reusableIdentifier)
        
        self.hotelDetailTableView.registerCell(nibName: BookingCheckinCheckOutTableViewCell.reusableIdentifier)
        self.hotelDetailTableView.registerCell(nibName: BookingTravellerTableViewCell.reusableIdentifier)
        
        self.hotelDetailTableView.register(UINib(nibName: self.footerViewIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: self.footerViewIdentifier)
    }
    
    // configure nav bar
    private func configureNavBar() {
        self.topNavBarHeightConstraint.constant = navBarHeight
        self.topNavigationView.configureNavBar(title: "", isLeftButton: true, isFirstRightButton: true, isSecondRightButton: false,isDivider: false, backgroundType: .blurAnimatedView(isDark: false))

        self.topNavigationView.configureLeftButton(normalImage: UIImage(named: "whiteBackIcon"), selectedImage: UIImage(named: "whiteBackIcon"))
        self.topNavigationView.delegate = self
        self.topNavigationView.backgroundColor = .clear
        self.view.bringSubviewToFront(self.topNavigationView)
    }
}
