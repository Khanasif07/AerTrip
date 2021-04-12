//
//  HotelCancellationVC.swift
//  AERTRIP
//
//  Created by Admin on 05/06/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class HotelCancellationVC: BaseVC {
    
    //MARK:- Variables
    //MARK:===========
    let viewModel = HotelCancellationVM()
    var expandedIndexPaths = [IndexPath]() // Array for storing indexPath
    var presentingStatusBarStyle: UIStatusBarStyle = .darkContent, dismissalStatusBarStyle: UIStatusBarStyle = .darkContent
    
    //MARK:- IBOutlets
    //MARK:===========
    @IBOutlet weak var topNavBar: BookingTopNavBarWithSubtitle!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var hotelCancellationTableView: UITableView! {
        didSet {
            //self.hotelCancellationTableView.contentInset = UIEdgeInsets.zero
        }
    }
    @IBOutlet weak var cancellationButtonOutlet: UIButton!
    @IBOutlet weak var totalNetRefundContainerView: UIView!
    @IBOutlet weak var totalNetRefundTitleLabel: UILabel!
    @IBOutlet weak var totalNetRefundLabelAmountLabel: UILabel!
    
    //MARK:- LifeCycle
    //MARK:===========
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        statusBarStyle = presentingStatusBarStyle
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        statusBarStyle = dismissalStatusBarStyle
    }
    
    override func initialSetup() {
        self.hotelCancellationTableView.contentInset = UIEdgeInsets(top: topNavBar.height, left: 0.0, bottom: 0.0, right: 0.0)

        self.topNavBar.configureView(title: LocalizedString.Cancellation.localized, subTitle: LocalizedString.SelectHotelOrRoomsForCancellation.localized, isleftButton: false, isRightButton: true)
        self.registerXibs()
        self.hotelCancellationTableView.delegate = self
        self.hotelCancellationTableView.dataSource = self
        self.topNavBar.delegate = self
        self.cancellationButtonOutlet.isUserInteractionEnabled = false
        self.totalNetRefundContainerView.isHidden = true
        if self.viewModel.bookingDetail?.bookingDetail?.roomDetails.count == 1{
            self.updateSelectAll()
        }
        self.gradientView.addGredient(isVertical: false)
        
        FirebaseEventLogs.shared.logEventsWithoutParam(with: .MyBookingsHotelCancellation)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.gradientView.addGredient(isVertical: false)
    }
    
    override func setupColors() {
        self.cancellationButtonOutlet.addGredient(isVertical: false, cornerRadius: 0.0, colors: AppConstants.appthemeGradientColors)
        self.cancellationButtonOutlet.setTitleColor(AppColors.themeWhite.withAlphaComponent(0.5), for: .normal)
        self.hotelCancellationTableView.backgroundColor = AppColors.themeGray04
        self.totalNetRefundTitleLabel.textColor = AppColors.themeBlack
        self.totalNetRefundLabelAmountLabel.textColor = AppColors.themeBlack

    }
    
    override func setupTexts() {
        self.cancellationButtonOutlet.setTitle(LocalizedString.Continue.localized, for: .normal)
        self.totalNetRefundTitleLabel.text = LocalizedString.TotalNetRefund.localized
    }
    
    override func setupFonts() {
        self.cancellationButtonOutlet.titleLabel?.font = AppFonts.SemiBold.withSize(20.0)
        self.totalNetRefundTitleLabel.font = AppFonts.Regular.withSize(18.0)
        self.totalNetRefundLabelAmountLabel.font = AppFonts.Regular.withSize(18.0)
    }
    
    //MARK:- Functions
    //MARK:===========
    private func registerXibs() {
        self.hotelCancellationTableView.register(UINib(nibName: "BookingReschedulingHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "BookingReschedulingHeaderView")
        self.hotelCancellationTableView.registerCell(nibName: HotelCancellationRoomInfoTableViewCell.reusableIdentifier)
    }
    
    //MARK:- IBActions
    //MARK:===========
    @IBAction func cancellationButtonAction(_ sender: UIButton) {
        AppFlowManager.default.moveToReviewCancellationVC(onNavController: self.navigationController, usingAs: .hotelCancellationReview, legs: nil, selectedRooms: self.viewModel.selectedRooms, bookingDetails: self.viewModel.bookingDetail)
    }
}
