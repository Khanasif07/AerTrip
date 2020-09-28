//
//  CountryVC.swift
//  AERTRIP
//
//  Created by Appinventiv on 26/03/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

class CountryVC : BaseVC {
    
    //@IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var topNavView: TopNavigationView!
    @IBOutlet weak var countryTableView: UITableView!
//    @IBOutlet weak var searchBarBackView: UIView!
    @IBOutlet weak var searchBarSepratorView: ATDividerView!
    @IBOutlet weak var searchBar: ATSearchBar! {
        didSet {
            self.searchBar.backgroundColor = AppColors.clear
            self.searchBar.delegate = self
            self.searchBar.placeholder = LocalizedString.search.localized
        }
    }
    
    
    //MARK:- Properties
    let countryVm = CountryVM()
    
    lazy var noResultemptyView: EmptyScreenView = {
        let newEmptyView = EmptyScreenView()
        newEmptyView.vType = .noResult
        return newEmptyView
    }()
    
    
    //MARK:- ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetups()
    }
    
    //MARK:- Methods
    //MARK:- Private
    private func initialSetups() {
        self.topNavView.delegate = self
        self.topNavView.configureNavBar(title: LocalizedString.Country.localized, isLeftButton: true, isFirstRightButton: false, isSecondRightButton: false,isDivider : false)
        configureTableView()
        setUpViewAttributes()
        self.countryVm.getCountries()
        self.countryVm.preSelectIndia()
        self.countryTableView.reloadData()
        self.searchBar.cornerradius = 10.0
        self.searchBar.clipsToBounds = true
    }
    
    func setUpViewAttributes(){
       // self.searchBarBackView.roundedCorners(cornerRadius: 10)
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        self.countryVm.delegate = self
    }
    
    override func setupFonts() {
        super.setupFonts()
    }
    
    override func setupColors() {
        super.setupColors()
      //  self.searchBarBackView.backgroundColor = AppColors.themeGray04
      //  self.searchBarSepratorView.backgroundColor = AppColors.themeGray20
    }
    
    private func configureTableView(){
        self.countryTableView.register(UINib(nibName: "CountryCell", bundle: nil), forCellReuseIdentifier: "CountryCell")
        self.countryTableView.dataSource = self
        self.countryTableView.delegate = self
        self.countryTableView.backgroundView = noResultemptyView
    }
}

extension CountryVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        AppFlowManager.default.popViewController(animated: true)
    }
}

extension CountryVC : CountryVcDelegate {
    func showUnderDevelopmentPopUp(){
        AppToast.default.showToastMessage(message: LocalizedString.ThisFunctionalityWillBeAvailableSoon.localized)
        
    //   _ = ATAlertController.alert(title: "", message: LocalizedString.ThisFunctionalityWillBeAvailableSoon.localized, buttons: [LocalizedString.Ok.localized], tapBlock: nil)
    }
}
extension CountryVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        search(searchText)
    }
    
    @objc private func search(_ forText: String) {
        printDebug(forText)
        self.countryVm.searchText = forText
        if forText.isEmpty{
            self.countryVm.clearFilteredData()
            self.countryTableView.reloadData()
        }else {
            self.countryVm.filterCountries(txt: forText)
            noResultemptyView.searchTextLabel.isHidden = false
            noResultemptyView.searchTextLabel.text = "for \(forText.quoted)"
            self.countryTableView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
}
