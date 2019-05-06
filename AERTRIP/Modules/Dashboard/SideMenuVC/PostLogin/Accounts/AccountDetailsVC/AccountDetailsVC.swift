//
//  AccountDetailsVC.swift
//  AERTRIP
//
//  Created by Admin on 16/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class AccountDetailsVC: BaseVC {
    
    enum UsingMode {
        case normal
        case search
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
    @IBOutlet weak var balanceContainerTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchDataContainerView: UIView!
    @IBOutlet weak var searchTableView: ATTableView!
    @IBOutlet weak var mainSearchBar: ATSearchBar!
    @IBOutlet weak var searchModeSearchBarTopConstraint: NSLayoutConstraint!
    
    
    //MARK:- Properties
    //MARK:- Public
    let viewModel = AccountDetailsVM()
    
    //MARK:- Private
    private var currentUsingMode = UsingMode.normal {
        didSet {
            self.manageHeader(animated: true)
        }
    }
    
    // Empty State view
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
        
        self.topNavView.configureNavBar(title: LocalizedString.Accounts.localized, isLeftButton: true, isFirstRightButton: true, isSecondRightButton: true, isDivider: false)
        
        self.topNavView.delegate = self
        
        self.topNavView.configureFirstRightButton(normalImage: #imageLiteral(resourceName: "ic_three_dots"), selectedImage: #imageLiteral(resourceName: "ic_three_dots"))
        self.topNavView.configureSecondRightButton(normalImage: #imageLiteral(resourceName: "ic_hotel_filter"), selectedImage: #imageLiteral(resourceName: "ic_hotel_filter_applied"))
        
        //add search view in tableView header
        self.tableView.tableHeaderView = self.searchContainerView
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
        self.balanceTextLabel.font = AppFonts.Regular.withSize(14.0)
        self.balanceAmountLabel.font = AppFonts.SemiBold.withSize(28.0)
    }
    
    override func setupTexts() {
        self.balanceTextLabel.text = LocalizedString.Balance.localized
        self.balanceAmountLabel.text = "\(18992.0.amountInDelimeterWithSymbol)"
        
        self.searchBar.placeholder = LocalizedString.search.localized
        self.mainSearchBar.placeholder = LocalizedString.search.localized
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
    private func manageHeader(animated: Bool) {

        if (self.currentUsingMode == .normal) {
            self.balanceContainerView.isHidden = false
            self.view.endEditing(true)
        }

        UIView.animate(withDuration: animated ? AppConstants.kAnimationDuration : 0.0, animations: { [weak self] in
            guard let sSelf = self else {return}
            
            if (sSelf.currentUsingMode == .search) {
                sSelf.balanceContainerTopConstraint.constant = -(sSelf.balanceContainerView.height)
                sSelf.balanceContainerView.alpha = 0.0
                sSelf.tableView.tableHeaderView = nil
                sSelf.searchDataContainerView.isHidden = false
                sSelf.searchModeSearchBarTopConstraint.constant = 0.0
            }
            else {
                sSelf.balanceContainerTopConstraint.constant = 0.0
                sSelf.balanceContainerView.alpha = 1.0
                sSelf.tableView.tableHeaderView = sSelf.searchContainerView
                sSelf.searchDataContainerView.isHidden = true
                sSelf.searchModeSearchBarTopConstraint.constant = (sSelf.topNavView.height + sSelf.balanceContainerView.height + 35.0)
            }
            
            sSelf.view.layoutIfNeeded()
            
            }, completion: { [weak self](isDone) in
                guard let sSelf = self else {return}
                sSelf.balanceContainerView.isHidden = (sSelf.currentUsingMode == .search)
                sSelf.searchTableView.reloadData()
                if (sSelf.currentUsingMode == .search) {
                    sSelf.mainSearchBar.becomeFirstResponder()
                }
        })
    }
    
    //MARK:- Public
    func reloadList() {
        self.tableView.reloadData()
    }
    
    func reloadSearchList() {
        self.searchTableView.reloadData()
    }
    
    //MARK:- Action
}

//MARK:- SearchBar delegate Methods
//MARK:-
extension AccountDetailsVC: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if searchBar === self.mainSearchBar {
            self.currentUsingMode = .normal
        }
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        if searchBar === self.searchBar {
            self.currentUsingMode = .search
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
extension AccountDetailsVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        //back button action
        AppFlowManager.default.popViewController(animated: true)
    }
    
    func topNavBarFirstRightButtonAction(_ sender: UIButton) {
        //dots button action
    }
    
    func topNavBarSecondRightButtonAction(_ sender: UIButton) {
        //filter button action
        AppFlowManager.default.moveToADEventFilterVC(self)

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
        self.reloadSearchList()
    }
}
