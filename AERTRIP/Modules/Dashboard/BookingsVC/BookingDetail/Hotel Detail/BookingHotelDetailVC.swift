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
    internal var completion: (() -> Void)? = nil
    
    // MARK: - Override methods
    
    override func initialSetup() {
        
        self.tableViewTopConstraint.constant = -navBarHeight
        self.registerXib()
        self.hotelDetailTableView.dataSource = self
        self.hotelDetailTableView.delegate = self
        self.hotelDetailTableView.reloadData()
        self.hotelDetailTableView.backgroundColor = AppColors.themeGray04
        self.configureNavBar()
        if self.viewModel.bookingDetail == nil {
            self.hotelDetailTableView.backgroundColor = AppColors.themeWhite
            self.viewModel.getBookingDetail()
        }
        
        self.completion = { [weak self] in
            self?.hotelDetailTableView.reloadData()
            self?.viewModel.getBookingDetail()
        }
    }
    
    override func bindViewModel() {
        self.viewModel.delegate = self
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
        self.hotelDetailTableView.registerCell(nibName: BookingHotelsDetailsTravellerTableCell.reusableIdentifier)
        
        self.hotelDetailTableView.register(UINib(nibName: self.footerViewIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: self.footerViewIdentifier)
        
        self.hotelDetailTableView.registerCell(nibName: HotelDetailsLoaderTableViewCell.reusableIdentifier)

    }
    
    // configure nav bar
    private func configureNavBar() {
        self.topNavBarHeightConstraint.constant = navBarHeight
        self.topNavigationView.configureNavBar(title: "", isLeftButton: false, isFirstRightButton: true, isSecondRightButton: false,isDivider: false, backgroundType: .blurAnimatedView(isDark: false))
        
        self.topNavigationView.configureFirstRightButton(normalImage: #imageLiteral(resourceName: "CancelButtonWhite"), selectedImage: #imageLiteral(resourceName: "black_cross"), normalTitle: nil, selectedTitle: nil, normalColor: nil, selectedColor: nil)
        self.topNavigationView.firstRightButton.imageEdgeInsets = UIEdgeInsets(top: 2, left: 0, bottom: 0, right: 0)
        self.topNavigationView.firstRightButtonTrailingConstraint.constant = -3
        //self.topNavigationView.configureLeftButton(normalImage: UIImage(named: "whiteBackIcon"), selectedImage: UIImage(named: "whiteBackIcon"))
        self.topNavigationView.delegate = self
        self.topNavigationView.backgroundColor = .clear
        self.view.bringSubviewToFront(self.topNavigationView)
    }
}
extension BookingHotelDetailVC: BookingHotelDetailVMDelgate {
    func getHotelDetailsSuccess() {
        self.hotelDetailTableView.backgroundColor = AppColors.themeGray04
        self.hotelDetailTableView.reloadData()
    }
    
    func getHotelDetailsFail() {
        let index = IndexPath(row: 2, section: 0)
        if let cell = self.hotelDetailTableView.cellForRow(at: index) as? HotelDetailsLoaderTableViewCell {
            cell.activityIndicator.stopAnimating()
            delay(seconds: AppConstants.kAnimationDuration) {
                cell.activityIndicator.isHidden = true
            }
        }
        AppToast.default.showToastMessage(message: LocalizedString.InformationUnavailable.localized, onViewController: self, buttonTitle: LocalizedString.ReloadResults.localized, buttonAction: self.completion)
    }
    
    
}
