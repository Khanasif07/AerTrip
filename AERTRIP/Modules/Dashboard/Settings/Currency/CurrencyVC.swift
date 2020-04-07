//
//  CurrencyVC.swift
//  AERTRIP
//
//  Created by Appinventiv on 26/03/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

class CurrencyVC: BaseVC {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var topNavView: TopNavigationView!
    @IBOutlet weak var currencyTableView: UITableView!
    
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
        self.currencyVm.getCurrencies()
        self.currencyVm.preSelectIndia()
//        self.currencyVm.getCurrenciesFromApi()
    }
    
    func setUpViewAttributes(){
        self.searchBar.delegate = self
        searchBar.showsBookmarkButton = true
        searchBar.setImage(#imageLiteral(resourceName: "microphone"), for: .bookmark, state: .normal)
        searchBar.setTextField(color: AppColors.themeGray04)
        searchBar.backgroundImage = UIImage()
        searchBar.tintColor = AppColors.themeGreen
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        self.currencyVm.delegate = self
    }
    
    override func setupColors() {
        super.setupColors()
        searchBar.backgroundColor = UIColor.clear
    }
    
    override func setupFonts() {
        super.setupFonts()
        
    }
    
    override func setupTexts() {
        super.setupTexts()
        
    }
    
    private func configureTableView(){
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

extension CurrencyVC : UISearchBarDelegate {
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let txt = searchBar.text else { return }
        self.currencyVm.searchText = txt
        if txt.isEmpty{
            self.currencyVm.clearFilteredData()
            self.currencyTableView.reloadData()
        }else {
            self.currencyVm.filterCountries(txt: txt)
            noResultemptyView.searchTextLabel.isHidden = false
            noResultemptyView.searchTextLabel.text = "for \(searchText.quoted)"
            self.currencyTableView.reloadData()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
    }
}

extension CurrencyVC : CurrencyVcDelegate {
    func showUnderDevelopmentPopUp(){
        AppToast.default.showToastMessage(message: LocalizedString.ThisFunctionalityWillBeAvailableSoon.localized)

//        _ = ATAlertController.alert(title: "", message: LocalizedString.ThisFunctionalityWillBeAvailableSoon.localized, buttons: [LocalizedString.Ok.localized], tapBlock: nil)
    }
}


