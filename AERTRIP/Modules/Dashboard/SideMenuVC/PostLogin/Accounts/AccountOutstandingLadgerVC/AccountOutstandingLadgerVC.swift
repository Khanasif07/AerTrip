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
        case selecting
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
    @IBOutlet weak var makePaymentContainerView: UIView!
    @IBOutlet weak var payableAmountLabel: UILabel!
    @IBOutlet weak var makePaymentTitleLabel: UILabel!
    @IBOutlet weak var makePaymentContainerHeightConstraint: NSLayoutConstraint!
    
    
    //MARK:- Properties
    //MARK:- Public
    let viewModel = AccountOutstandingLadgerVM()
    
    //MARK:- Private
    private(set) var currentViewState = ViewState.normal {
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
        self.tableView.registerCell(nibName: AccountOutstandingEventDescriptionCell.reusableIdentifier)
        
        self.searchBar.isMicEnabled = true
        
        self.searchDataContainerView.backgroundColor = AppColors.themeBlack.withAlphaComponent(0.4)
        self.mainSearchBar.showsCancelButton = true
        self.searchBar.delegate = self
        self.mainSearchBar.delegate = self
        
        self.searchTableView.delegate = self
        self.searchTableView.dataSource = self
        self.searchTableView.backgroundView = self.noResultemptyView
        self.searchTableView.register(DateTableHeaderView.self, forHeaderFooterViewReuseIdentifier: "DateTableHeaderView")
        self.searchTableView.registerCell(nibName: AccountDetailEventHeaderCell.reusableIdentifier)
        self.searchTableView.registerCell(nibName: AccountOutstandingEventDescriptionCell.reusableIdentifier)
        
        self.manageHeader(animated: false)
        self.manageMakePaymentView(isHidden: true, animated: true)
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
        
        self.payableAmountLabel.font = AppFonts.SemiBold.withSize(20.0)
        self.makePaymentTitleLabel.font = AppFonts.SemiBold.withSize(20.0)
    }
    
    override func setupTexts() {
        self.summeryLabel.text = LocalizedString.Summary.localized
        
        self.grossOutstandingLabel.text = LocalizedString.GrossOutstanding.localized
        self.onAccountLabel.attributedText = AppGlobals.shared.getTextWithImage(startText: LocalizedString.OnAccount.localized, image: #imageLiteral(resourceName: "arrowNextScreen"), endText: "", font: AppFonts.Regular.withSize(16.0))
        self.netOutstandingLabel.text = LocalizedString.NetOutstanding.localized
        
        let drAttr = NSMutableAttributedString(string: LocalizedString.DebitShort.localized, attributes: [.font: AppFonts.Regular.withSize(16.0)])
        let crAttr = NSMutableAttributedString(string: LocalizedString.CreditShort.localized, attributes: [.font: AppFonts.Regular.withSize(16.0)])

        let gross = Double(675640.74).amountInDelimeterWithSymbol.asStylizedPrice(using: AppFonts.Regular.withSize(16.0))
        gross.append(drAttr)
        self.grossOutstandingValueLabel.attributedText = gross
        
        let onAcc = Double(675640.74).amountInDelimeterWithSymbol.asStylizedPrice(using: AppFonts.Regular.withSize(16.0))
        onAcc.append(crAttr)
        self.onAccountValueLabel.attributedText = onAcc
        
        let netOut = Double(675640.74).amountInDelimeterWithSymbol.asStylizedPrice(using: AppFonts.Regular.withSize(16.0))
        netOut.append(crAttr)
        self.netOutstandingValueLabel.attributedText = netOut
        
        self.searchBar.placeholder = LocalizedString.search.localized
        self.mainSearchBar.placeholder = LocalizedString.search.localized
    }
    
    override func setupColors() {
        self.summeryLabel.textColor = AppColors.themeGray40
        
        self.tableView.backgroundColor = AppColors.themeWhite
        
        self.searchContainerView.backgroundColor = AppColors.themeWhite
        self.searchBarContainerView.backgroundColor = AppColors.themeWhite
        self.blankSpaceView.backgroundColor = AppColors.themeGray04
        
        self.payableAmountLabel.textColor = AppColors.themeWhite
        self.makePaymentTitleLabel.textColor = AppColors.themeWhite
        
        self.makePaymentContainerView.addGredient(isVertical: false)
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
        
        var titles = [LocalizedString.Email.localized, LocalizedString.DownloadAsPdf.localized]
        if self.currentViewState == .selecting {
            titles.insert("De\(LocalizedString.SelectBookingsPay.localized.lowercased())", at: 0)
        }
        else {
            titles.insert(LocalizedString.SelectBookingsPay.localized, at: 0)
        }
        let buttons = AppGlobals.shared.getPKAlertButtons(forTitles: titles, colors: [AppColors.themeGreen, AppColors.themeGreen, AppColors.themeGreen])
        
        _ = PKAlertController.default.presentActionSheet(nil, message: nil, sourceView: self.view, alertButtons: buttons, cancelButton: AppGlobals.shared.pKAlertCancelButton) { _, index in
            if index == 0 {
                //select bookings pay
                if self.currentViewState == .selecting {
                    self.currentViewState = .normal
                }
                else {
                    self.currentViewState = .selecting
                }
                self.reloadList()
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
    
    private func manageMakePaymentView(isHidden: Bool, animated: Bool) {
        
        if isHidden {
            self.makePaymentContainerView.isHidden = false
        }
        
        UIView.animate(withDuration: animated ? AppConstants.kAnimationDuration : 0.0, animations: { [weak self] in
            guard let sSelf = self else {return}
            sSelf.makePaymentContainerHeightConstraint.constant = isHidden ? 0.0 : 50.0
        }) { [weak self](isDone) in
            guard let sSelf = self else {return}
            
            sSelf.makePaymentContainerView.isHidden = isHidden
        }
    }
    
    private func setPayableAmount() {
        var totalAmount: Double = Double(675640.74)
        
        let selected = self.viewModel.totalAmountForSelected
        if self.currentViewState == .selecting, selected > 0.0 {
            totalAmount = selected
        }
        
        self.payableAmountLabel.attributedText = totalAmount.amountInDelimeterWithSymbol.asStylizedPrice(using: AppFonts.SemiBold.withSize(20.0))
        self.makePaymentTitleLabel.text = LocalizedString.MakePayment.localized
    }
    
    //MARK:- Public
    func reloadList() {
        
        self.setPayableAmount()
        
        self.tableView.backgroundView = self.noAccountTransectionView
        
        self.tableView.backgroundView?.isHidden = !self.viewModel.allDates.isEmpty
        self.tableView.isScrollEnabled = !self.viewModel.allDates.isEmpty
        self.manageMakePaymentView(isHidden: self.viewModel.allDates.isEmpty, animated: true)
        self.tableView.reloadData()
        self.searchTableView.reloadData()
    }
    
    //MARK:- Action
    @IBAction func onAccountButtonAction(_ sender: UIButton) {
        AppFlowManager.default.moveToOnAccountDetailVC()
    }
}

//MARK:- SearchBar delegate Methods
//MARK:-
extension AccountOutstandingLadgerVC: UISearchBarDelegate {
    func clearSearchData() {
        self.mainSearchBar.text = ""
        self.searchBar.text = ""
        self.viewModel.searchedAccountDetails.removeAll()
        self.viewModel.accountDetails = self.viewModel._accountDetails
        self.reloadList()
    }
    
    func preserveSearchData() {
        self.searchBar.text = self.mainSearchBar.text
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
        if (searchBar === self.searchBar) {
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
        AppFlowManager.default.moveToADEventFilterVC(delegate: self, voucherTypes: ["Sales", "Receipt"], oldFilter: nil)
    }
}

//MARK:- Filter VC delegate methods
//MARK:-
extension AccountOutstandingLadgerVC: ADEventFilterVCDelegate {
    func adEventFilterVC(filterVC: ADEventFilterVC, didChangedFilter filter: AccountSelectedFilter?) {
        printDebug(filter)
    }
}


//MARK:- View model delegate methods
//MARK:-
extension AccountOutstandingLadgerVC: AccountOutstandingLadgerVMDelegate {
    func willGetAccountDetails() {
    }
    
    func getAccountDetailsSuccess() {
        self.reloadList()
    }
    
    func getAccountDetailsFail() {
    }
    
    func searchEventsSuccess() {
        self.reloadList()
    }
}
