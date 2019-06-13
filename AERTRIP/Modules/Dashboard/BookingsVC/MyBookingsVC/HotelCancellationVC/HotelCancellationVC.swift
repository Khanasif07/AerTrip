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
    
    //MARK:- IBOutlets
    //MARK:===========
    @IBOutlet weak var topNavBar: BookingTopNavBarWithSubtitle!
    @IBOutlet weak var hotelCancellationTableView: UITableView! {
        didSet {
            self.hotelCancellationTableView.contentInset = UIEdgeInsets.zero
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
    
    override func initialSetup() {
        self.topNavBar.configureView(title: LocalizedString.Cancellation.localized, subTitle: LocalizedString.SelectHotelOrRoomsForCancellation.localized, isleftButton: false, isRightButton: true)
        self.viewModel.getHotelData()
        self.registerXibs()
        self.hotelCancellationTableView.delegate = self
        self.hotelCancellationTableView.dataSource = self
        self.topNavBar.delegate = self
        self.cancellationButtonOutlet.isUserInteractionEnabled = false
        self.totalNetRefundContainerView.isHidden = true
    }
    
    override func setupColors() {
        self.cancellationButtonOutlet.addGredient(isVertical: false, cornerRadius: 0.0, colors: [AppColors.themeGreen, AppColors.shadowBlue])
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
    
    internal func allRoomIsSelectedOrNot() -> Bool {
        var isRoomSelected: Bool = false
        for room in self.viewModel.bookedHotelData {
            isRoomSelected = room.isChecked
            if !isRoomSelected {
                return false
            }
        }
        return isRoomSelected
    }
    
    internal func isAnyRoomSelected() {
        var isRoomSelected: Bool = false
        for room in self.viewModel.bookedHotelData {
            if room.isChecked {
                isRoomSelected = true
                break
            }
        }
        if isRoomSelected {
            self.cancellationButtonOutlet.setTitleColor(AppColors.themeWhite.withAlphaComponent(1.0), for: .normal)
            self.cancellationButtonOutlet.isUserInteractionEnabled = true
            self.totalNetRefundContainerView.isHidden = false
        } else {
            self.cancellationButtonOutlet.setTitleColor(AppColors.themeWhite.withAlphaComponent(0.5), for: .normal)
            self.cancellationButtonOutlet.isUserInteractionEnabled = false
            self.totalNetRefundContainerView.isHidden = true
        }
    }
    
    //MARK:- IBActions
    //MARK:===========
    @IBAction func cancellationButtonAction(_ sender: UIButton) {
        printDebug(cancellationButtonOutlet.constraints)
    }
}