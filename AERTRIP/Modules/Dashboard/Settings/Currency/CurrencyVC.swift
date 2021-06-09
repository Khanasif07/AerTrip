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
    @IBOutlet weak var searchBarContainer: UIView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var progressViewHeight: NSLayoutConstraint!
    
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
        delay(seconds: 0.1) {
            self.currencyVm.getCurrenciesFromApi()
        }
        self.searchBar.cornerradius = 10.0
        self.searchBar.clipsToBounds = true
        self.currencyTableView.contentInset = UIEdgeInsets(top: topNavView.height + self.searchBarContainer.height, left: 0, bottom: 0, right: 0)
        self.progressView.progressTintColor = UIColor.AertripColor
        self.progressView.trackTintColor = .clear
        self.currencyTableView.isHidden = true
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
        
        self.view.backgroundColor = AppColors.themeWhite
        
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
    
    func showProgressView(){
        UIView.animate(withDuration: 2) {[weak self] in
            guard let self = self else {return}
            self.progressView.isHidden = false
            self.progressViewHeight.constant = 1
        }
    }
    
    func hideProgressView(){
        UIView.animate(withDuration: 2) {[weak self] in
        guard let self = self else {return}
            self.progressViewHeight.constant = 0
            self.progressView.isHidden = true
        }
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
//        AppGlobals.shared.startLoading()
        
        delay(seconds: 0.5){[weak self] in
        guard let self = self else {return}
         UIView.animate(withDuration: 2){[weak self] in
         guard let self = self else {return}
             self.progressView.setProgress(0.25, animated: true)
         }
            
            UIView.animate(withDuration: 2) {
                self.progressView.setProgress(0.25, animated: true)

            } completion: { (success) in
                
                UIView.animate(withDuration: 2) {
                    self.progressView.setProgress(0.50, animated: true)
                } completion: { (success) in
                    
                }
            }
        }
        
    }
    
    func getCurrenciesSuccessFull() {
//        AppGlobals.shared.stopLoading()
        
        UIView.animate(withDuration: 2) {
            self.progressView.setProgress(1, animated: true)
        } completion: { (success) in
                self.currencyTableView.isHidden = false
                self.hideProgressView()
            self.currencyTableView.reloadData()
        }
        
    }
    
    func failedToGetCurrencies() {
//        AppGlobals.shared.stopLoading()
        self.hideProgressView()
//        self.currencyVm.preSelectIndia()
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
