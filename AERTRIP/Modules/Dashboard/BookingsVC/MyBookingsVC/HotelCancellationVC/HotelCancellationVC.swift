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
            self.hotelCancellationTableView.contentInset = UIEdgeInsets(top: 2.0, left: 0.0, bottom: 0.0, right: 0.0)
        }
    }
    @IBOutlet weak var cancellationButtonOutlet: UIButton!
    
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
    }
    
    override func setupColors() {
        self.cancellationButtonOutlet.addGredient(isVertical: false, cornerRadius: 0.0, colors: [AppColors.themeGreen, AppColors.shadowBlue])
    }
    
    override func setupTexts() {
        self.cancellationButtonOutlet.setTitle(LocalizedString.Cancellation.localized, for: .normal)
    }
    
    override func setupFonts() {
        self.cancellationButtonOutlet.titleLabel?.font = AppFonts.SemiBold.withSize(20.0)
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
    
    //MARK:- IBActions
    //MARK:===========
    @IBAction func cancellationButtonAction(_ sender: UIButton) {
        printDebug(cancellationButtonOutlet.constraints)
    }
}
