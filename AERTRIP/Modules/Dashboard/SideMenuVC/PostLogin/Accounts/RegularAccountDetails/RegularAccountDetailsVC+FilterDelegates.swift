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
//        FirebaseAnalyticsController.shared.logEvent(name: "AccountsBackButtonClicked", params: ["ScreenName":"Accounts", "ScreenClass":"RegularAccountDetailsVC","AccountType":UserInfo.loggedInUser?.userCreditType ?? ""])

        FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.Accounts.rawValue, params: [AnalyticsKeys.FilterName.rawValue:FirebaseEventLogs.EventsTypeName.navigateBack, AnalyticsKeys.FilterType.rawValue: "LoggedInUserType", AnalyticsKeys.Values.rawValue: UserInfo.loggedInUser?.userCreditType ?? "n/a"])

        ADEventFilterVM.shared.setToDefault()
        AppFlowManager.default.popViewController(animated: true)
    }
    
    func topNavBarFirstRightButtonAction(_ sender: UIButton) {
        //dots button action
//        FirebaseAnalyticsController.shared.logEvent(name: "AccountsMenuOptionClicked", params: ["ScreenName":"Accounts", "ScreenClass":"RegularAccountDetailsVC","AccountType":UserInfo.loggedInUser?.userCreditType ?? ""])

        FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.Accounts.rawValue, params: [AnalyticsKeys.FilterName.rawValue:FirebaseEventLogs.EventsTypeName.AccountsMenuOptionSelected, AnalyticsKeys.FilterType.rawValue: "LoggedInUserType", AnalyticsKeys.Values.rawValue: UserInfo.loggedInUser?.userCreditType ?? "n/a"])

        self.showMoreOptions()
    }
    
    func topNavBarSecondRightButtonAction(_ sender: UIButton) {
        //filter button action
//        FirebaseAnalyticsController.shared.logEvent(name: "AccountsFilterOptionClicked", params: ["ScreenName":"Accounts", "ScreenClass":"RegularAccountDetailsVC","AccountType":UserInfo.loggedInUser?.userCreditType ?? ""])

        FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.Accounts.rawValue, params: [AnalyticsKeys.FilterName.rawValue:FirebaseEventLogs.EventsTypeName.AccountsFilterOptionSelected, AnalyticsKeys.FilterType.rawValue: "LoggedInUserType", AnalyticsKeys.Values.rawValue: UserInfo.loggedInUser?.userCreditType ?? "n/a"])

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
//        FirebaseAnalyticsController.shared.logEvent(name: "AccountsApplyFilterSelected", params: ["ScreenName":"Accounts", "ScreenClass":"RegularAccountDetailsVC","AccountType":UserInfo.loggedInUser?.userCreditType ?? ""])

        FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.Accounts.rawValue, params: [AnalyticsKeys.FilterName.rawValue:FirebaseEventLogs.EventsTypeName.AccoutsApplyFilterOptionSelected, AnalyticsKeys.FilterType.rawValue: "LoggedInUserType", AnalyticsKeys.Values.rawValue: UserInfo.loggedInUser?.userCreditType ?? "n/a"])

        if ADEventFilterVM.shared.isFilterAplied  {
            self.currentViewState = .filterApplied
        } else {
            self.currentViewState =  self.currentViewState == .filterApplied ? .normal : self.currentViewState
        }
        self.viewModel.applyFilter(searchText: self.mainSearchBar.text ?? "")
    }
    func clearAllFilter() {
        //clear all filter
//        FirebaseAnalyticsController.shared.logEvent(name: "AccountsClearAllOptionSelected", params: ["ScreenName":"Accounts", "ScreenClass":"RegularAccountDetailsVC","AccountType":UserInfo.loggedInUser?.userCreditType ?? ""])

        FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.Accounts.rawValue, params: [AnalyticsKeys.FilterName.rawValue:FirebaseEventLogs.EventsTypeName.AccountsClearAllFilterOptionSelected, AnalyticsKeys.FilterType.rawValue: "LoggedInUserType", AnalyticsKeys.Values.rawValue: UserInfo.loggedInUser?.userCreditType ?? "n/a"])

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
//        FirebaseAnalyticsController.shared.logEvent(name: "AccountsSpeechToTextOptionSelected", params: ["ScreenName":"Accounts", "ScreenClass":"RegularAccountDetailsVC","AccountType":UserInfo.loggedInUser?.userCreditType ?? ""])

        FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.Accounts.rawValue, params: [AnalyticsKeys.FilterName.rawValue:FirebaseEventLogs.EventsTypeName.AccountsSpeechToTextOptionSelected, AnalyticsKeys.FilterType.rawValue: "LoggedInUserType", AnalyticsKeys.Values.rawValue: UserInfo.loggedInUser?.userCreditType ?? "n/a"])

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
//        FirebaseAnalyticsController.shared.logEvent(name: "AccountsConvertedSpeechToText", params: ["ScreenName":"Accounts", "ScreenClass":"RegularAccountDetailsVC","AccountType":UserInfo.loggedInUser?.userCreditType ?? "","SearchQuery":text])

        FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.Accounts.rawValue, params: [AnalyticsKeys.FilterName.rawValue:FirebaseEventLogs.EventsTypeName.AccountsConvertedSpeechToText, AnalyticsKeys.FilterType.rawValue: "LoggedInUserType", AnalyticsKeys.Values.rawValue: UserInfo.loggedInUser?.userCreditType ?? "n/a", AnalyticsKeys.FilterName.rawValue:"SearchQuery", AnalyticsKeys.FilterType.rawValue:"n/a", AnalyticsKeys.Values.rawValue:text])

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
//        FirebaseAnalyticsController.shared.logEvent(name: "AccountsSearchBarCancelButtonClicked", params: ["ScreenName":"Accounts", "ScreenClass":"RegularAccountDetailsVC","AccountType":UserInfo.loggedInUser?.userCreditType ?? ""])

        FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.Accounts.rawValue, params: [AnalyticsKeys.FilterName.rawValue:FirebaseEventLogs.EventsTypeName.AccountsCancelSearchBarOptionSelected, AnalyticsKeys.FilterType.rawValue: "LoggedInUserType", AnalyticsKeys.Values.rawValue: UserInfo.loggedInUser?.userCreditType ?? "n/a"])

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
//            FirebaseAnalyticsController.shared.logEvent(name: "AccountsSearchButtonClicked", params: ["ScreenName":"Accounts", "ScreenClass":"RegularAccountDetailsVC","AccountType":UserInfo.loggedInUser?.userCreditType ?? "","SearchQuery":mainSearchBar.text ?? ""])

            FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.Accounts.rawValue, params: [AnalyticsKeys.FilterName.rawValue:FirebaseEventLogs.EventsTypeName.AccountSearchOptionSelected, AnalyticsKeys.FilterType.rawValue: "LoggedInUserType", AnalyticsKeys.Values.rawValue: UserInfo.loggedInUser?.userCreditType ?? "n/a", AnalyticsKeys.FilterName.rawValue:"SearchQuery", AnalyticsKeys.FilterType.rawValue:"n/a", AnalyticsKeys.Values.rawValue:mainSearchBar.text ?? ""])

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
//        FirebaseAnalyticsController.shared.logEvent(name: "AccountsSpeechToTextOptionSelected", params: ["ScreenName":"Accounts", "ScreenClass":"RegularAccountDetailsVC","AccountType":UserInfo.loggedInUser?.userCreditType ?? ""])

        FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.Accounts.rawValue, params: [AnalyticsKeys.FilterName.rawValue:FirebaseEventLogs.EventsTypeName.AccountsSpeechToTextOptionSelected, AnalyticsKeys.FilterType.rawValue: "LoggedInUserType", AnalyticsKeys.Values.rawValue: UserInfo.loggedInUser?.userCreditType ?? "n/a"])

        AppFlowManager.default.moveToSpeechToText(with: self)
    }
}
