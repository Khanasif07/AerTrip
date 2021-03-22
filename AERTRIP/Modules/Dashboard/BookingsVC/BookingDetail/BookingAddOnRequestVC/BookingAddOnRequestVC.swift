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
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var priceView: UIView!
    @IBOutlet weak var priceViewHieghtConstraint: NSLayoutConstraint!
    @IBOutlet weak var priceViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var bookingRequestStatusView: UIView!
    @IBOutlet weak var bookingRequestStatusLabel: UILabel!
    @IBOutlet weak var bookingStatusViewHeight: NSLayoutConstraint!
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    // MARK: - Variables
    let viewModel = BookingAddOnRequestVM()
    fileprivate let refreshControl = UIRefreshControl()
    
    var shouldShowMakePayment: Bool {
        if let caseData = self.viewModel.caseHistory, ((caseData.resolutionStatus == .paymentPending) || (caseData.resolutionStatus == .confirmationPending)) || (caseData.resolutionStatusId == "2") {
            return true
        }
        return false
    }
    
    var shouldShowAbort: Bool {
        if let caseData = self.viewModel.caseHistory, ((caseData.resolutionStatus == .paymentPending) || (caseData.resolutionStatus == .actionRequired) || (caseData.resolutionStatus == .inProgress)) {
            return true
        }
        return false
    }
    private var time: Float = 0.0
    private var timer: Timer?
    
    // MARK: - View Life Cyle
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.gradientView.addGredient(isVertical: false)
    }
    
    override func initialSetup() {
        self.requestTableView.contentInset = UIEdgeInsets(top: topNavigationView.height + bookingStatusViewHeight.constant - 0.5, left: 0.0, bottom: 0.0, right: 0.0)

        self.progressView.transform = self.progressView.transform.scaledBy(x: 1, y: 1)
        self.progressView?.isHidden = true
        self.requestTableView.backgroundColor = AppColors.themeGray04
        self.priceView.backgroundColor = AppColors.clear
        self.registerXib()
        self.requestTableView.dataSource = self
        self.requestTableView.delegate = self
        self.requestTableView.reloadData()
        self.addFooterView()
        
        self.reloadList()
//        AppGlobals.shared.startLoading()
        self.setUpNavBar()
        self.setupBookingStatusView()
        self.view.layoutIfNeeded()
        self.viewModel.getCaseHistory(showProgress: true)
        
        self.refreshControl.addTarget(self, action: #selector(self.handleRefresh(_:)), for: UIControl.Event.valueChanged)
        self.refreshControl.tintColor = AppColors.themeGreen
        self.requestTableView.refreshControl = refreshControl
        
        if let caseData = self.viewModel.caseHistory{
            let casetype = caseData.caseType
            
            var eventName = ""
            if casetype.lowercased().contains("cancellation"){
                eventName = "BookingDetailsCancellationRequest"
            }else if casetype.lowercased().contains("rescheduling")
            {
                eventName = "BookingDetailsReschedulingRequest"
            }else{
                eventName = "BookingDetailsAddonsRequest"
            }
            FirebaseAnalyticsController.shared.logEvent(name: eventName, params: ["ScreenName":casetype, "ScreenClass":"BookingAddOnRequestVC"])

        }

    }
    
    override func bindViewModel() {
        self.viewModel.delegate = self
    }
    
    override func dataChanged(_ note: Notification) {
        if let noti = note.object as? ATNotification {
            switch noti {
            case .myBookingCasesRequestStatusChanged:
                self.viewModel.getCaseHistory(showProgress: true)
            default:
                break
            }
        }
    }
    
    private func setUpNavBar() {
        
        self.topNavigationView.configureNavBar(title: self.viewModel.caseHistory?.caseType ?? LocalizedString.dash.localized, isLeftButton: true, isFirstRightButton: true, isSecondRightButton: false, isDivider: true)
        self.topNavigationView.navTitleLabel.numberOfLines = 1
        self.seupMakePaymentButton()
        
        self.topNavigationView.delegate = self
        self.topNavigationView.navTitleLabel.font = AppFonts.SemiBold.withSize(18.0)
        self.topNavigationView.navTitleLabel.textColor = AppColors.textFieldTextColor51
        self.topNavigationView.configureFirstRightButton(normalImage: #imageLiteral(resourceName: "popOverMenuIcon"), selectedImage: #imageLiteral(resourceName: "popOverMenuIcon"), normalTitle: nil, selectedTitle: nil, normalColor: nil, selectedColor: nil)
        
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
        self.setupBookingStatusView()
        self.seupMakePaymentButton()
        self.requestTableView.reloadData()
    }
    
    private func manageLoader(shouldStart: Bool) {
        self.indicator.style = .medium// .white
        self.indicator.color = AppColors.themeWhite
        if shouldStart{
            self.indicator.startAnimating()
        }else{
            self.indicator.stopAnimating()
        }
        self.makePaymentLabel.isHidden = shouldStart//.text = shouldStart ? "" : "Make Payment"
    }
    
    private func setupBookingStatusView(){
        
        if self.shouldShowMakePayment{
            self.bookingRequestStatusView.backgroundColor = AppColors.themeGray40
            self.bookingRequestStatusLabel.textColor = AppColors.themeWhite
            self.bookingRequestStatusLabel.font = AppFonts.SemiBold.withSize(16.0)
            var titleText = "Review the quotation and make payment"
            if let caseData = self.viewModel.caseHistory, (caseData.resolutionStatus == .confirmationPending) || (caseData.resolutionStatusId == "2"){
                titleText = "Kindly review and confirm"
            }
            self.bookingRequestStatusLabel.text = titleText
            bookingRequestStatusView.isHidden = false
            bookingStatusViewHeight.constant = 30
        }else{
            bookingRequestStatusView.isHidden = true
            bookingStatusViewHeight.constant = 0
        }
        self.requestTableView.contentInset = UIEdgeInsets(top: topNavigationView.height + bookingStatusViewHeight.constant - 0.5, left: 0.0, bottom: 0.0, right: 0.0)
        self.view.layoutIfNeeded()
    }
    func seupMakePaymentButton() {
        
        func setupForPayment() {
            self.priceLabel.attributedText = (self.viewModel.caseHistory?.amount ?? 0.0).amountInDelimeterWithSymbol.asStylizedPrice(using: AppFonts.SemiBold.withSize(20.0))
            self.makePaymentLabel.text = LocalizedString.MakePayment.localized
            self.makePaymentButton.setTitle(nil, for: .normal)
            self.priceView.isHidden = false
            self.priceViewHieghtConstraint.constant = 50.0
            self.priceViewBottomConstraint.constant = AppFlowManager.default.safeAreaInsets.bottom
            self.view.layoutIfNeeded()
            
        }
        
        func setupForConfirm(title: String) {
            self.priceLabel.text = ""
            self.makePaymentLabel.text = ""
            self.makePaymentButton.setTitle(title, for: .normal)
            self.priceView.isHidden = false
            self.priceViewHieghtConstraint.constant = 50.0
            self.priceViewBottomConstraint.constant = AppFlowManager.default.safeAreaInsets.bottom
            self.view.layoutIfNeeded()
        }
        
        func hideMakePayment() {
            self.priceView.isHidden = true
            self.priceViewHieghtConstraint.constant = 0.0
            self.priceViewBottomConstraint.constant = 0.0
            self.view.layoutIfNeeded()
        }
        
        if let caseData = self.viewModel.caseHistory {
            if caseData.resolutionStatus == .paymentPending {
                //setup for payment
                setupForPayment()
            }
            else if (caseData.resolutionStatus == .confirmationPending) || (caseData.resolutionStatusId == "2"){
                //setup for confirm
                
                var title = "Confirm"
                if caseData.caseType.lowercased().contains("rescheduling request") {
                    title += " Rescheduling"
                }
                else if caseData.caseType.lowercased().contains("cancellation request") {
                    title += " Cancellation"
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
        var finalText : String = ""
        self.topNavigationView.firstRightButton.isHidden = !self.shouldShowAbort
        finalText = getUpdatedTitle(text: self.viewModel.caseHistory?.caseType ?? LocalizedString.dash.localized)
        self.topNavigationView.navTitleLabel.text = finalText
    }
    
    func getUpdatedTitle(text: String ) -> String {
        let updatedTitle = text
//        if updatedTitle.count > 24 {
//            updatedTitle = updatedTitle.substring(from: 0, to: 8) + "..." +  updatedTitle.substring(from: updatedTitle.count - 8, to: updatedTitle.count)
//        }
        return updatedTitle
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.viewModel.getCaseHistory(showProgress: false)
    }
    
    @IBAction func makePaymentAction(_ sender: Any) {
        if let caseData = self.viewModel.caseHistory {
            if caseData.resolutionStatus == .paymentPending {
//                self.showLoaderOnView(view: self.priceView, show: true)
                
                FirebaseAnalyticsController.shared.logEvent(name: "BookingDetailsMakePaymentClicked", params: ["ScreenName":"BookingDetailsMakePayment", "ScreenClass":"BookingAddOnRequestVC"])

                self.manageLoader(shouldStart: true)
                self.viewModel.getAddonPaymentItinerary()
            }
            else if (caseData.resolutionStatus == .confirmationPending) || (caseData.resolutionStatusId == "2"){
                //setup for confirm
                
                var eventName = ""
                var screenName = ""
                if caseData.caseType.lowercased().contains("cancellation"){
                    eventName = "BookingDetailsConfirmCancellationClicked"
                    screenName = "BookingDetailsConfirmCancellation"
                }else if caseData.caseType.lowercased().contains("rescheduling")
                {
                    eventName = "BookingDetailsConfirmReschedulingClicked"
                    screenName = "BookingDetailsConfirmRescheduling"
                }
                FirebaseAnalyticsController.shared.logEvent(name: eventName, params: ["ScreenName":screenName, "ScreenClass":"BookingAddOnRequestVC"])

                
                self.viewModel.makeRequestConfirm()
            }
        }
    }
    
    private func addFooterView() {
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: UIDevice.screenWidth, height: 50))
        customView.backgroundColor = AppColors.themeGray04
        self.requestTableView.tableFooterView = customView
    }
    
    func startProgress() {
        // Invalid timer if it is valid
        if self.timer?.isValid == true {
            self.timer?.invalidate()
        }
        self.progressView?.isHidden = false
        self.time = 0.0
        self.progressView.setProgress(0.0, animated: false)
        self.timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(self.setProgress), userInfo: nil, repeats: true)
    }
    
    @objc func setProgress() {
        self.time += 1.0
        self.progressView?.setProgress(self.time / 10, animated: true)
        
        if self.time == 8 {
            self.timer?.invalidate()
            return
        }
        if self.time == 2 {
            self.timer!.invalidate()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(self.setProgress), userInfo: nil, repeats: true)
            }
        }
        
        if self.time >= 10 {
            self.timer!.invalidate()
            delay(seconds: 0.5) {
                self.progressView?.isHidden = true
            }
        }
    }
    func stopProgress() {
        self.time += 1
        if self.time <= 8  {
            self.time = 9
        }
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(self.setProgress), userInfo: nil, repeats: true)
    }
}

extension BookingAddOnRequestVC: BookingAddOnRequestVMDelegate {
    func willGetCommunicationDetail() {
        //AppGlobals.shared.startLoading()
    }
    
    func getCommunicationDetailSuccess(htmlString: String, title: String, indexPath: IndexPath) {
        //AppGlobals.shared.stopLoading()
        self.viewModel.caseHistory?.communications[indexPath.row].isEmailLoading = false
        if let cell = self.requestTableView.cellForRow(at: indexPath) as? BookingRequestAddOnTableViewCell {
            cell.showLoader = false
        }
        let time = "\(self.viewModel.caseHistory?.communications[indexPath.row].commDate?.toString(dateFormat: "hh:mm aa") ?? "") "
        self.showAddonsCommunication(htmlString, screenTitle: title, time: time)
    }
    
    func getCommunicationDetailFail(indexPath: IndexPath) {
        self.viewModel.caseHistory?.communications[indexPath.row].isEmailLoading = false
        if let cell = self.requestTableView.cellForRow(at: indexPath) as? BookingRequestAddOnTableViewCell {
            cell.showLoader = false
        }
        //AppGlobals.shared.stopLoading()
    }
    
    func showAddonsCommunication(_ html: String, screenTitle: String, time:String = ""){
        let obj = CommunicationVC.instantiate(fromAppStoryboard: .Bookings)
        obj.htmlString = html
        obj.navTitle = screenTitle
        obj.timeString = time
        self.navigationController?.present(obj, animated: true, completion: nil)
        
    }
    
    func makeRequestConfirmSuccess() {
        self.sendDataChangedNotification(data: ATNotification.myBookingCasesRequestStatusChanged)
        AppGlobals.shared.stopLoading()
    }
    
    func makeRequestConfirmFail() {
        AppGlobals.shared.stopLoading()
    }
    
    func willGetCaseHistory(showProgress: Bool) {
        if showProgress {
        self.startProgress()
        }
    }
    
    func getCaseHistorySuccess(showProgress: Bool) {
        if showProgress {
        self.stopProgress()
        }
        self.reloadList()
        self.refreshControl.endRefreshing()
    }
    
    func getCaseHistoryFail(showProgress: Bool) {
        if showProgress {
        self.stopProgress()
        }
        self.refreshControl.endRefreshing()
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
            //            if self.shouldShowMakePayment {
            //                return 2
            //            }
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
            //            if self.shouldShowMakePayment, indexPath.row == 0 {
            //                return 30.0
            //            }
            return UITableView.automaticDimension
        }
        else if indexPath.section == 1 {
            //case details
            let title = self.viewModel.caseDetailTitle[indexPath.row]
            let value = self.viewModel.caseDetailData[title] as? String ?? ""
            if !(value.isEmpty) && !(value == LocalizedString.dash.localized){
                if indexPath.row == 0 || self.viewModel.caseDetailData.count - 1 == indexPath.row   {
                  return 46.0
                }
                return 30.0
            }else{
                return 0.0
            }
            
        }
        else if let caseD = self.viewModel.caseHistory, !caseD.note.isEmpty {
            return UITableView.automaticDimension
        }
        else if let caseD = self.viewModel.caseHistory, !caseD.communications.isEmpty {
            return UITableView.automaticDimension
            //return 108.0
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
        
        bookingRouteCell.configure(title: self.viewModel.caseHistory?.caseName ?? LocalizedString.dash.localized, detail: self.viewModel.caseHistory?.caseNumber ?? LocalizedString.dash.localized)
        bookingRouteCell.dividerView.isHidden = false
        return bookingRouteCell
    }
    
    func getCaseDetailCell(indexPath: IndexPath) -> UITableViewCell {
        guard let requestStatusCell = self.requestTableView.dequeueReusableCell(withIdentifier: "BookingRequestStateTableViewCell") as? BookingRequestStateTableViewCell else {
            fatalError("BookingRequestStateTableViewCell not found ")
        }
        requestStatusCell.containerTopConstraint.constant = indexPath.row == 0 ? 16 : 0
        requestStatusCell.containerBottomContraint.constant = self.viewModel.caseDetailData.count - 1 == indexPath.row ? 16 : 0
        var title = self.viewModel.caseDetailTitle[indexPath.row]
        let value = (self.viewModel.caseDetailData[title] as? String) ?? LocalizedString.dash.localized
        
        title.removeFirst(2)
        requestStatusCell.configureCell(title: title, descriptor: value, status: .none)
        
        if indexPath.row == 0 {
            if !(self.viewModel.caseHistory?.resolutionStatus ?? .closed == .canceled){
                requestStatusCell.descriptorLabel.textColor = self.viewModel.caseHistory?.resolutionStatus.textColor
            }else{
                requestStatusCell.descriptorLabel.textColor = AppColors.themeRed
            }
            
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
        
        if let caseD = self.viewModel.caseHistory {
            bookingAddOnCell.isDeviderForLast = (indexPath.row == (caseD.communications.count-1))
        }
        
        return bookingAddOnCell
    }
    
    func getRequestStatusCell() -> UITableViewCell {
        guard let requestStatusCell = self.requestTableView.dequeueReusableCell(withIdentifier: "BookingRequestStatusTableViewCell") as? BookingRequestStatusTableViewCell else  {
            fatalError("BookingRequestStatusTableViewCell not found ")
        }
        
        var titleText = "Review the quotation and make payment"
        if let caseData = self.viewModel.caseHistory, caseData.resolutionStatus == .confirmationPending {
            titleText = "Kindly review and confirm"
        }
        
        requestStatusCell.configureCell(titleText)
        return requestStatusCell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            //header details
            //            if self.shouldShowMakePayment, indexPath.row == 0 {
            //                return self.getRequestStatusCell()
            //            }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            //header details
            
        }
        else if indexPath.section == 1 {
            //case details
        }
        else if let caseD = self.viewModel.caseHistory, !caseD.note.isEmpty {
        }
        else if let caseD = self.viewModel.caseHistory, !caseD.communications.isEmpty {
            let commonHash = self.viewModel.caseHistory?.communications[indexPath.row].commHash ?? ""
            let templateId = self.viewModel.caseHistory?.communications[indexPath.row].templateId ?? ""
            let title = self.viewModel.caseHistory?.communications[indexPath.row].subject ?? ""//self.viewModel.caseHistory?.communications[indexPath.row].commDate?.toString(dateFormat: "hh:mm aa") ?? ""
            self.viewModel.caseHistory?.communications[indexPath.row].isEmailLoading = true
            if let cell = self.requestTableView.cellForRow(at: indexPath) as? BookingRequestAddOnTableViewCell {
                cell.showLoader = true
            }
            self.viewModel.getCommunicationDetail(commonHash: commonHash, templateId: templateId, title: title, indexPath: indexPath)
        }
        
    }
}

extension BookingAddOnRequestVC {
    
    private func showDepositOptions() {
        let buttons = AppGlobals.shared.getPKAlertButtons(forTitles: [LocalizedString.PayOnline.localized, LocalizedString.PayOfflineNRegister.localized], colors: [AppColors.themeDarkGreen, AppColors.themeDarkGreen])
        
        _ = PKAlertController.default.presentActionSheet(nil, message: nil, sourceView: self.view, alertButtons: buttons, cancelButton: AppGlobals.shared.pKAlertCancelButton) { _, index in
            
            switch index {
            case 0:
                //PayOnline
                
                FirebaseAnalyticsController.shared.logEvent(name: "BookingAddOnRequestPayOnlineClicked", params: ["ScreenName":"BookingAddOnRequest", "ScreenClass":"BookingAddOnRequestVC"])

                AppFlowManager.default.moveToAccountOnlineDepositVC(depositItinerary: self.viewModel.itineraryData, usingToPaymentFor: .addOns)
                
            case 1:
                //PayOfflineNRegister
                FirebaseAnalyticsController.shared.logEvent(name: "BookingAddOnRequestPayOfflineClicked", params: ["ScreenName":"BookingAddOnRequest", "ScreenClass":"BookingAddOnRequestVC"])

                AppFlowManager.default.moveToAccountOfflineDepositVC(usingFor: .fundTransfer, usingToPaymentFor: .addOns, paymentModeDetail: self.viewModel.itineraryData?.fundTransfer, netAmount: self.viewModel.itineraryData?.netAmount ?? 0.0, bankMaster: self.viewModel.itineraryData?.bankMaster ?? [], itineraryData: self.viewModel.itineraryData)
                printDebug("PayOfflineNRegister")
                
            default:
                printDebug("no need to implement")
            }
        }
    }
    
    func getAddonPaymentItinerarySuccess() {
        self.manageLoader(shouldStart: false)
//        self.showLoaderOnView(view: self.priceView, show: false)
        self.showDepositOptions()
    }
    
    func getAddonPaymentItineraryFail() {
//        self.showLoaderOnView(view: self.priceView, show: false)
        self.manageLoader(shouldStart: false)
    }
}
