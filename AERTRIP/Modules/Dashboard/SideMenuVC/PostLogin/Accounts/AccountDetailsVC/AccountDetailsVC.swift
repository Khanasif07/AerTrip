//
//  AccountDetailsVC.swift
//  AERTRIP
//
//  Created by Admin on 16/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit
import IQKeyboardManager
class AccountDetailsVC: BaseVC {
    
    enum ViewState {
        case searching
        case filterApplied
        case normal
    }
    
    enum UsingFor {
        case account
        case accountLadger
    }
    
    //MARK:- IBOutlets
    //MARK:-
    @IBOutlet weak var topNavView: TopNavigationView!
    @IBOutlet weak var balanceContainerView: UIView!
    @IBOutlet weak var balanceTextLabel: UILabel!
    @IBOutlet weak var balanceAmountLabel: UILabel!
    @IBOutlet weak var balanceContainerDivider: ATDividerView!
    @IBOutlet weak var tableView: ATTableView!
    @IBOutlet weak var searchContainerView: UIView!
    @IBOutlet weak var blankSpaceView: UIView!
    @IBOutlet weak var searchBarContainerView: UIView!
    @IBOutlet weak var searchBar: ATSearchBar!
    @IBOutlet weak var subHeaderContainer: UIView!
    @IBOutlet weak var subHeaderContainerTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var subHeaderContainerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchDataContainerView: UIView!
    @IBOutlet weak var searchTableView: ATTableView!
    @IBOutlet weak var mainSearchBar: ATSearchBar!
    @IBOutlet weak var searchModeSearchBarTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var ladgerDummySearchView: UIView!
    @IBOutlet weak var ladgerDummySearchBar: ATSearchBar!
    
    @IBOutlet weak var openingDetailContainerView: UIView!
    @IBOutlet weak var openingBalanceTitleLabel: UILabel!
    @IBOutlet weak var openingBalanceDateLabel: UILabel!
    @IBOutlet weak var openingBalanceAmountLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    
    //MARK:- Properties
    //MARK:- Public
    let viewModel = AccountDetailsVM()
    var currentUsingAs = UsingFor.account
    var tableViewHeaderCellIdentifier = "TravellerListTableViewSectionView"
    //MARK:- Private
    private var time: Float = 0.0
    private var timer: Timer?
    fileprivate let refreshControl = UIRefreshControl()
    
    var currentViewState = ViewState.normal {
        didSet {
            self.manageHeader(animated: true)
        }
    }
    
    // Empty State view
    private lazy var noAccountTransectionView: EmptyScreenView = {
        let newEmptyView = EmptyScreenView()
        newEmptyView.vType = .noAccountTransection
        return newEmptyView
    }()
    
    private lazy var noAccountResultView: EmptyScreenView = {
        let newEmptyView = EmptyScreenView()
        newEmptyView.vType = .noAccountResult
        newEmptyView.delegate = self
        return newEmptyView
    }()
    
    lazy var noResultemptyView: EmptyScreenView = {
        let newEmptyView = EmptyScreenView()
        newEmptyView.vType = .noResult
        return newEmptyView
    }()
    
    
    
    
    //MARK:- ViewLifeCycle
    //MARK:-
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .accountDetailFetched, object: nil)
    }
    
    override func initialSetup() {
        self.progressView.transform = self.progressView.transform.scaledBy(x: 1, y: 1)
        self.progressView?.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
        
        self.manageSubView()
        let navTitle = (self.currentUsingAs == .account) ? LocalizedString.Accounts.localized : LocalizedString.AccountLegder.localized
        self.topNavView.configureNavBar(title: navTitle, isLeftButton: true, isFirstRightButton: true, isSecondRightButton: true, isDivider: false)
        
        self.topNavView.delegate = self
        
        self.topNavView.configureFirstRightButton(normalImage: #imageLiteral(resourceName: "greenPopOverButton"), selectedImage: #imageLiteral(resourceName: "greenPopOverButton"))
        self.topNavView.configureSecondRightButton(normalImage: #imageLiteral(resourceName: "bookingFilterIcon"), selectedImage: #imageLiteral(resourceName: "bookingFilterIconSelected"))
        
        //add search view in tableView header
        self.tableView.register(DateTableHeaderView.self, forHeaderFooterViewReuseIdentifier: "DateTableHeaderView")
        self.tableView.registerCell(nibName: AccountDetailEventHeaderCell.reusableIdentifier)
        self.tableView.registerCell(nibName: AccountDetailEventDescriptionCell.reusableIdentifier)
        self.tableView.register(UINib(nibName: tableViewHeaderCellIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: tableViewHeaderCellIdentifier)
        
        self.tableView.registerCell(nibName: AccountLedgerEventCell.reusableIdentifier)
        self.tableView.registerCell(nibName: NewAccountLedgerEventCell.reusableIdentifier)
        
        self.searchBar.isMicEnabled = true
        
        
        if let usr = UserInfo.loggedInUser, usr.userCreditType == .regular {
            self.viewModel.getAccountDetails(showProgres: true)
            self.balanceContainerDivider.isHidden = false
        }else{
            self.balanceContainerDivider.isHidden = true
        }
        
        self.searchDataContainerView.backgroundColor = AppColors.clear
        self.mainSearchBar.showsCancelButton = true
        if let cancelButton = mainSearchBar.value(forKey: "cancelButton") as? UIButton{
            cancelButton.titleLabel?.font = AppFonts.Regular.withSize(18)
        }
        self.searchBar.delegate = self
        self.mainSearchBar.delegate = self
        self.ladgerDummySearchBar.delegate = self
        
        self.searchTableView.delegate = self
        self.searchTableView.dataSource = self
        self.searchTableView.backgroundView = self.noResultemptyView
        self.searchTableView.register(DateTableHeaderView.self, forHeaderFooterViewReuseIdentifier: "DateTableHeaderView")
        self.searchTableView.registerCell(nibName: AccountDetailEventHeaderCell.reusableIdentifier)
        self.searchTableView.registerCell(nibName: AccountDetailEventDescriptionCell.reusableIdentifier)
        
        self.manageHeader(animated: false)
        //Chnage for blur header
        //self.view.backgroundColor = AppColors.themeWhite.withAlphaComponent(0.85)
//        topNavView.backgroundColor = AppColors.clear
        delay(seconds: 0.2) { [weak self] in
            self?.setupHeaderFooterText()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(accountDetailFetched(_:)), name: .accountDetailFetched, object: nil)

        
        self.refreshControl.addTarget(self, action: #selector(self.handleRefresh(_:)), for: UIControl.Event.valueChanged)
        self.refreshControl.tintColor = AppColors.themeGreen
        self.tableView.refreshControl = refreshControl
        
    }
    
    override func dataChanged(_ note: Notification) {
        if let noti = note.object as? ATNotification, noti == .accountPaymentRegister, let usr = UserInfo.loggedInUser, usr.userCreditType == .regular {
            //re-hit the details API
            self.viewModel.getAccountDetails(showProgres: true)
        }
    }
    
    @objc func accountDetailFetched(_ note: Notification) {
        if let object = note.object as? AccountDetailPostModel {
            printDebug("accountDetailFetched")
            self.viewModel.allVouchers = object.accVouchers
            self.viewModel.setAccountDetails(details: object.accountLadger)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        IQKeyboardManager.shared().isEnableAutoToolbar = true
    }
    
    override func bindViewModel() {
        self.viewModel.delegate = self
    }
    
    override func setupFonts() {
        self.balanceTextLabel.font = AppFonts.Regular.withSize(14.0)
        self.balanceAmountLabel.font = AppFonts.SemiBold.withSize(28.0)
        
        self.openingBalanceTitleLabel.font = AppFonts.Regular.withSize(16.0)
        self.openingBalanceAmountLabel.font = AppFonts.Regular.withSize(16.0)
        self.openingBalanceDateLabel.font = AppFonts.Regular.withSize(14.0)
    }
    
    override func setupTexts() {
        self.balanceTextLabel.text = LocalizedString.Balance.localized
        
        self.searchBar.placeholder = LocalizedString.search.localized
        self.mainSearchBar.placeholder = LocalizedString.search.localized
        self.ladgerDummySearchBar.placeholder = LocalizedString.search.localized
        
        self.openingBalanceTitleLabel.text = LocalizedString.OpeningBalance.localized
    }
    
    override func setupColors() {
        self.balanceTextLabel.textColor = AppColors.themeGray40
        
        self.tableView.backgroundColor = AppColors.themeWhite
        
        self.searchContainerView.backgroundColor = AppColors.themeWhite
        self.searchBarContainerView.backgroundColor = AppColors.themeWhite
        self.blankSpaceView.backgroundColor = AppColors.themeGray04
        
        self.openingBalanceTitleLabel.textColor = AppColors.themeBlack
        self.openingBalanceAmountLabel.textColor = AppColors.themeBlack
        self.openingBalanceDateLabel.textColor = AppColors.themeGray40
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
     self.viewModel.getAccountDetails(showProgres: false)
    }
    
    @IBAction func tapSearchContainerView(_ sender: UIButton) {
        self.currentViewState = .normal
        self.clearSearchData()
    }
    //MARK:- Methods
    //MARK:- Private
    private func setupHeaderFooterText() {
        
        if let accountData = UserInfo.loggedInUser?.accountData {
            self.openingBalanceAmountLabel.attributedText = accountData.openingBalance.amountInDelimeterWithSymbol.asStylizedPrice(using: AppFonts.Regular.withSize(16.0))
            self.openingBalanceDateLabel.text = ""//"Upto Tue, 31 Jul 2018"
//            if UserInfo.loggedInUser?.userCreditType
            
            if (UserInfo.loggedInUser?.userCreditType ?? .statement  == .regular){
                let amount = (accountData.walletAmount != 0) ? (accountData.walletAmount * -1): accountData.walletAmount
                self.balanceAmountLabel.attributedText = amount.amountInDelimeterWithSymbol.asStylizedPrice(using: AppFonts.SemiBold.withSize(28.0))
            }else{
                self.balanceAmountLabel.attributedText = accountData.currentBalance.amountInDelimeterWithSymbol.asStylizedPrice(using: AppFonts.SemiBold.withSize(28.0))
            }
        } else {
            self.balanceAmountLabel.attributedText = 0.0.amountInDelimeterWithSymbol.asStylizedPrice(using: AppFonts.SemiBold.withSize(28.0))
        }
    }
    
    private func manageSubView() {
        if self.currentUsingAs == .account {
            self.subHeaderContainerHeightConstraint.constant = 76.0
            self.balanceContainerView.isHidden = false
            self.ladgerDummySearchView.isHidden = true
            self.searchModeSearchBarTopConstraint.constant = 155.0
            self.tableView.tableHeaderView = self.searchContainerView
        }
        else {
            self.subHeaderContainerHeightConstraint.constant = 52.0
            self.balanceContainerView.isHidden = true
            self.ladgerDummySearchView.isHidden = false
            self.searchModeSearchBarTopConstraint.constant = 44.0
            self.tableView.tableHeaderView = nil
        }
    }
    private func manageHeader(animated: Bool) {

        if (self.currentViewState == .normal) {
            self.balanceContainerView.isHidden = false
            self.view.endEditing(true)
        }

        UIView.animate(withDuration: animated ? AppConstants.kAnimationDuration : 0.0, animations: { [weak self] in
            guard let sSelf = self else {return}
            
            if (sSelf.currentViewState == .searching) {
                sSelf.subHeaderContainerTopConstraint.constant = -(sSelf.subHeaderContainer.height)
                sSelf.balanceContainerView.alpha = 0.0
                sSelf.tableView.tableHeaderView = nil
                sSelf.searchDataContainerView.isHidden = false
                sSelf.searchModeSearchBarTopConstraint.constant = 0.0
            }
            else {
                sSelf.subHeaderContainerTopConstraint.constant = 0.0
                sSelf.balanceContainerView.alpha = 1.0
                sSelf.tableView.tableHeaderView = (sSelf.currentUsingAs == .account) ? sSelf.searchContainerView : nil
                sSelf.searchDataContainerView.isHidden = true
                sSelf.searchModeSearchBarTopConstraint.constant = (sSelf.currentUsingAs == .account) ? 155.0 : 44.0
            }
            
            sSelf.view.layoutIfNeeded()
            
            }, completion: { [weak self](isDone) in
                guard let sSelf = self else {return}
                sSelf.balanceContainerView.isHidden = (sSelf.currentViewState == .searching)
                sSelf.searchTableView.reloadData()
                if (sSelf.currentViewState == .searching) {
                    sSelf.mainSearchBar.becomeFirstResponder()
                    sSelf.searchDataContainerView.backgroundColor = AppColors.themeBlack.withAlphaComponent(0.4)
                }
                else {
                    sSelf.searchDataContainerView.backgroundColor = AppColors.clear
                }
                
                sSelf.topNavView.secondRightButton.isSelected = (sSelf.currentViewState == .filterApplied)
        })
    }
    
    private func showMoreOptions() {
        let buttons = AppGlobals.shared.getPKAlertButtons(forTitles: [LocalizedString.Email.localized, LocalizedString.DownloadAsPdf.localized], colors: [AppColors.themeDarkGreen, AppColors.themeDarkGreen])
        
        _ = PKAlertController.default.presentActionSheet(nil, message: nil, sourceView: self.view, alertButtons: buttons, cancelButton: AppGlobals.shared.pKAlertCancelButton) { _, index in
            if index == 0 {
                //email tapped
                AppToast.default.showToastMessage(message: "Sending email")
                self.viewModel.sendEmailForLedger(onVC: self)
            } else {
                //download pdf tapped
//                AppGlobals.shared.viewPdf(urlPath: "https://beta.aertrip.com/api/v1/user-accounts/report-action?action=pdf&type=ledger", screenTitle: LocalizedString.AccountsLegder.localized)
                self.topNavView.isToShowIndicatorView = true
                self.topNavView.startActivityIndicaorLoading()
                self.topNavView.firstRightButton.isHidden = true
                self.topNavView.secondRightButton.isHidden = true
                AppGlobals.shared.viewPdf(urlPath: "\(APIEndPoint.baseUrlPath.path)user-accounts/report-action?action=pdf&type=ledger", screenTitle: LocalizedString.AccountsLegder.localized, showLoader: false, complition: { [weak self] (status) in
                    self?.topNavView.isToShowIndicatorView = false
                    self?.topNavView.stopActivityIndicaorLoading()
                    self?.topNavView.firstRightButton.isHidden = false
                    self?.topNavView.secondRightButton.isHidden = false
                })
                printDebug("download pdf tapped")
            }
        }
    }
    
    //MARK:- Public
    func reloadList() {
        
        self.setupHeaderFooterText()

        self.tableView.backgroundView = (self.currentViewState == .filterApplied) ? self.noAccountResultView : self.noAccountTransectionView
        
        let isAllDatesEmpty = self.viewModel.allDates.isEmpty
        self.tableView.backgroundView?.isHidden = !isAllDatesEmpty
        self.tableView.isScrollEnabled = !isAllDatesEmpty
        
        if self.currentUsingAs == .account {
            self.tableView.tableHeaderView = isAllDatesEmpty ? nil : self.searchContainerView
        }
        
//        if let usr = UserInfo.loggedInUser, usr.userCreditType != .regular {
        if (ADEventFilterVM.shared.selectedVoucherType.isEmpty || ADEventFilterVM.shared.selectedVoucherType.count == ADEventFilterVM.shared.voucherTypes.count) && (ADEventFilterVM.shared.fromDate != nil || ADEventFilterVM.shared.toDate != nil){
                if let events = (self.viewModel.accountDetails[self.viewModel.allDates.last ?? ""] as? [AccountDetailEvent]), let event = events.last{
                    let balance = event.balance - event.amount
                    self.openingBalanceAmountLabel.attributedText = balance.amountInDelimeterWithSymbol.asStylizedPrice(using: AppFonts.Regular.withSize(16))
                }
                self.tableView.tableFooterView = isAllDatesEmpty ? nil : self.openingDetailContainerView
            }else{
                self.tableView.tableFooterView = nil
            }
            
//        }
    
        
//        if (self.currentViewState != .filterApplied) {
//            self.topNavView.firstRightButton.isUserInteractionEnabled = !isAllDatesEmpty
//            self.topNavView.secondRightButton.isUserInteractionEnabled = !isAllDatesEmpty
//        }
        
        self.tableView.reloadData()
        self.searchTableView.reloadData()
    }
    
    //MARK:- Action
}

//MARK:- SearchBar delegate Methods
//MARK:-
extension AccountDetailsVC: UISearchBarDelegate {
    
    func clearSearchData() {
        self.mainSearchBar.text = ""
        self.searchBar.text = ""
        self.ladgerDummySearchBar.text = ""
        self.viewModel.setSearchedAccountDetails(data: [:])
        self.viewModel.setAccountDetails(data: self.viewModel._accountDetails)
        self.applyFilter()
        self.reloadList()
    }
    
    func preserveSearchData() {
        self.searchBar.text = self.mainSearchBar.text
        self.ladgerDummySearchBar.text = self.mainSearchBar.text
        self.viewModel.setAccountDetails(data: self.viewModel.searchedAccountDetails)
        self.reloadList()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if searchBar === self.mainSearchBar {
            self.currentViewState = .normal
            self.clearSearchData()
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        if searchBar === self.mainSearchBar, (searchBar.text ?? "").isEmpty {
           // self.searchBarCancelButtonClicked(searchBar)
        }
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        IQKeyboardManager.shared().isEnableAutoToolbar = false
        if (searchBar === self.searchBar) || (searchBar === self.ladgerDummySearchBar) {
            self.currentViewState = .searching
            return false
        }
     
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if (searchBar.text?.isEmpty ?? false){
            self.searchBarCancelButtonClicked(searchBar)
        }else{
            self.preserveSearchData()
//            self.currentViewState = .filterApplied
            self.view.endEditing(true)
        }
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar === self.mainSearchBar {
            self.currentViewState = .searching
            //searchText.count >= AppConstants.kSearchTextLimit
            self.viewModel.searchEvent(forText: searchText)
            if !searchText.isEmpty {
            self.noResultemptyView.searchTextLabel.isHidden = false
            self.noResultemptyView.searchTextLabel.text = "\(LocalizedString.For.localized) '\(searchText)'"
            } else {
                self.clearSearchData()
            }
        }
//        else {
//            //reset tot the old state
//            if (searchBar.text ?? "").isEmpty {
//                self.clearSearchData()
//            }
//            else {
////                self.reloadList()
//                self.clearSearchData()
//
//            }
//        }
    }
}

//MARK:- Nav bar delegate methods
//MARK:-
extension AccountDetailsVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        //back button action
        ADEventFilterVM.shared.setToDefault()
        AppFlowManager.default.popViewController(animated: true)
    }
    
    func topNavBarFirstRightButtonAction(_ sender: UIButton) {
        //dots button action
        self.showMoreOptions()
    }
    
    func topNavBarSecondRightButtonAction(_ sender: UIButton) {
        //filter button action
        ADEventFilterVM.shared.minFromDate = self.viewModel.ledgerStartDate
        ADEventFilterVM.shared.voucherTypes = self.viewModel.allVouchers
        AppFlowManager.default.moveToADEventFilterVC(onViewController: self, delegate: self)
    }
}

//MARK:- Filter VC delegate methods
//MARK:-
extension AccountDetailsVC: ADEventFilterVCDelegate {
    func applyFilter() {
        if ADEventFilterVM.shared.isFilterAplied  {
            self.currentViewState = .filterApplied
        } else {
            self.currentViewState =  self.currentViewState == .filterApplied ? .normal : self.currentViewState
        }
        self.viewModel.applyFilter(searchText: self.mainSearchBar.text ?? "")
    }
    func clearAllFilter() {
        //clear all filter
        self.currentViewState = .normal
        self.viewModel.applyFilter(searchText: self.mainSearchBar.text ?? "")
    }
    
    
}

//MARK:- EmptyScreenViewdelegate methods
//MARK:-
extension AccountDetailsVC: EmptyScreenViewDelegate {
    func firstButtonAction(sender: ATButton) {
    }
    func bottomButtonAction(sender: UIButton) {
        //clear all filter
        self.currentViewState = .normal
        ADEventFilterVM.shared.setToDefault()
        self.viewModel.applyFilter(searchText: self.mainSearchBar.text ?? "")
    }
}

//MARK:- View model delegate methods
//MARK:-
extension AccountDetailsVC: AccountDetailsVMDelegate {
    
    func applyFilterSuccess() {
        self.reloadList()
    }
    
    func applyFilterFail() {
        self.reloadList()
    }

    func willGetAccountDetails(showProgres: Bool) {
        if showProgres {
            self.startProgress()
        }
        //AppGlobals.shared.startLoading()
        self.topNavView.firstRightButton.isUserInteractionEnabled = false
        self.topNavView.secondRightButton.isUserInteractionEnabled = false
    }
    
    func getAccountDetailsSuccess(model: AccountDetailPostModel, showProgres: Bool) {
        if showProgres {
            self.stopProgress()
        }
        self.refreshControl.endRefreshing()
        self.topNavView.firstRightButton.isUserInteractionEnabled = true
        self.topNavView.secondRightButton.isUserInteractionEnabled = true
        self.reloadList()
        NotificationCenter.default.post(name: .accountDetailFetched, object: model)
    }
    
    func getAccountDetailsFail(showProgres: Bool) {
        if showProgres {
            self.stopProgress()
        }
        self.refreshControl.endRefreshing()
    }
    
    func searchEventsSuccess() {
        self.reloadList()
    }
}
