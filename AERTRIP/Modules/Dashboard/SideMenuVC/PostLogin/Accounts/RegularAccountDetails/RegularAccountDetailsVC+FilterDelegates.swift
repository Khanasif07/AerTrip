//
//  RegularAccountDetailsVC+FilterDelegates.swift
//  AERTRIP
//
//  Created by Appinventiv  on 04/03/21.
//  Copyright © 2021 Pramod Kumar. All rights reserved.
//

import Foundation
import IQKeyboardManager


//MARK:- Nav bar delegate methods
//MARK:-
extension RegularAccountDetailsVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        //back button action

        FirebaseEventLogs.shared.logEventsWithoutParam(with: .NavigateBack)

        ADEventFilterVM.shared.setToDefault()
        AppFlowManager.default.popViewController(animated: true)
    }
    
    func topNavBarFirstRightButtonAction(_ sender: UIButton) {
        //dots button action

        FirebaseEventLogs.shared.logAccountsEventsWithAccountType(with: .AccountsMenuOptionSelected, AccountType: UserInfo.loggedInUser?.userCreditType.rawValue ?? "n/a")
        
        self.showMoreOptions()
    }
    
    func topNavBarSecondRightButtonAction(_ sender: UIButton) {
        //filter button action

        FirebaseEventLogs.shared.logAccountsEventsWithAccountType(with: .AccountsFilterOptionSelected, AccountType: UserInfo.loggedInUser?.userCreditType.rawValue ?? "n/a")

        ADEventFilterVM.shared.minFromDate = self.viewModel.ledgerStartDate
        ADEventFilterVM.shared.voucherTypes = self.viewModel.allVouchers
        ADEventFilterVM.shared.minDate = self.viewModel.minDate
        ADEventFilterVM.shared.maxDate = self.viewModel.maxDate
        AppFlowManager.default.moveToADEventFilterVC(onViewController: self, delegate: self)
    }
}

//MARK:- Filter VC delegate methods
//MARK:-
extension RegularAccountDetailsVC: ADEventFilterVCDelegate {
    func applyFilter() {

        FirebaseEventLogs.shared.logAccountsEventsWithAccountType(with: .AccountsApplyFilterOptionSelected, AccountType: UserInfo.loggedInUser?.userCreditType.rawValue ?? "n/a")

        if ADEventFilterVM.shared.isFilterAplied  {
            self.currentViewState = .filterApplied
        } else {
            self.currentViewState =  self.currentViewState == .filterApplied ? .normal : self.currentViewState
        }
        self.viewModel.applyFilter(searchText: self.mainSearchBar.text ?? "")
    }
    func clearAllFilter() {
        //clear all filter

        FirebaseEventLogs.shared.logAccountsEventsWithAccountType(with: .AccountsClearAllFilterOptionSelected, AccountType: UserInfo.loggedInUser?.userCreditType.rawValue ?? "n/a")

        self.currentViewState = .normal
        self.viewModel.applyFilter(searchText: self.mainSearchBar.text ?? "")
    }
    
    
}

//MARK:- EmptyScreenViewdelegate methods
//MARK:-
extension RegularAccountDetailsVC: EmptyScreenViewDelegate {
    func firstButtonAction(sender: ATButton) {
    }
    func bottomButtonAction(sender: UIButton) {
        //clear all filter
        self.currentViewState = .normal
        ADEventFilterVM.shared.setToDefault()
        self.viewModel.applyFilter(searchText: self.mainSearchBar.text ?? "")
    }
}


extension RegularAccountDetailsVC: RegularAccountHeaderDelegate{
    func searchbarTapped() {
        IQKeyboardManager.shared().isEnableAutoToolbar = false
        self.currentViewState = .searching
    }
    
    func searchBarMicButtonTapped() {

        FirebaseEventLogs.shared.logAccountsEventsWithAccountType(with: .AccountsSpeechToTextOptionSelected, AccountType: UserInfo.loggedInUser?.userCreditType.rawValue ?? "n/a")

        
        AppFlowManager.default.moveToSpeechToText(with: self)
    }
    
    func headerFilterButtonIsTapped() {
        ADEventFilterVM.shared.minFromDate = self.viewModel.ledgerStartDate
        ADEventFilterVM.shared.voucherTypes = self.viewModel.allVouchers
        ADEventFilterVM.shared.minDate = self.viewModel.minDate
        ADEventFilterVM.shared.maxDate = self.viewModel.maxDate
        AppFlowManager.default.moveToADEventFilterVC(onViewController: self, delegate: self)
    }
    
    func headerOptionButtonIsTapped() {
        self.showMoreOptions()
    }
}

extension RegularAccountDetailsVC: SpeechToTextVCDelegate{
    func getSpeechToText(_ text: String) {
        
        
        let jsonDict : JSONDictionary = ["LoggedInUserType":UserInfo.loggedInUser?.userCreditType ?? "n/a",
                        "SearchQuery":text]
        FirebaseEventLogs.shared.logSearchBarEvents(with: .AccountsConvertedSpeechToText, value:  jsonDict  )

        guard !text.isEmpty else {return}
        self.currentViewState = .searching
        self.mainSearchBar.text = text
        viewModel.searchEvent(forText: text)
    }

    
}



//MARK:- SearchBar delegate Methods
//MARK:-
extension RegularAccountDetailsVC: UISearchBarDelegate {
    
    func clearSearchData() {
        self.mainSearchBar.text = ""
        self.searchTableView.backgroundView = nil
        self.viewModel.setSearchedAccountDetails(data: [:])
        self.viewModel.setAccountDetails(data: self.viewModel._accountDetails)
        self.applyFilter()
        self.reloadList()
    }
    
    func preserveSearchData() {

        self.viewModel.setAccountDetails(data: self.viewModel.searchedAccountDetails)
        self.reloadList()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {

        FirebaseEventLogs.shared.logAccountsEventsWithAccountType(with: .AccountsCancelSearchBarOptionSelected, AccountType: UserInfo.loggedInUser?.userCreditType.rawValue ?? "n/a")

        if searchBar === self.mainSearchBar {
            self.currentViewState = .normal
            self.clearSearchData()
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        if searchBar === self.mainSearchBar, (searchBar.text ?? "").isEmpty {
            self.searchBarCancelButtonClicked(searchBar)
        }
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        IQKeyboardManager.shared().isEnableAutoToolbar = false
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if (searchBar.text?.isEmpty ?? false){
            self.searchBarCancelButtonClicked(searchBar)
        }else{
            let jsonDict : JSONDictionary = ["LoggedInUserType":UserInfo.loggedInUser?.userCreditType ?? "n/a",
                            "SearchQuery":mainSearchBar.text ?? ""]
            FirebaseEventLogs.shared.logSearchBarEvents(with: .AccountSearchOptionSelected, value:  jsonDict  )


            self.preserveSearchData()
            self.view.endEditing(true)
        }
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar === self.mainSearchBar {
            self.currentViewState = .searching
            //searchText.count >= AppConstants.kSearchTextLimit
            self.viewModel.searchEvent(forText: searchText)
            if !searchText.isEmpty {
                self.noResultemptyView.isHidden = true
                self.noResultemptyView.searchTextLabel.isHidden = false
                self.noResultemptyView.searchTextLabel.text = "\(LocalizedString.For.localized) '\(searchText)'"
            } else {
                self.clearSearchData()
            }
        }

    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {

        FirebaseEventLogs.shared.logAccountsEventsWithAccountType(with: .AccountsSpeechToTextOptionSelected, AccountType: UserInfo.loggedInUser?.userCreditType.rawValue ?? "n/a")

        AppFlowManager.default.moveToSpeechToText(with: self)
    }
}
