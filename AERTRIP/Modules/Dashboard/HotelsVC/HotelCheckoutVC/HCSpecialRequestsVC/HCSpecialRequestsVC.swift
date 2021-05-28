//
//  HCSpecialRequestsVC.swift
//  AERTRIP
//
//  Created by Admin on 14/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol HCSpecialRequestsDelegate: class {
    func didPassSelectedRequestsId(ids: [Int], names: [String], other: String, specialRequest: String)
}

class HCSpecialRequestsVC: BaseVC {
    
    //Mark:- Variables
    //================
    internal let viewModel = HCSpecialRequestsVM()
    internal weak var delegate: HCSpecialRequestsDelegate?
    private let textFieldPlaceHolder: [String] = [LocalizedString.AirlineNameFlightNumberArrivalTime.localized,LocalizedString.SpecialRequestIfAny.localized]
    var footerView: UIView?
    
    //Mark:- IBOutlets
    //================
    @IBOutlet weak var headerView: TopNavigationView!
    @IBOutlet weak var specialReqTableView: ATTableView! {
        didSet {
            self.specialReqTableView.delegate = self
            self.specialReqTableView.dataSource = self
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
        self.specialReqTableView.contentInset = UIEdgeInsets(top: headerView.height + 10.0, left: 0.0, bottom: 10.0, right: 0.0)

        self.headerViewSetUp()
        self.footerViewSetUp()
        self.registerNibs()
    }
    
    override func setupFonts() {
        self.headerView.navTitleLabel.font = AppFonts.SemiBold.withSize(18.0)
    }
    
    override func setupColors() {
        self.headerView.navTitleLabel.textColor = AppColors.themeBlack
    }
    
    override func setupTexts() {
//        self.headerView.navTitleLabel.text = LocalizedString.SpecialRequest.localized
    }
    
    //Mark:- Functions
    //================
    private func footerViewSetUp() {
        self.footerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.width, height: 35.0))
        self.specialReqTableView.tableFooterView = self.footerView
    }
    
    private func headerViewSetUp() {
        self.headerView.delegate = self
        self.headerView.firstLeftButtonLeadingConst.constant = 7.0
        self.headerView.configureNavBar(title: LocalizedString.SpecialRequest.localized, isLeftButton: true, isFirstRightButton: true, isSecondRightButton: false, isDivider: true)
        self.headerView.configureLeftButton(normalImage: nil, selectedImage: nil, normalTitle: LocalizedString.Cancel.localized, selectedTitle: LocalizedString.Cancel.localized, normalColor: AppColors.themeGreen, selectedColor: AppColors.themeGreen, font: AppFonts.Regular.withSize(18.0))
        self.headerView.configureFirstRightButton(normalImage: nil, selectedImage: nil, normalTitle: LocalizedString.Done.localized, selectedTitle: LocalizedString.Done.localized, normalColor: AppColors.themeGreen, selectedColor: AppColors.themeGreen, font: AppFonts.SemiBold.withSize(18.0))
    }
    
    private func registerNibs() {
        self.specialReqTableView.registerCell(nibName: RoomTableViewCell.reusableIdentifier)
        self.specialReqTableView.registerCell(nibName: HCSpecialRequestTextfieldCell.reusableIdentifier)
    }
    
    //Mark:- IBActions
}

//Mark:- UITableView Delegate DataSource
//======================================
extension HCSpecialRequestsVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.specialRequests.count + 2
//        return self.viewModel.itineraryData.special_requests.count + 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row < self.viewModel.specialRequests.count {
            return 44
        }else if indexPath.row == self.viewModel.specialRequests.count {
            return 60 + 17

        }else {
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < self.viewModel.specialRequests.count {
            let cell = self.getRoomTableViewCell(tableView, cellForRowAt: indexPath)
            return cell
        } else {
            let cell = self.getTextFieldCell(tableView, cellForRowAt: indexPath)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let _ = tableView.cellForRow(at: indexPath) as? RoomTableViewCell {
        
            if !self.viewModel.selectedRequests.contains(where: { (req) -> Bool in
                req.id == self.viewModel.specialRequests[indexPath.row].id
            }) {

                if self.viewModel.specialRequests[indexPath.row].groupId != "0" {
                
                let contradictingReq = self.viewModel.selectedRequests.filter { $0.groupId != self.viewModel.specialRequests[indexPath.row].groupId }
                self.viewModel.selectedRequests = contradictingReq
                    
                }
                
//                self.viewModel.selectedRequestsId.append(self.viewModel.specialRequests[indexPath.row].id)
                self.viewModel.selectedRequests.append(self.viewModel.specialRequests[indexPath.row])
          
            } else {
//                self.viewModel.selectedRequestsId.remove(object: self.viewModel.specialRequests[indexPath.row].id)
                
                
                if let ind = self.viewModel.selectedRequests.firstIndex(where: { (req) -> Bool in
                    req.id == self.viewModel.specialRequests[indexPath.row].id
                }) {
                self.viewModel.selectedRequests.remove(at: ind)
               }
                
                
//                self.viewModel.selectedRequests.remove(object: self.viewModel.specialRequests[indexPath.row])
            }
        }
        self.specialReqTableView.reloadData()
    }
}

//Mark:- TableView Cells
//======================
extension HCSpecialRequestsVC {
    
    internal func getRoomTableViewCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RoomTableViewCell.reusableIdentifier, for: indexPath) as? RoomTableViewCell else { return UITableViewCell() }
        
        if self.viewModel.selectedRequests.contains(where: { (req) -> Bool in
            req.id == self.viewModel.specialRequests[indexPath.row].id
        }) {
            cell.statusButton.setImage(AppImages.CheckedGreenRadioButton, for: .normal)
        } else {
            cell.statusButton.setImage(AppImages.UncheckedGreenRadioButton, for: .normal)
        }
        cell.configCell(title: self.viewModel.specialRequests[indexPath.row].name)
        return cell
    }
    
    internal func getTextFieldCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HCSpecialRequestTextfieldCell.reusableIdentifier, for: indexPath) as? HCSpecialRequestTextfieldCell else { return UITableViewCell() }
        cell.delegate = self
        if indexPath.row == self.viewModel.specialRequests.count {
            //cell.topDividerViewTopConstraints.constant = 0.0//17.0
            cell.configCell(placeHolderText: textFieldPlaceHolder[0])
            cell.topDividerView.isHidden = false
            cell.infoTextField.text =  self.viewModel.other
            cell.topDividerTopConstraint.constant = 17.5
        } else {
           // cell.topDividerViewTopConstraints.constant = 0.0
            cell.topDividerView.isHidden = true
            cell.configCell(placeHolderText: textFieldPlaceHolder[1])
            cell.infoTextField.text =  self.viewModel.specialRequest
            cell.topDividerTopConstraint.constant = 0
        }
        return cell
    }
}

//Mark:- TopNavigationView Delegate
//=================================
extension HCSpecialRequestsVC: TopNavigationViewDelegate {
    
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        //        AppFlowManager.default.popViewController(animated: true)
    }
    
    func topNavBarFirstRightButtonAction(_ sender: UIButton) {
        if let safeDelegate = self.delegate {
            
            let names = self.viewModel.specialRequests.map { $0.name }
            
            safeDelegate.didPassSelectedRequestsId(ids: self.viewModel.selectedRequests.map { $0.id }, names: names, other: self.viewModel.other, specialRequest: self.viewModel.specialRequest)
        }
        self.dismiss(animated: true, completion: nil)
    }
}

//Mark:- HCSpecialRequestTextfieldCell Delegate
//=============================================
extension HCSpecialRequestsVC: HCSpecialRequestTextfieldCellDelegate {
    func didPassSpecialRequestAndAirLineText(infoText: String,textField: UITextField) {
        guard let cell = textField.tableViewCell, let indexPath = self.specialReqTableView.indexPath(for: cell) else {return}
        if indexPath.row == self.viewModel.specialRequests.count {
            self.viewModel.other = infoText
        } else {
            self.viewModel.specialRequest = infoText
        }
        printDebug(infoText)
    }
}
