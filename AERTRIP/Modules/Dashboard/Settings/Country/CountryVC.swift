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
    @IBOutlet weak var searchBarBackView: UIView!
    @IBOutlet weak var searchBarSepratorView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var micButton: UIButton!
    
    
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
    }
    
    func setUpViewAttributes(){
        self.searchTextField.delegate = self
        self.searchTextField.addTarget(self, action: #selector(self.textFieldValueChanged(_:)), for: UIControl.Event.editingChanged)
        self.searchBarBackView.roundedCorners(cornerRadius: 10)
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        self.countryVm.delegate = self
    }
    
    override func setupFonts() {
        super.setupFonts()
        self.searchTextField.font = AppFonts.Regular.withSize(18)
    }
    
    override func setupColors() {
        super.setupColors()
        self.searchBarBackView.backgroundColor = AppColors.themeGray04
        self.searchBarSepratorView.backgroundColor = AppColors.themeGray20
        searchTextField.setAttributedPlaceHolder(placeHolderText: LocalizedString.search.localized, color: AppColors.themeGray40, font: AppFonts.Regular.withSize(18))
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

extension CountryVC  {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    @objc func textFieldValueChanged(_ textField : UITextField) {
        guard let txt = textField.text else { return }
        self.countryVm.searchText = txt
        if txt.isEmpty{
            self.countryVm.clearFilteredData()
            self.countryTableView.reloadData()
        }else {
            self.countryVm.filterCountries(txt: txt)
            noResultemptyView.searchTextLabel.isHidden = false
            noResultemptyView.searchTextLabel.text = "for \(txt.quoted)"
            self.countryTableView.reloadData()
        }
    }
    

    
}

extension CountryVC : CountryVcDelegate {
    func showUnderDevelopmentPopUp(){
        AppToast.default.showToastMessage(message: LocalizedString.ThisFunctionalityWillBeAvailableSoon.localized)
        
    //   _ = ATAlertController.alert(title: "", message: LocalizedString.ThisFunctionalityWillBeAvailableSoon.localized, buttons: [LocalizedString.Ok.localized], tapBlock: nil)
    }
}
