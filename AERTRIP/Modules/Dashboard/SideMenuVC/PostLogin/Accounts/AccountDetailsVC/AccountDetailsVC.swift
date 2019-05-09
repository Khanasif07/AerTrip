//
//  AccountDetailsVC.swift
//  AERTRIP
//
//  Created by Admin on 16/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

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
    @IBOutlet weak var tableView: ATTableView!
    @IBOutlet var searchContainerView: UIView!
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
    
    
    //MARK:- Properties
    //MARK:- Public
    let viewModel = AccountDetailsVM()
    var currentUsingAs = UsingFor.account
    
    //MARK:- Private
    private var currentViewState = ViewState.normal {
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
        return newEmptyView
    }()
    
    lazy var noResultemptyView: EmptyScreenView = {
        let newEmptyView = EmptyScreenView()
        newEmptyView.vType = .noResult
        return newEmptyView
    }()
    
    //MARK:- ViewLifeCycle
    //MARK:-
    override func initialSetup() {
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.manageSubView()
        let navTitle = (self.currentUsingAs == .account) ? LocalizedString.Accounts.localized : LocalizedString.AccountsLegder.localized
        self.topNavView.configureNavBar(title: navTitle, isLeftButton: true, isFirstRightButton: true, isSecondRightButton: true, isDivider: false)
        
        self.topNavView.delegate = self
        
        self.topNavView.configureFirstRightButton(normalImage: #imageLiteral(resourceName: "ic_three_dots"), selectedImage: #imageLiteral(resourceName: "ic_three_dots"))
        self.topNavView.configureSecondRightButton(normalImage: #imageLiteral(resourceName: "ic_hotel_filter"), selectedImage: #imageLiteral(resourceName: "ic_hotel_filter_applied"))
        
        //add search view in tableView header
        self.tableView.register(DateTableHeaderView.self, forHeaderFooterViewReuseIdentifier: "DateTableHeaderView")
        self.tableView.registerCell(nibName: AccountDetailEventHeaderCell.reusableIdentifier)
        self.tableView.registerCell(nibName: AccountDetailEventDescriptionCell.reusableIdentifier)
        
        self.searchBar.isMicEnabled = true
        
        self.topNavView.firstRightButton.isEnabled = false
        self.topNavView.secondRightButton.isEnabled = false
        self.viewModel.getAccountDetails()
        
        self.searchDataContainerView.backgroundColor = AppColors.themeBlack.withAlphaComponent(0.4)
        self.mainSearchBar.showsCancelButton = true
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
    }
    
    override func bindViewModel() {
        self.viewModel.delegate = self
    }
    
    override func setupFonts() {
        self.balanceTextLabel.font = AppFonts.Regular.withSize(14.0)
        self.balanceAmountLabel.font = AppFonts.SemiBold.withSize(28.0)
    }
    
    override func setupTexts() {
        self.balanceTextLabel.text = LocalizedString.Balance.localized
        self.balanceAmountLabel.text = "\(18992.0.amountInDelimeterWithSymbol)"
        
        self.searchBar.placeholder = LocalizedString.search.localized
        self.mainSearchBar.placeholder = LocalizedString.search.localized
        self.ladgerDummySearchBar.placeholder = LocalizedString.search.localized
    }
    
    override func setupColors() {
        self.balanceTextLabel.textColor = AppColors.themeGray40
        
        self.tableView.backgroundColor = AppColors.themeWhite
        
        self.searchContainerView.backgroundColor = AppColors.themeWhite
        self.searchBarContainerView.backgroundColor = AppColors.themeWhite
        self.blankSpaceView.backgroundColor = AppColors.themeGray04
    }
    
    //MARK:- Methods
    //MARK:- Private
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
                }
        })
    }
    
    private func showMoreOptions() {
        let buttons = AppGlobals.shared.getPKAlertButtons(forTitles: [LocalizedString.Email.localized, LocalizedString.DownloadAsPdf.localized], colors: [AppColors.themeGreen, AppColors.themeGreen])
        
        _ = PKAlertController.default.presentActionSheet(nil, message: nil, sourceView: self.view, alertButtons: buttons, cancelButton: AppGlobals.shared.pKAlertCancelButton) { _, index in
            if index == 0 {
                //email tapped
                printDebug("email tapped")
            } else {
                //download pdf tapped
                printDebug("download pdf tapped")
            }
        }
    }
    
    //MARK:- Public
    func reloadList() {
        self.tableView.backgroundView = (self.currentViewState == .filterApplied) ? self.noAccountResultView : self.noAccountTransectionView
        
        self.tableView.backgroundView?.isHidden = !self.viewModel.allDates.isEmpty
        self.tableView.isScrollEnabled = !self.viewModel.allDates.isEmpty
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
        self.viewModel.searchedAccountDetails.removeAll()
        self.viewModel.accountDetails = self.viewModel._accountDetails
        self.reloadList()
    }
    
    func preserveSearchData() {
        self.searchBar.text = self.mainSearchBar.text
        self.ladgerDummySearchBar.text = self.mainSearchBar.text
        self.viewModel.accountDetails = self.viewModel.searchedAccountDetails
        self.reloadList()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if searchBar === self.mainSearchBar {
            self.currentViewState = .normal
            self.clearSearchData()
        }
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        if (searchBar === self.searchBar) || (searchBar === self.ladgerDummySearchBar) {
            self.currentViewState = .searching
            return false
        }
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.preserveSearchData()
        self.currentViewState = .normal
        self.view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar === self.mainSearchBar, searchText.count >= AppConstants.kSearchTextLimit {
            self.noResultemptyView.searchTextLabel.isHidden = false
            self.noResultemptyView.searchTextLabel.text = "\(LocalizedString.For.localized) '\(searchText)'"
            self.viewModel.searchEvent(forText: searchText)
        }
        else {
            //reset tot the old state
            if (searchBar.text ?? "").isEmpty {
                self.clearSearchData()
            }
            else {
                self.reloadList()
            }
        }
    }
}

//MARK:- Nav bar delegate methods
//MARK:-
extension AccountDetailsVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        //back button action
        AppFlowManager.default.popViewController(animated: true)
    }
    
    func topNavBarFirstRightButtonAction(_ sender: UIButton) {
        //dots button action
        self.showMoreOptions()
    }
    
    func topNavBarSecondRightButtonAction(_ sender: UIButton) {
        //filter button action
        AppFlowManager.default.moveToADEventFilterVC()
    }
}


//MARK:- View model delegate methods
//MARK:-
extension AccountDetailsVC: AccountDetailsVMDelegate {
    func willGetAccountDetails() {
    }
    
    func getAccountDetailsSuccess() {
        self.topNavView.firstRightButton.isEnabled = true
        self.topNavView.secondRightButton.isEnabled = true
        self.reloadList()
    }
    
    func getAccountDetailsFail() {
    }
    
    func searchEventsSuccess() {
        self.reloadList()
    }
}
