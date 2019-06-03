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
    
    private func heightForRow(_ tableView: UITableView, indexPath: IndexPath) -> CGFloat {
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

//MARK:- Extensions
//MARK:============

extension RequestReschedulingVC {
    
    func getFlightDetailsCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ParallelLabelsTableViewCell.reusableIdentifier, for: indexPath) as? ParallelLabelsTableViewCell else { return UITableViewCell() }
        cell.configureCell(leftTitle: "Mumbai → Delhi", rightTitle: "3 Passengers", topConstraint: 12.0, bottomConstraint: 11.0, leftTitleFont: AppFonts.SemiBold.withSize(22.0), rightTitleFont: AppFonts.Regular.withSize(16.0), rightTitleTextColor: AppColors.themeGray40)
        return cell
    }
    
    func getSelectDateTableViewCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SelectDateTableViewCell.reusableIdentifier, for: indexPath) as? SelectDateTableViewCell else { return UITableViewCell() }
        return cell
    }
    
    func getPreferredFlightNoCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HCSpecialRequestTextfieldCell.reusableIdentifier, for: indexPath) as? HCSpecialRequestTextfieldCell else { return UITableViewCell() }
        cell.delegate = self
        cell.topDividerViewLeadingConstraints.constant = 16.0
        cell.bottomDividerViewLeadingConstraints.constant = 0.0
        cell.bottomDividerViewTrailingConstraints.constant = 0.0
        cell.containerViewHeightConstraint.constant = 60.0
        cell.configCell(placeHolderText: LocalizedString.preferredFlightNo.localized)
        return cell
    }
    
    func getEmptyTableCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EmptyTableViewCell.reusableIdentifier, for: indexPath) as? EmptyTableViewCell else { return UITableViewCell() }
        cell.backgroundColor = AppColors.themeGray20
        cell.topDividerView.isHidden = true
        return cell
    }
    
    func getCustomerContactCellTableViewCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomerContactCellTableViewCell.reusableIdentifier, for: indexPath) as? CustomerContactCellTableViewCell else { return UITableViewCell() }
        cell.backgroundColor = AppColors.themeGray20
        return cell
    }
    
    func getTotalRefundCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ParallelLabelsTableViewCell.reusableIdentifier, for: indexPath) as? ParallelLabelsTableViewCell else { return UITableViewCell() }
        cell.configureCell(leftTitle: "Total Net Refund", rightTitle: "₹ 1,47,000")
        return cell
    }

}

extension RequestReschedulingVC: UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.sectionData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.sectionData[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch self.viewModel.sectionData[indexPath.section][indexPath.row] {
        case .flightDetailsCell:
            return getFlightDetailsCell(tableView, indexPath: indexPath)
        case .selectDateCell:
            return getSelectDateTableViewCell(tableView, indexPath: indexPath)
        case .preferredFlightNoCell:
            return getPreferredFlightNoCell(tableView, indexPath: indexPath)
        case .emptyCell:
            return getEmptyTableCell(tableView, indexPath: indexPath)
        case .customerExecutiveCell:
            return getCustomerContactCellTableViewCell(tableView, indexPath: indexPath)
        case .totalNetRefundCell:
            return getTotalRefundCell(tableView, indexPath: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.heightForRow(tableView, indexPath: indexPath)
    }
}

extension RequestReschedulingVC: BookingTopNavBarWithSubtitleDelegate {
    
    func leftButtonAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension RequestReschedulingVC: HCSpecialRequestTextfieldCellDelegate {
    func didPassSpecialRequestAndAirLineText(infoText: String, indexPath: IndexPath) {
        printDebug(infoText)
        printDebug(indexPath)
    }
}
