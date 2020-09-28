//
//  CurrencyVC.swift
//  AERTRIP
//
//  Created by Appinventiv on 26/03/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

class CurrencyVC: BaseVC {
    
    @IBOutlet weak var topNavView: TopNavigationView!
    @IBOutlet weak var currencyTableView: UITableView!
    @IBOutlet weak var searchBarSepratorView: ATDividerView!
    @IBOutlet weak var searchBar: ATSearchBar! {
        didSet {
            self.searchBar.backgroundColor = AppColors.clear
            self.searchBar.delegate = self
            self.searchBar.placeholder = LocalizedString.search.localized
        }
    }
    
    //MARK:- Properties
    let currencyVm = CurrencyVM()
    lazy var noResultemptyView: EmptyScreenView = {
        let newEmptyView = EmptyScreenView()
        newEmptyView.vType = .noResult
        return newEmptyView
    }()
    
    //MARK:- ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.initialSetups()
    }
    
    //MARK:- Methods
    //MARK:- Private
    private func initialSetups() {
        self.topNavView.delegate = self
        self.topNavView.configureNavBar(title: LocalizedString.Currency.localized, isLeftButton: true, isFirstRightButton: false, isSecondRightButton: false,isDivider : false)
        configureTableView()
        setUpViewAttributes()
//        self.currencyVm.getCurrencies()
        self.currencyVm.getCurrenciesFromApi()
        self.searchBar.cornerradius = 10.0
        self.searchBar.clipsToBounds = true
    }
    
    func setUpViewAttributes(){
//        self.searchTextField.delegate = self
//        self.searchTextField.addTarget(self, action: #selector(self.textFieldValueChanged(_:)), for: UIControl.Event.editingChanged)
//        self.searchBarBackView.roundedCorners(cornerRadius: 10)
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        self.currencyVm.delegate = self
    }
    
    override func setupColors() {
        super.setupColors()
//        self.searchBarBackView.backgroundColor = AppColors.themeGray04
      //  self.searchBarSepratorView.backgroundColor = AppColors.themeGray20
//               searchTextField.setAttributedPlaceHolder(placeHolderText: LocalizedString.search.localized, color: AppColors.themeGray40, font: AppFonts.Regular.withSize(18))
    }
    
    override func setupFonts() {
        super.setupFonts()
//        self.searchTextField.font = AppFonts.Regular.withSize(18)
    }
    
    override func setupTexts() {
        super.setupTexts()
        
    }
    
    private func configureTableView(){
        self.noResultemptyView.isHidden = true
        self.currencyTableView.register(UINib(nibName: "CurrencyCell", bundle: nil), forCellReuseIdentifier: "CurrencyCell")
        self.currencyTableView.dataSource = self
        self.currencyTableView.delegate = self
        self.currencyTableView.backgroundView = noResultemptyView
    }
}

extension CurrencyVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        AppFlowManager.default.popViewController(animated: true)
    }
}

//extension CurrencyVC : UISearchBarDelegate {
//
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        return true
//    }
//
//    @objc func textFieldValueChanged(_ textField : UITextField) {
//        guard let txt = textField.text else { return }
//         self.currencyVm.searchText = txt
//         if txt.isEmpty{
//             self.currencyVm.clearFilteredData()
//             self.currencyTableView.reloadData()
//         }else {
//             self.currencyVm.filterCountries(txt: txt)
//             noResultemptyView.searchTextLabel.isHidden = false
//             noResultemptyView.searchTextLabel.text = "for \(txt.quoted)"
//             self.currencyTableView.reloadData()
//         }
//    }
//}

extension CurrencyVC : CurrencyVcDelegate {
    
    func willGetCurrencies() {
        AppGlobals.shared.startLoading()
    }
    
    func getCurrenciesSuccessFull() {
        AppGlobals.shared.stopLoading()
        self.currencyTableView.reloadData()
    }
    
    func failedToGetCurrencies() {
        AppGlobals.shared.stopLoading()
        self.currencyVm.preSelectIndia()
        self.currencyTableView.reloadData()
    }
    
    func showUnderDevelopmentPopUp(){
        AppToast.default.showToastMessage(message: LocalizedString.ThisFunctionalityWillBeAvailableSoon.localized)
    }
}

extension CurrencyVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        search(searchText)
    }
    
    @objc private func search(_ forText: String) {
        printDebug(forText)
        self.currencyVm.searchText = forText
        if forText.isEmpty{
            self.currencyVm.clearFilteredData()
            self.currencyTableView.reloadData()
        }else {
            self.currencyVm.filterCountries(txt: forText)
            noResultemptyView.searchTextLabel.isHidden = false
            noResultemptyView.searchTextLabel.text = "for \(forText.quoted)"
            self.currencyTableView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
}
