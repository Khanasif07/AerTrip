//
//  SpecialAccountDetailsVC.swift
//  AERTRIP
//
//  Created by Admin on 06/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class SpecialAccountDetailsVC: BaseVC {
    
    //MARK:- IBOutlets
    //MARK:-
    @IBOutlet weak var topNavView: TopNavigationView!
    @IBOutlet weak var tableView: ATTableView! {
        didSet {
            self.tableView.contentInset = UIEdgeInsets(top: 44, left: 0, bottom: 0, right: 0)
        }
    }
    @IBOutlet weak var progressView: UIProgressView!
    
    //MARK:- Properties
    //MARK:- Public
    let viewModel = SpecialAccountDetailsVM()
    
    //MARK:- Private
    var depositButton: ATButton?
    var currentUserType: UserCreditType {
        return UserInfo.loggedInUser?.userCreditType ?? UserCreditType.statement
    }
    
    private var tableFooterView: UIView {
        let bView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIDevice.screenWidth, height: 80.0))
        bView.backgroundColor = AppColors.clear
        
        return bView
    }
    private var time: Float = 0.0
    private var timer: Timer?
    private let refreshControl = UIRefreshControl()
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .accountDetailFetched, object: nil)
    }
    
    //MARK:- ViewLifeCycle
    //MARK:-
    override func initialSetup() {
        self.progressView.transform = self.progressView.transform.scaledBy(x: 1, y: 1)
        self.progressView?.isHidden = true
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = AppColors.screensBackground.color
        self.tableView.registerCell(nibName: EmptyTableViewCell.reusableIdentifier)
        
        self.topNavView.configureNavBar(title: LocalizedString.Accounts.localized, isLeftButton: true, isFirstRightButton: false, isSecondRightButton: false, isDivider: false, backgroundType: .color(color: AppColors.themeWhite))
        
        if let user = UserInfo.loggedInUser, (user.userCreditType == .statement || user.userCreditType == .billwise) {
            self.topNavView.configureNavBar(title: LocalizedString.Accounts.localized, isLeftButton: true, isFirstRightButton: true, isSecondRightButton: false, isDivider: false, backgroundType: .color(color: AppColors.themeWhite))
        }
        
        self.topNavView.delegate = self
        
        self.topNavView.configureFirstRightButton(normalImage: #imageLiteral(resourceName: "ic_account_info"), selectedImage: #imageLiteral(resourceName: "ic_account_info"))
        
        self.viewModel.fetchScreenDetails(showProgress: true)
        topNavView.backgroundColor = AppColors.clear
        //self.view.backgroundColor = AppColors.themeWhite.withAlphaComponent(0.85)
        self.tableView.tableFooterView = self.tableFooterView
        
        NotificationCenter.default.addObserver(self, selector: #selector(accountDetailFetched(_:)), name: .accountDetailFetched, object: nil)
        

        self.refreshControl.addTarget(self, action: #selector(self.handleRefresh(_:)), for: UIControl.Event.valueChanged)
        self.refreshControl.tintColor = AppColors.themeGreen
        self.tableView.refreshControl = refreshControl
    }
    
    override func dataChanged(_ note: Notification) {
        if let noti = note.object as? ATNotification, noti == .accountPaymentRegister {
            //re-hit the details API
            self.viewModel.fetchScreenDetails(showProgress: true)
        }
    }
    
    @objc func accountDetailFetched(_ note: Notification) {
        if let object = note.object as? AccountDetailPostModel {
            printDebug("accountDetailFetched")
            self.viewModel.setAccountDetail(model: object)
        }
    }
    
    
    override func bindViewModel() {
        self.viewModel.delegate = self
    }
    
    //MARK:- Methods
    //MARK:- Private
    private func showDepositOptions() {
        let buttons = AppGlobals.shared.getPKAlertButtons(forTitles: [LocalizedString.PayOnline.localized, LocalizedString.PayOfflineNRegister.localized], colors: [AppColors.themeDarkGreen, AppColors.themeDarkGreen])
        
        _ = PKAlertController.default.presentActionSheet(nil, message: nil, sourceView: self.view, alertButtons: buttons, cancelButton: AppGlobals.shared.pKAlertCancelButton) { [weak self] (_, index) in
            guard let strongSelf = self else {return}
            switch index {
            case 0:
                //PayOnline
                AppFlowManager.default.moveToAccountOnlineDepositVC(depositItinerary: strongSelf.viewModel.itineraryData, usingToPaymentFor: .accountDeposit)
                
            case 1:
                //PayOfflineNRegister
                AppFlowManager.default.moveToAccountOfflineDepositVC(usingFor: .fundTransfer, usingToPaymentFor: .accountDeposit, paymentModeDetail: strongSelf.viewModel.itineraryData?.chequeOrDD, netAmount: strongSelf.viewModel.itineraryData?.netAmount ?? 0.0, bankMaster: strongSelf.viewModel.itineraryData?.bankMaster ?? [])
                printDebug("PayOfflineNRegister")
                
            default:
                printDebug("no need to implement")
            }
        }
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
        self.timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(self.setProgress), userInfo: nil, repeats: true)
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.viewModel.fetchScreenDetails(showProgress: false)
    }
    //MARK:- Public
    
    
    //MARK:- Action
    @objc func depositButtonAction(_ sender: ATButton) {
        self.viewModel.getOutstandingPayment()
    }
}

//MARK:- ViewModel Delegate Methods
//MARK:-
extension SpecialAccountDetailsVC: SpecialAccountDetailsVMDelegate {
    func willGetOutstandingPayment() {
        self.depositButton?.isLoading = true
    }
    
    func getOutstandingPaymentSuccess() {
        self.depositButton?.isLoading = false
        self.showDepositOptions()
    }
    
    func getOutstandingPaymentFail() {
        self.depositButton?.isLoading = false
    }
    
    func willFetchScreenDetails(showProgress: Bool) {
        //AppGlobals.shared.startLoading()
        if showProgress {
            startProgress()
            self.tableView.isUserInteractionEnabled = false
        }
    }
    
    func fetchScreenDetailsSuccess(showProgress: Bool) {
        //AppGlobals.shared.stopLoading()
        if showProgress {
            stopProgress()
            self.tableView.isUserInteractionEnabled = true
        }
        self.tableView.reloadData()
        self.refreshControl.endRefreshing()
    }
    
    func fetchScreenDetailsFail(showProgress: Bool) {
        //AppGlobals.shared.stopLoading()
        if showProgress {
            stopProgress()
            self.tableView.isUserInteractionEnabled = true
        }
        self.refreshControl.endRefreshing()
    }
}

//MARK:- Nav bar delegate methods
//MARK:-
extension SpecialAccountDetailsVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        //back button action
        AppFlowManager.default.popViewController(animated: true)
    }
    
    func topNavBarFirstRightButtonAction(_ sender: UIButton) {
        //info button action
        AppFlowManager.default.presentAccountChargeInfoVC(usingFor: .chargeInfo)
    }
}
