//
//  RagularAccountDetailsVC.swift
//  AERTRIP
//
//  Created by Appinventiv  on 03/03/21.
//  Copyright © 2021 Pramod Kumar. All rights reserved.
//

import UIKit

class RegularAccountDetailsVC: BaseVC {
    
    @IBOutlet weak var topNavView: TopNavigationView!
    @IBOutlet weak var tableView: ATTableView!
    @IBOutlet weak var searchDataContainerView: UIView!
    @IBOutlet weak var searchTableView: ATTableView!
    @IBOutlet weak var mainSearchBar: ATSearchBar!
    @IBOutlet weak var searchModeSearchBarTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleHeaderView: UIView!
    @IBOutlet weak var titleHeaderTopConstraints: NSLayoutConstraint!
    
    
    @IBOutlet weak var openingDetailContainerView: UIView!
    @IBOutlet weak var openingBalanceTitleLabel: UILabel!
    @IBOutlet weak var openingBalanceDateLabel: UILabel!
    @IBOutlet weak var openingBalanceAmountLabel: UILabel!
    
    
    enum ViewState {
        case searching
        case filterApplied
        case normal
    }
    
    enum UsingFor {
        case account
        case accountLadger
    }

    let viewModel = AccountDetailsVM()
    var currentUsingAs = UsingFor.account
    var currentViewState = ViewState.normal {
        didSet {
            self.manageHeader(animated: true)
        }
    }
    private let headaerHeight:CGFloat = 216
    var tableViewHeaderCellIdentifier = "TravellerListTableViewSectionView"
    var initailScrollPoint:CGFloat = 0.0
    
    let refreshControl = UIRefreshControl()
    
    lazy var headerView: RegularAccountHeader? = {
        let nib = UINib(nibName: "RegularAccountHeader", bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as? RegularAccountHeader
    }()
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerCell()
        self.setOpeningBalanceView()
        self.setRefreshController()
        self.bindingDelegates()
        self.currentViewState = .normal
        self.viewModel.getAccountDetails(showProgres: true)
        self.setHeaderView()
        self.setMainSearchBar()
        self.setupNavigation()
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()

    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    override func dataChanged(_ note: Notification) {
        if let noti = note.object as? ATNotification, let usr = UserInfo.loggedInUser, usr.userCreditType == .regular {
            //re-hit the details API
            switch noti {
            case .accountPaymentRegister:
                self.viewModel.getAccountDetails(showProgres: true)
            default:
                break
            }
        }
    }
    
    @objc func accountDetailFetched(_ note: Notification) {
        if let object = note.object as? AccountDetailPostModel {
            printDebug("accountDetailFetched")
            self.viewModel.allVouchers = object.accVouchers
            self.viewModel.setAccountDetails(details: object.accountLadger)
        }
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
     self.viewModel.getAccountDetails(showProgres: false)
    }

    private func setHeaderView(){
        guard self.headerView != nil else{return}
        self.headerView?.frame = CGRect(
            x: 0,
            y: tableView.safeAreaInsets.top,
            width: view.frame.width,
            height: headaerHeight)
        titleHeaderView.addSubview(headerView!)
    }
    
    
    private func bindingDelegates(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.searchTableView.delegate  = self
        self.searchTableView.dataSource = self
        self.mainSearchBar.delegate  = self
        self.viewModel.delegate = self
        self.headerView?.delegate = self
    }
    
     private func setOpeningBalanceView() {
        self.openingBalanceTitleLabel.font = AppFonts.Regular.withSize(16.0)
        self.openingBalanceAmountLabel.font = AppFonts.Regular.withSize(16.0)
        self.openingBalanceDateLabel.font = AppFonts.Regular.withSize(14.0)
        self.openingBalanceTitleLabel.text = LocalizedString.OpeningBalance.localized
        self.openingBalanceDateLabel.text = ""
        self.openingBalanceTitleLabel.textColor = AppColors.themeBlack
        self.openingBalanceAmountLabel.textColor = AppColors.themeBlack
        self.openingBalanceDateLabel.textColor = AppColors.themeGray40
    }
    
    private func registerCell(){
        self.tableView.register(DateTableHeaderView.self, forHeaderFooterViewReuseIdentifier: "DateTableHeaderView")
        self.tableView.registerCell(nibName: AccountDetailEventHeaderCell.reusableIdentifier)
        self.tableView.registerCell(nibName: AccountDetailEventDescriptionCell.reusableIdentifier)
        self.tableView.register(UINib(nibName: tableViewHeaderCellIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: tableViewHeaderCellIdentifier)
        self.tableView.registerCell(nibName: AccountLedgerEventCell.reusableIdentifier)
        self.tableView.registerCell(nibName: NewAccountLedgerEventCell.reusableIdentifier)
        
        self.searchTableView.register(DateTableHeaderView.self, forHeaderFooterViewReuseIdentifier: "DateTableHeaderView")
        self.searchTableView.registerCell(nibName: AccountDetailEventHeaderCell.reusableIdentifier)
        self.searchTableView.registerCell(nibName: AccountDetailEventDescriptionCell.reusableIdentifier)
        self.searchTableView.register(UINib(nibName: tableViewHeaderCellIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: tableViewHeaderCellIdentifier)
        self.searchTableView.registerCell(nibName: AccountLedgerEventCell.reusableIdentifier)
        self.searchTableView.registerCell(nibName: NewAccountLedgerEventCell.reusableIdentifier)
    }
    
    private func setupNavigation(){
        let navTitle = LocalizedString.Accounts.localized
        self.topNavView.configureNavBar(title: navTitle, isLeftButton: true, isFirstRightButton: true, isSecondRightButton: true, isDivider: false)
        self.topNavView.delegate = self
        self.topNavView.configureFirstRightButton(normalImage: #imageLiteral(resourceName: "greenPopOverButton"), selectedImage: #imageLiteral(resourceName: "greenPopOverButton"))
        self.topNavView.configureSecondRightButton(normalImage: #imageLiteral(resourceName: "bookingFilterIcon"), selectedImage: #imageLiteral(resourceName: "bookingFilterIconSelected"))
        self.setNaviagationAndTitle(isNavFilter: false)
    }
    
    
    private func setMainSearchBar(){
        self.mainSearchBar.showsCancelButton = true
        if let cancelButton = mainSearchBar.value(forKey: "cancelButton") as? UIButton{
            cancelButton.titleLabel?.font = AppFonts.Regular.withSize(18)
        }
    }
    
    private func setRefreshController(){
        NotificationCenter.default.addObserver(self, selector: #selector(accountDetailFetched(_:)), name: .accountDetailFetched, object: nil)
        self.refreshControl.addTarget(self, action: #selector(self.handleRefresh(_:)), for: UIControl.Event.valueChanged)
        self.refreshControl.tintColor = AppColors.themeGreen
        self.tableView.refreshControl = refreshControl
        self.tableView.showsVerticalScrollIndicator = true
        
    }
    
    @IBAction func tapSearchContainerView(_ sender: UIButton) {
        self.currentViewState = .normal
        self.clearSearchData()
    }
    
    func showMoreOptions() {
        let buttons = AppGlobals.shared.getPKAlertButtons(forTitles: [LocalizedString.Email.localized, LocalizedString.DownloadAsPdf.localized], colors: [AppColors.themeDarkGreen, AppColors.themeDarkGreen])
        
        _ = PKAlertController.default.presentActionSheet(nil, message: nil, sourceView: self.view, alertButtons: buttons, cancelButton: AppGlobals.shared.pKAlertCancelButton) { _, index in
            if index == 0 {
                //email tapped
                AppToast.default.showToastMessage(message: "Sending email")
                self.viewModel.sendEmailForLedger(onVC: self)
            } else {
                //download pdf tapped
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
    
     func setupHeaderFooterText() {
        
        if let accountData = UserInfo.loggedInUser?.accountData {
            self.openingBalanceAmountLabel.attributedText = accountData.openingBalance.amountInDelimeterWithSymbol.asStylizedPrice(using: AppFonts.Regular.withSize(16.0))
            self.openingBalanceDateLabel.text = ""//"Upto Tue, 31 Jul 2018"
            self.headerView?.setAccountBalance()
        }else{
            self.headerView?.setAccountBalance()
        }
    }
    
    
    func manageHeader(animated: Bool) {

        if (self.currentViewState == .normal) {
            self.view.endEditing(true)
        }
        UIView.animate(withDuration: animated ? AppConstants.kAnimationDuration : 0.0, animations: { [weak self] in
            guard let self = self else {return}
            
            if (self.currentViewState == .searching) {
                self.titleHeaderTopConstraints.constant = -self.headaerHeight
                self.titleHeaderView.alpha = 0.0
                self.tableView.tableHeaderView = nil
                self.searchDataContainerView.isHidden = false
                self.searchModeSearchBarTopConstraint.constant = 0.0
            }
            else {
                self.titleHeaderTopConstraints.constant = 0.0
                self.titleHeaderView.alpha = 1.0
                self.searchDataContainerView.isHidden = true
                self.searchModeSearchBarTopConstraint.constant = (self.currentUsingAs == .account) ? 155.0 : 44.0
            }
            
            self.view.layoutIfNeeded()
            
            }, completion: { [weak self](isDone) in
                guard let self = self else {return}
                self.searchTableView.reloadData()
                if (self.currentViewState == .searching) {
                    self.mainSearchBar.becomeFirstResponder()
                    self.searchDataContainerView.backgroundColor = AppColors.themeBlack.withAlphaComponent(0.4)
                }
                else {
                    self.searchDataContainerView.backgroundColor = AppColors.clear
                }
                self.headerView?.filterButton.isSelected = (self.currentViewState == .filterApplied)
                self.topNavView.secondRightButton.isSelected = (self.currentViewState == .filterApplied)
        })
    }
    
    
    func reloadList() {
        
//        self.setupHeaderFooterText()

        self.tableView.backgroundView = (self.currentViewState == .filterApplied) ? self.noAccountResultView : self.noAccountTransectionView
        
        let isAllDatesEmpty = self.viewModel.allDates.isEmpty
        self.tableView.backgroundView?.isHidden = !isAllDatesEmpty
        self.tableView.isScrollEnabled = !isAllDatesEmpty

        if (ADEventFilterVM.shared.selectedVoucherType.isEmpty || ADEventFilterVM.shared.selectedVoucherType.count == ADEventFilterVM.shared.voucherTypes.count) && (ADEventFilterVM.shared.fromDate != nil || ADEventFilterVM.shared.toDate != nil){
                if let events = (self.viewModel.accountDetails[self.viewModel.allDates.last ?? ""] as? [AccountDetailEvent]), let event = events.last{
                    let balance = event.balance - event.amount
                    self.openingBalanceAmountLabel.attributedText = balance.amountInDelimeterWithSymbol.asStylizedPrice(using: AppFonts.Regular.withSize(16))
                }
                self.tableView.tableFooterView = isAllDatesEmpty ? nil : self.openingDetailContainerView
            }else{
                self.tableView.tableFooterView = nil
            }
        
        if self.viewModel.searchedAllDates.isEmpty && self.currentViewState == .searching{
            self.noResultemptyView.isHidden = false
            self.searchTableView.backgroundView = self.noResultemptyView
        }else{
            self.noResultemptyView.isHidden = true
            self.searchTableView.backgroundView = nil
        }
        
        self.tableView.reloadData()
        self.searchTableView.reloadData()
    }
    

}



//ScrollView delegate
extension RegularAccountDetailsVC{
     func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.tableView{
            self.updateTitleHeaderView(with: scrollView.contentOffset.y)
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        guard scrollView == self.tableView else {return}
        self.initailScrollPoint = scrollView.contentOffset.y
    }
    
    
    
    func updateTitleHeaderView(with offset: CGFloat){
        if offset <= headaerHeight{
            if offset <= 0{
                self.titleHeaderTopConstraints.constant = 0.0
            }else{
                self.titleHeaderTopConstraints.constant = -offset
            }
            
        }else{
            self.titleHeaderTopConstraints.constant = -headaerHeight
        }
        self.setHeaderTitles()
    }
    
    
    func setHeaderTitles(){
        guard self.titleHeaderTopConstraints.constant > -145.0  else {return}
        
        let isNeedToHide = self.titleHeaderTopConstraints.constant < -132.0
//        let difference:CGFloat = 145.0 + self.titleHeaderTopConstraints.constant
        let alpha:CGFloat = 1.0
//        if difference <= 0{
//            alpha = 0.0
//        }else if difference >= 23{
//            alpha = 1.0
//        }else{
//            alpha = 1.0/difference
//        }
        UIView.animate(withDuration: 0.2) {
            self.setNaviagationAndTitle(isNavFilter: isNeedToHide, with: alpha)
        }
    }
    
    
    func setNaviagationAndTitle(isNavFilter:Bool, with alpha: CGFloat = 1.0){
        if !isNavFilter{
            self.topNavView.firstRightButton.alpha = 1.0 - alpha
            self.topNavView.secondRightButton.alpha = 1.0 - alpha
            self.topNavView.firstRightButton.isUserInteractionEnabled = false
            self.topNavView.secondRightButton.isUserInteractionEnabled = false
            self.topNavView.navTitleLabel.text = LocalizedString.Accounts.localized
            self.headerView?.accountLaderTitleLabel.text = LocalizedString.AccountLegder.localized
            self.headerView?.accountLaderTitleLabel.alpha = alpha
            self.headerView?.filterButton.alpha = alpha
            self.headerView?.optionButton.alpha = alpha
        }else{
            self.topNavView.firstRightButton.alpha = alpha
            self.topNavView.secondRightButton.alpha = alpha
            self.topNavView.firstRightButton.isUserInteractionEnabled = true
            self.topNavView.secondRightButton.isUserInteractionEnabled = true
            self.topNavView.navTitleLabel.text = LocalizedString.AccountLegder.localized
            self.headerView?.accountLaderTitleLabel.alpha = 1.0 - alpha
            self.headerView?.filterButton.alpha = 1.0 - alpha
            self.headerView?.optionButton.alpha = 1.0 - alpha
        }
    }
}


//MARK:- View model delegate methods
//MARK:-
extension RegularAccountDetailsVC: AccountDetailsVMDelegate {
    
    func applyFilterSuccess() {
        self.reloadList()
    }
    
    func applyFilterFail() {
        self.reloadList()
    }

    func willGetAccountDetails(showProgres: Bool) {
        if showProgres {
            self.headerView?.startProgress()
        }
        //AppGlobals.shared.startLoading()
//        self.topNavView.firstRightButton.isUserInteractionEnabled = false
//        self.topNavView.secondRightButton.isUserInteractionEnabled = false
    }
    
    func getAccountDetailsSuccess(model: AccountDetailPostModel, showProgres: Bool) {
        if showProgres {
            self.headerView?.stopProgress()
        }
        self.refreshControl.endRefreshing()
        if self.currentViewState == .filterApplied {
            self.viewModel.applyFilter(searchText: self.mainSearchBar.text ?? "")
        } else if self.currentViewState == .filterApplied {
            self.viewModel.searchEvent(forText: self.mainSearchBar.text ?? "")
        }
        self.reloadList()
        self.tableView.reloadData()
        self.headerView?.setAccountBalance()
        NotificationCenter.default.post(name: .accountDetailFetched, object: model)
        
        

    }
    
    func getAccountDetailsFail(showProgres: Bool) {
        if showProgres {
            self.headerView?.stopProgress()
            self.manageDataForDeeplink()
            self.viewModel.deepLinkParams = [:]
        }
        self.refreshControl.endRefreshing()
    }
    
    func searchEventsSuccess() {
        self.reloadList()
    }
}


///Deeplinking  manage
extension RegularAccountDetailsVC{
    
    func manageDataForDeeplink(){
        switch  (self.viewModel.deepLinkParams["type"] ?? ""){
        case "accounts-ledger": self.moveToAccountLadge()
        default: break;
        }

    }

    func moveToAccountLadge(){
        guard let id  = self.viewModel.deepLinkParams["voucher_id"], !id.isEmpty, let event = self.viewModel.getEventFromAccountLadger(with: id) else {return}
            AppFlowManager.default.moveToAccountLadgerDetailsVC(forEvent: event, detailType: .accountLadger)

    }
    
}
