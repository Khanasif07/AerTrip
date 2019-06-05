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
    let viewModel = RequestReschedulingVM()
    
    //MARK:- IBOutlets
    //MARK:===========
    @IBOutlet weak var topNavBar: BookingTopNavBarWithSubtitle!
    @IBOutlet weak var hotelCancellationTableView: UITableView! {
        didSet {
            self.hotelCancellationTableView.contentInset = UIEdgeInsets(top: 2.0, left: 0.0, bottom: 0.0, right: 0.0)
            self.hotelCancellationTableView.estimatedRowHeight = UITableView.automaticDimension
            //            self.reschedulingTableView.rowHeight = UITableView.automaticDimension
        }
    }
    @IBOutlet weak var cancelButtonOutlet: UIButton!
    
    //MARK:- LifeCycle
    //MARK:===========
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func initialSetup() {
        self.topNavBar.configureView(title: LocalizedString.Cancellation.localized, subTitle: LocalizedString.SelectHotelOrRoomsForCancellation.localized, isleftButton: false, isRightButton: true)
        self.viewModel.getSectionData()
        self.registerXibs()
        self.hotelCancellationTableView.delegate = self
        self.hotelCancellationTableView.dataSource = self
        self.topNavBar.delegate = self
    }
    
    override func setupColors() {
        self.cancelButtonOutlet.addGredient(isVertical: false, cornerRadius: 0.0, colors: [AppColors.themeGreen, AppColors.shadowBlue])
    }
    
    override func setupTexts() {
        self.cancelButtonOutlet.setTitle(LocalizedString.RequestRescheduling.localized, for: .normal)
    }
    
    override func setupFonts() {
        self.cancelButtonOutlet.titleLabel?.font = AppFonts.SemiBold.withSize(20.0)
    }
    
    //MARK:- Functions
    //MARK:===========
    private func registerXibs() {
        self.hotelCancellationTableView.registerCell(nibName: ParallelLabelsTableViewCell.reusableIdentifier)
        self.hotelCancellationTableView.registerCell(nibName: SelectDateTableViewCell.reusableIdentifier)
        self.hotelCancellationTableView.registerCell(nibName: HCSpecialRequestTextfieldCell.reusableIdentifier)
        self.hotelCancellationTableView.registerCell(nibName: EmptyTableViewCell.reusableIdentifier)
        self.hotelCancellationTableView.registerCell(nibName: CustomerContactCellTableViewCell.reusableIdentifier)
    }
    
    internal func heightForRow(_ tableView: UITableView, indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return 35.0
        }
        return UITableView.automaticDimension
    }
    
    //MARK:- IBActions
    //MARK:===========
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        printDebug(cancelButtonOutlet.constraints)
    }
}
