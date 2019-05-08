//
//  AccountOutstandingLadgerVC.swift
//  AERTRIP
//
//  Created by Admin on 16/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class AccountOutstandingLadgerVC: BaseVC {
    
    enum ViewState {
        case searching
        case normal
    }

    //MARK:- IBOutlets
    //MARK:-
    @IBOutlet weak var topNavView: TopNavigationView!
    @IBOutlet weak var tableView: ATTableView!
    @IBOutlet var searchContainerView: UIView!
    @IBOutlet weak var blankSpaceView: UIView!
    @IBOutlet weak var searchBarContainerView: UIView!
    @IBOutlet weak var searchBar: ATSearchBar!
    @IBOutlet weak var subHeaderContainer: UIView!
    @IBOutlet weak var subHeaderContainerTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var subHeaderContainerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var summeryLabel: UILabel!
    @IBOutlet weak var grossOutstandingLabel: UILabel!
    @IBOutlet weak var onAccountLabel: UILabel!
    @IBOutlet weak var netOutstandingLabel: UILabel!
    @IBOutlet weak var grossOutstandingValueLabel: UILabel!
    @IBOutlet weak var onAccountValueLabel: UILabel!
    @IBOutlet weak var netOutstandingValueLabel: UILabel!
    @IBOutlet weak var searchDataContainerView: UIView!
    @IBOutlet weak var searchTableView: ATTableView!
    @IBOutlet weak var mainSearchBar: ATSearchBar!
    @IBOutlet weak var searchModeSearchBarTopConstraint: NSLayoutConstraint!
    
    
    //MARK:- Properties
    //MARK:- Public
    let viewModel = AccountOutstandingLadgerVM()
    
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
        
        self.topNavView.configureNavBar(title: LocalizedString.OutstandingLedger.localized, isLeftButton: true, isFirstRightButton: true, isSecondRightButton: false, isDivider: false)
        
        self.topNavView.delegate = self
        
        self.topNavView.configureFirstRightButton(normalImage: #imageLiteral(resourceName: "ic_three_dots"), selectedImage: #imageLiteral(resourceName: "ic_three_dots"))
        
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
        self.summeryLabel.font = AppFonts.Regular.withSize(14.0)
        
        self.grossOutstandingLabel.font = AppFonts.Regular.withSize(16.0)
        self.onAccountLabel.font = AppFonts.Regular.withSize(16.0)
        self.netOutstandingLabel.font = AppFonts.Regular.withSize(16.0)

        self.grossOutstandingValueLabel.font = AppFonts.Regular.withSize(16.0)
        self.onAccountValueLabel.font = AppFonts.Regular.withSize(16.0)
        self.netOutstandingValueLabel.font = AppFonts.Regular.withSize(16.0)
    }
    
    override func setupTexts() {
        self.summeryLabel.text = LocalizedString.Summary.localized
        
        self.grossOutstandingLabel.text = LocalizedString.GrossOutstanding.localized
        self.onAccountLabel.attributedText = AppGlobals.shared.getTextWithImage(startText: LocalizedString.OnAccount.localized, image: #imageLiteral(resourceName: "arrowNextScreen"), endText: "", font: AppFonts.Regular.withSize(16.0))
        self.netOutstandingLabel.text = LocalizedString.NetOutstanding.localized
        
        self.grossOutstandingValueLabel.text = Double(675640.74).amountInDelimeterWithSymbol + LocalizedString.DebitShort.localized
        self.onAccountValueLabel.text = Double(675640.74).amountInDelimeterWithSymbol + LocalizedString.CreditShort.localized
        self.netOutstandingValueLabel.text = Double(675640.74).amountInDelimeterWithSymbol + LocalizedString.CreditShort.localized
        
        self.searchBar.placeholder = LocalizedString.search.localized
        self.mainSearchBar.placeholder = LocalizedString.search.localized
    }
    
    override func setupColors() {
        self.summeryLabel.textColor = AppColors.themeGray40
        
        self.tableView.backgroundColor = AppColors.themeWhite
        
        self.searchContainerView.backgroundColor = AppColors.themeWhite
        self.searchBarContainerView.backgroundColor = AppColors.themeWhite
        self.blankSpaceView.backgroundColor = AppColors.themeGray04
    }
    
    //MARK:- Methods
    //MARK:- Private
    private func manageHeader(animated: Bool) {

        if (self.currentViewState == .normal) {
            self.subHeaderContainer.isHidden = false
            self.view.endEditing(true)
        }

        UIView.animate(withDuration: animated ? AppConstants.kAnimationDuration : 0.0, animations: { [weak self] in
            guard let sSelf = self else {return}
            
            if (sSelf.currentViewState == .searching) {
                sSelf.subHeaderContainerTopConstraint.constant = -(sSelf.subHeaderContainer.height)
                sSelf.subHeaderContainer.alpha = 0.0
                sSelf.tableView.tableHeaderView = nil
                sSelf.searchDataContainerView.isHidden = false
                sSelf.searchModeSearchBarTopConstraint.constant = 0.0
            }
            else {
                sSelf.subHeaderContainerTopConstraint.constant = 0.0
                sSelf.subHeaderContainer.alpha = 1.0
                sSelf.tableView.tableHeaderView = sSelf.searchContainerView
                sSelf.searchDataContainerView.isHidden = true
                sSelf.searchModeSearchBarTopConstraint.constant = 186.0
            }
            
            sSelf.view.layoutIfNeeded()
            
            }, completion: { [weak self](isDone) in
                guard let sSelf = self else {return}
                sSelf.subHeaderContainer.isHidden = (sSelf.currentViewState == .searching)
                sSelf.searchTableView.reloadData()
                if (sSelf.currentViewState == .searching) {
                    sSelf.mainSearchBar.becomeFirstResponder()
                }
        })
    }
    
    private func showMoreOptions() {
        let buttons = AppGlobals.shared.getPKAlertButtons(forTitles: [LocalizedString.SelectBookingsPay.localized, LocalizedString.Email.localized, LocalizedString.DownloadAsPdf.localized], colors: [AppColors.themeGreen, AppColors.themeGreen, AppColors.themeGreen])
        
        _ = PKAlertController.default.presentActionSheet(nil, message: nil, sourceView: self.view, alertButtons: buttons, cancelButton: AppGlobals.shared.pKAlertCancelButton) { _, index in
            if index == 0 {
                //select bookings pay
                printDebug("select bookings pay")
            }
            else if index == 1 {
                //email tapped
                printDebug("email tapped")
            }
            else {
                //download pdf tapped
                printDebug("download pdf tapped")
            }
        }
    }
    
    //MARK:- Public
    func reloadList() {
        self.tableView.backgroundView = self.noAccountTransectionView
        
        self.tableView.backgroundView?.isHidden = !self.viewModel.allDates.isEmpty
        self.tableView.isScrollEnabled = !self.viewModel.allDates.isEmpty
        self.tableView.reloadData()
    }
    
    func reloadSearchList() {
        self.searchTableView.reloadData()
    }
    
    //MARK:- Action
    @IBAction func onAccountButtonAction(_ sender: UIButton) {
        printDebug("onAccountButtonAction")
    }
}

//MARK:- SearchBar delegate Methods
//MARK:-
extension AccountOutstandingLadgerVC: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if searchBar === self.mainSearchBar {
            self.currentViewState = .normal
        }
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        if (searchBar === self.searchBar) {
            self.currentViewState = .searching
            return false
        }
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar === self.mainSearchBar, searchText.count >= AppConstants.kSearchTextLimit {
            self.noResultemptyView.searchTextLabel.isHidden = false
            self.noResultemptyView.searchTextLabel.text = "\(LocalizedString.For.localized) '\(searchText)'"
            self.viewModel.searchEvent(forText: searchText)
        }
        else {
            //reset tot the old state
            self.searchTableView.reloadData()
        }
    }
}

//MARK:- Nav bar delegate methods
//MARK:-
extension AccountOutstandingLadgerVC: TopNavigationViewDelegate {
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
extension AccountOutstandingLadgerVC: AccountOutstandingLadgerVMDelegate {
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
        self.reloadSearchList()
    }
}
