//
//  HCSpecialRequestsVC.swift
//  AERTRIP
//
//  Created by Admin on 14/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class HCSpecialRequestsVC: BaseVC {
    
    //Mark:- Variables
    //================
    let viewModel = HCSpecialRequestsVM()
    var selectedIndexPath: [IndexPath] = []
    let textFieldPlaceHolder: [String] = [LocalizedString.AirlineNameFlightNumberArrivalTime.localized,LocalizedString.SpecialRequestIfAny.localized]
    
    //Mark:- IBOutlets
    //================
    @IBOutlet weak var headerView: TopNavigationView!
    @IBOutlet weak var specialReqTableView: ATTableView! {
        didSet {
            self.specialReqTableView.delegate = self
            self.specialReqTableView.dataSource = self
            self.specialReqTableView.contentInset = UIEdgeInsets(top: 10.0, left: 0.0, bottom: 0.0, right: 0.0)
            self.specialReqTableView.estimatedRowHeight = UITableView.automaticDimension
            self.specialReqTableView.rowHeight = UITableView.automaticDimension
        }
    }
    
    //Mark:- LifeCycle
    //================
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func initialSetup() {
        self.headerViewSetUp()
        self.registerNibs()
    }
    
    override func setupFonts() {
        self.headerView.navTitleLabel.font = AppFonts.SemiBold.withSize(18.0)
    }
    
    override func setupColors() {
        self.headerView.navTitleLabel.textColor = AppColors.themeBlack
    }
    
    override func setupTexts() {
        self.headerView.navTitleLabel.text = LocalizedString.SpecialRequest.localized
    }
    
    //Mark:- Functions
    //================
    private func headerViewSetUp() {
        self.headerView.delegate = self
        self.headerView.configureNavBar(title: "", isLeftButton: true, isFirstRightButton: true, isSecondRightButton: false, isDivider: true)
        self.headerView.configureLeftButton(normalImage: nil, selectedImage: nil, normalTitle: LocalizedString.Cancel.localized, selectedTitle: LocalizedString.Cancel.localized, normalColor: AppColors.themeGreen, selectedColor: AppColors.themeGreen, font: AppFonts.Regular.withSize(18.0))
        self.headerView.configureFirstRightButton(normalImage: nil, selectedImage: nil, normalTitle: LocalizedString.Done.localized, selectedTitle: LocalizedString.Done.localized, normalColor: AppColors.themeGreen, selectedColor: AppColors.themeGreen, font: AppFonts.SemiBold.withSize(18.0))
    }
    
    private func registerNibs() {
        self.specialReqTableView.registerCell(nibName: RoomTableViewCell.reusableIdentifier)
        self.specialReqTableView.registerCell(nibName: HCSpecialRequestTextfieldCell.reusableIdentifier)
    }
    
    //Mark:- IBActions
}


extension HCSpecialRequestsVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.specialRequest.count + 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < self.viewModel.specialRequest.count {
            let cell = self.getRoomTableViewCell(tableView, cellForRowAt: indexPath)
            return cell
        } else {
            let cell = self.getTextFieldCell(tableView, cellForRowAt: indexPath)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let _ = tableView.cellForRow(at: indexPath) as? RoomTableViewCell {
            if !self.selectedIndexPath.contains(indexPath) {
                self.selectedIndexPath.append(indexPath)
            }
            else {
                self.selectedIndexPath.remove(object: indexPath)
            }
        }
        self.specialReqTableView.reloadData()
    }
}

extension HCSpecialRequestsVC {
    
    internal func getRoomTableViewCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RoomTableViewCell.reusableIdentifier, for: indexPath) as? RoomTableViewCell else { return UITableViewCell() }
        if self.selectedIndexPath.contains(indexPath) {
           cell.statusButton.setImage(#imageLiteral(resourceName: "tick"), for: .normal)
        } else {
            cell.statusButton.setImage(#imageLiteral(resourceName: "untick"), for: .normal)
        }
        cell.configCell(title: self.viewModel.specialRequest[indexPath.row])
        return cell
    }
    
    internal func getTextFieldCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HCSpecialRequestTextfieldCell.reusableIdentifier, for: indexPath) as? HCSpecialRequestTextfieldCell else { return UITableViewCell() }
        cell.delegate = self
        if indexPath.row == self.viewModel.specialRequest.count {
            cell.topDividerViewTopConstraints.constant = 17.0
            cell.configCell(placeHolderText: textFieldPlaceHolder[0])
            cell.topDividerView.isHidden = false
        } else {
            cell.topDividerViewTopConstraints.constant = 0.0
            cell.topDividerView.isHidden = true
            cell.configCell(placeHolderText: textFieldPlaceHolder[1])
        }
        return cell
    }
}

extension HCSpecialRequestsVC: TopNavigationViewDelegate {
    
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        //        AppFlowManager.default.popViewController(animated: true)
    }
    
    func topNavBarFirstRightButtonAction(_ sender: UIButton) {
        
    }
}

extension HCSpecialRequestsVC: SpecialReqAndAirLineInfoDelegate {
    func passingSpecialRequestAndAirLineInfo(infoText: String) {
        printDebug(infoText)
    }
}
