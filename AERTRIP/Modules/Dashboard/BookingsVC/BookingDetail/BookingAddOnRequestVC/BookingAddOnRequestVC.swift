//
//  BookingAddOnRequestVC.swift
//  AERTRIP
//
//  Created by apple on 16/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class BookingAddOnRequestVC: BaseVC {
    // MARK: - IBOutlet
    
    @IBOutlet weak var makePaymentButton: UIButton!
    @IBOutlet weak var topNavigationView: TopNavigationView!
    @IBOutlet weak var requestTableView: ATTableView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var makePaymentLabel: UILabel!
    
    @IBOutlet weak var priceView: UIView!
    @IBOutlet weak var priceViewHieghtConstraint: NSLayoutConstraint!
    
    // MARK: - Variables
    let viewModel = BookingAddOnRequestVM()
    
    var shouldShowMakePayment: Bool {
        if let caseData = self.viewModel.caseData, ((caseData.resolutionStatus == .paymentPending) || (caseData.resolutionStatus == .confirmationPending)) {
            return true
        }
        return false
    }
    
    var shouldShowAbort: Bool {
        if let caseData = self.viewModel.caseData, ((caseData.resolutionStatus == .paymentPending) || (caseData.resolutionStatus == .actionRequired) || (caseData.resolutionStatus == .inProgress)) {
            return true
        }
        return false
    }
        
    // MARK: - View Life Cyle
    
    override func initialSetup() {
        
        self.requestTableView.backgroundColor = AppColors.themeGray04
        
        self.registerXib()
        self.requestTableView.dataSource = self
        self.requestTableView.delegate = self
        self.requestTableView.reloadData()
        self.addFooterView()
        
        self.reloadList()
        self.setUpNavBar()
        AppGlobals.shared.startLoading()
        self.viewModel.getCaseHistory()
    }
    
    override func bindViewModel() {
        self.viewModel.delegate = self
    }
    
    override func dataChanged(_ note: Notification) {
        if let noti = note.object as? ATNotification, noti == .myBookingCasesRequestStatusChanged {
            self.viewModel.getCaseHistory()
        }
    }
    
    private func setUpNavBar() {
        
        self.topNavigationView.configureNavBar(title: self.viewModel.caseHistory?.caseType ?? LocalizedString.dash.localized, isLeftButton: true, isFirstRightButton: true, isSecondRightButton: false, isDivider: true)
        self.seupMakePaymentButton()
        
        self.topNavigationView.delegate = self
        self.topNavigationView.navTitleLabel.font = AppFonts.SemiBold.withSize(18.0)
        self.topNavigationView.navTitleLabel.textColor = AppColors.textFieldTextColor51
        self.topNavigationView.configureFirstRightButton(normalImage: #imageLiteral(resourceName: "popOverMenuIcon"), selectedImage: #imageLiteral(resourceName: "popOverMenuIcon"), normalTitle: nil, selectedTitle: nil, normalColor: nil, selectedColor: nil)
        self.priceView.addGredient(isVertical: false)
    }
    
    private func registerXib() {
        self.requestTableView.registerCell(nibName: BookingRequestNoteTableViewCell.reusableIdentifier)
        self.requestTableView.registerCell(nibName: BookingRequestRouteTableViewCell.reusableIdentifier)
        self.requestTableView.registerCell(nibName: BookingRequestAddOnTableViewCell.reusableIdentifier)
        self.requestTableView.registerCell(nibName: EmptyTableViewCell.reusableIdentifier)
        self.requestTableView.registerCell(nibName: BookingRequestStateTableViewCell.reusableIdentifier)
        self.requestTableView.registerCell(nibName: BookingRequestStatusTableViewCell.reusableIdentifier)
    }
    
    override func setupFonts() {
        self.priceLabel.font = AppFonts.SemiBold.withSize(20.0)
        self.makePaymentLabel.font = AppFonts.SemiBold.withSize(20.0)
        self.makePaymentButton.titleLabel?.font = AppFonts.SemiBold.withSize(20.0)
    }
    
    override func setupTexts() {
        //        self.priceLabel.text = AppConstants.kRuppeeSymbol + "\(Double(67000).delimiter)"
        self.makePaymentLabel.text = LocalizedString.MakePayment.localized
    }
    
    override func setupColors() {
        self.priceLabel.textColor = AppColors.themeWhite
        self.makePaymentLabel.textColor = AppColors.themeWhite
        self.makePaymentButton.setTitleColor(AppColors.themeWhite, for: .normal)
    }
    
    func reloadList() {
        self.seupMakePaymentButton()
        self.requestTableView.reloadData()
    }
    
    func seupMakePaymentButton() {
        
        func setupForPayment() {
            self.priceLabel.text = (self.viewModel.caseData?.amount ?? 0.0).delimiterWithSymbol
            self.makePaymentLabel.text = LocalizedString.MakePayment.localized
            self.makePaymentButton.setTitle(nil, for: .normal)
            self.priceView.isHidden = false
            self.priceViewHieghtConstraint.constant = 60.0
        }
        
        func setupForConfirm(title: String) {
            self.priceLabel.text = ""
            self.makePaymentLabel.text = ""
            self.makePaymentButton.setTitle(title, for: .normal)
            self.priceView.isHidden = false
            self.priceViewHieghtConstraint.constant = 60.0
        }
        
        func hideMakePayment() {
            self.priceView.isHidden = true
            self.priceViewHieghtConstraint.constant = 0.0
        }
        
        if let caseData = self.viewModel.caseData {
            if caseData.resolutionStatus == .paymentPending {
                //setup for payment
                setupForPayment()
            }
            else if caseData.resolutionStatus == .confirmationPending {
                //setup for confirm
                
                var title = "Confirm"
                if caseData.caseType.lowercased() == "rescheduling request" {
                    title += "Rescheduling"
                }
                else if caseData.caseType.lowercased() == "cancellation request" {
                    title += "Cancellation"
                }
                setupForConfirm(title: title)
            }
            else {
                hideMakePayment()
            }
        }
        else {
            //hide
            hideMakePayment()
        }
        
        self.topNavigationView.firstRightButton.isHidden = !self.shouldShowAbort
        
        self.topNavigationView.navTitleLabel.text = self.viewModel.caseHistory?.caseType ?? LocalizedString.dash.localized
    }
    
    @IBAction func makePaymentAction(_ sender: Any) {
        if let caseData = self.viewModel.caseData {
            if caseData.resolutionStatus == .paymentPending {
                if let rcpt = self.viewModel.receipt, let cId = self.viewModel.caseData?.id, !cId.isEmpty {
                    //setup for payment
                    AppFlowManager.default.moveToBookingVoucherVC(receipt: rcpt, caseId: cId)
                }
                else {
                    assertionFailure("receipt data no passed in file \(#file) at line \(#line)")
                }
            }
            else if caseData.resolutionStatus == .confirmationPending {
                //setup for confirm
                self.viewModel.makeRequestConfirm()
            }
        }
    }

    private func addFooterView() {
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: UIDevice.screenWidth, height: 50))
        customView.backgroundColor = AppColors.themeGray04
        self.requestTableView.tableFooterView = customView
    }
}

extension BookingAddOnRequestVC: BookingAddOnRequestVMDelegate {
    func makeRequestConfirmSuccess() {
        self.sendDataChangedNotification(data: ATNotification.myBookingCasesRequestStatusChanged)
        AppGlobals.shared.stopLoading()
    }
    
    func makeRequestConfirmFail() {
        AppGlobals.shared.stopLoading()
    }
    
    func getCaseHistorySuccess() {
        AppGlobals.shared.stopLoading()
        self.reloadList()
    }
    
    func getCaseHistoryFail() {
        AppGlobals.shared.stopLoading()
    }
}

// MARK: Top Navigation View delegate methods

extension BookingAddOnRequestVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        AppFlowManager.default.popViewController(animated: true)
    }
    func topNavBarFirstRightButtonAction(_ sender: UIButton) {
        let buttons = AppGlobals.shared.getPKAlertButtons(forTitles: [LocalizedString.AbortThisRequest.localized], colors: [AppColors.themeRed])
        
        _ = PKAlertController.default.presentActionSheet(nil, message: nil, sourceView: self.view, alertButtons: buttons, cancelButton: AppGlobals.shared.pKAlertCancelButton) {  _, index in
            
            if index == 0, let caseD = self.viewModel.caseData {
                printDebug("Abort this request tapped")
                AppFlowManager.default.moveToAbortRequestVC(forCase: caseD)
            }
        }
    }
}

// MARK: - UITableViewDataSource and UITableViewDelegate methods

extension BookingAddOnRequestVC: UITableViewDataSource, UITableViewDelegate {
    
    func totalSections() -> Int {
        var temp = 2 //title and case details
        
        if let caseD = self.viewModel.caseHistory, !caseD.note.isEmpty {
            temp += 1
        }
        else if let caseD = self.viewModel.caseHistory, !caseD.communications.isEmpty {
            temp += 1
        }
        
        return temp
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return totalSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            //header details
            if self.shouldShowMakePayment {
                return 2
            }
            return 1
        }
        else if section == 1 {
            //case details
            return self.viewModel.caseDetailData.count
        }
        else if let caseD = self.viewModel.caseHistory, !caseD.note.isEmpty {
            return 1
        }
        else if let caseD = self.viewModel.caseHistory, !caseD.communications.isEmpty {
            return caseD.communications.count
        }
        return 0
    }
    // height for Row at
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            //header details
            if self.shouldShowMakePayment, indexPath.row == 0 {
                return 30.0
            }
            return 65.0
        }
        else if indexPath.section == 1 {
            //case details
            return 30.0
        }
        else if let caseD = self.viewModel.caseHistory, !caseD.note.isEmpty {
            return UITableView.automaticDimension
        }
        else if let caseD = self.viewModel.caseHistory, !caseD.communications.isEmpty {
            return 108.0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if totalSections() == (section + 1) {
            return 0.0
        }
        return 30.0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if totalSections() == (section + 1) {
            return nil
        }
        guard let emptyTableViewCell = self.requestTableView.dequeueReusableCell(withIdentifier: "EmptyTableViewCell") as? EmptyTableViewCell else {
            fatalError("EmptyTableViewCell not found")
        }
        return emptyTableViewCell.contentView
    }
    
    func getHeaderRouteCell() -> UITableViewCell {
        guard let bookingRouteCell = self.requestTableView.dequeueReusableCell(withIdentifier: "BookingRequestRouteTableViewCell") as? BookingRequestRouteTableViewCell else {
            fatalError("BookingRequestRouteTableViewCell not found")
        }
        
        bookingRouteCell.configure(title: self.viewModel.caseData?.caseName ?? LocalizedString.dash.localized, detail: self.viewModel.caseData?.casedId ?? LocalizedString.dash.localized)
        
        return bookingRouteCell
    }
    
    func getCaseDetailCell(indexPath: IndexPath) -> UITableViewCell {
        guard let requestStatusCell = self.requestTableView.dequeueReusableCell(withIdentifier: "BookingRequestStateTableViewCell") as? BookingRequestStateTableViewCell else {
            fatalError("BookingRequestStateTableViewCell not found ")
        }
        
        var title = self.viewModel.caseDetailTitle[indexPath.row]
        let value = (self.viewModel.caseDetailData[title] as? String) ?? LocalizedString.dash.localized
        
        title.removeFirst(2)
        requestStatusCell.configureCell(title: title, descriptor: value, status: .none)
        
        if indexPath.row == 0 {
            requestStatusCell.descriptorLabel.textColor = self.viewModel.caseData?.resolutionStatus.textColor
        }
        else {
            requestStatusCell.descriptorLabel.textColor = AppColors.themeTextColor
        }
        
        return requestStatusCell
    }
    
    func getNoteCell() -> UITableViewCell {
        guard let noteCell = self.requestTableView.dequeueReusableCell(withIdentifier: "BookingRequestNoteTableViewCell") as? BookingRequestNoteTableViewCell else {
            fatalError("BookingRequestNoteTableViewCell not found")
        }
        
        noteCell.configure(info: self.viewModel.caseHistory?.note ?? "")
        return noteCell
    }
    
    func getCommunicationCell(indexPath: IndexPath) -> UITableViewCell {
        guard let bookingAddOnCell = self.requestTableView.dequeueReusableCell(withIdentifier: "BookingRequestAddOnTableViewCell") as? BookingRequestAddOnTableViewCell else {
            fatalError("BookingRequestAddOnTableViewCell not found")
        }
        bookingAddOnCell.communicationData = self.viewModel.caseHistory?.communications[indexPath.row]
        return bookingAddOnCell
    }
    
    func getRequestStatusCell() -> UITableViewCell {
        guard let requestStatusCell = self.requestTableView.dequeueReusableCell(withIdentifier: "BookingRequestStatusTableViewCell") as? BookingRequestStatusTableViewCell else  {
            fatalError("BookingRequestStatusTableViewCell not found ")
        }
        
        var titleText = "Review the quotation and make payment"
        if let caseData = self.viewModel.caseData, caseData.resolutionStatus == .confirmationPending {
            titleText = "Kindly review and confirm"
        }
        
        requestStatusCell.configureCell(titleText)
        return requestStatusCell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            //header details
            if self.shouldShowMakePayment, indexPath.row == 0 {
                return self.getRequestStatusCell()
            }
            return self.getHeaderRouteCell()
        }
        else if indexPath.section == 1 {
            //case details
            return self.getCaseDetailCell(indexPath: indexPath)
        }
        else if let caseD = self.viewModel.caseHistory, !caseD.note.isEmpty {
            return self.getNoteCell()
        }
        else if let caseD = self.viewModel.caseHistory, !caseD.communications.isEmpty {
            return self.getCommunicationCell(indexPath: indexPath)
        }
        
        return UITableViewCell()
    }
}