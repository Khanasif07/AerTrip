//
//  RequestReschedulingVC.swift
//  AERTRIP
//
//  Created by Admin on 03/06/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class RequestReschedulingVC: BaseVC {

    //MARK:- Variables
    //MARK:===========
    let viewModel = RequestReschedulingVM()
    
    //MARK:- IBOutlets
    //MARK:===========
    @IBOutlet weak var topNavBar: BookingTopNavBarWithSubtitle!
    @IBOutlet weak var reschedulingTableView: UITableView! {
        didSet {
            self.reschedulingTableView.contentInset = UIEdgeInsets(top: 2.0, left: 0.0, bottom: 0.0, right: 0.0)
            self.reschedulingTableView.estimatedRowHeight = UITableView.automaticDimension
//            self.reschedulingTableView.rowHeight = UITableView.automaticDimension
        }
    }
    @IBOutlet weak var requestReschedulingBtnOutlet: UIButton!
    
    //MARK:- LifeCycle
    //MARK:===========
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func initialSetup() {
        self.topNavBar.configureView(title: LocalizedString.newDate.localized, subTitle: LocalizedString.selectNewDepartingDate.localized, isleftButton: true, isRightButton: false)
        self.viewModel.getSectionData()
        self.registerXibs()
        self.reschedulingTableView.delegate = self
        self.reschedulingTableView.dataSource = self
        self.topNavBar.delegate = self
    }
    
    override func setupColors() {
        self.requestReschedulingBtnOutlet.addGredient(isVertical: false, cornerRadius: 0.0, colors: [AppColors.themeGreen, AppColors.shadowBlue])
    }
    
    override func setupTexts() {
        self.requestReschedulingBtnOutlet.setTitle(LocalizedString.RequestRescheduling.localized, for: .normal)
    }
    
    override func setupFonts() {
        self.requestReschedulingBtnOutlet.titleLabel?.font = AppFonts.SemiBold.withSize(20.0)
    }
    
    //MARK:- Functions
    //MARK:===========
    private func registerXibs() {
        self.reschedulingTableView.registerCell(nibName: ParallelLabelsTableViewCell.reusableIdentifier)
        self.reschedulingTableView.registerCell(nibName: SelectDateTableViewCell.reusableIdentifier)
        self.reschedulingTableView.registerCell(nibName: HCSpecialRequestTextfieldCell.reusableIdentifier)
        self.reschedulingTableView.registerCell(nibName: EmptyTableViewCell.reusableIdentifier)
        self.reschedulingTableView.registerCell(nibName: CustomerContactCellTableViewCell.reusableIdentifier)
    }
    
    internal func heightForRow(_ tableView: UITableView, indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return 35.0
        }
        return UITableView.automaticDimension
    }
    
    //MARK:- IBActions
    //MARK:===========
    @IBAction func requestReschedulingBtnAction(_ sender: UIButton) {
        printDebug(requestReschedulingBtnOutlet.constraints)
    }
}