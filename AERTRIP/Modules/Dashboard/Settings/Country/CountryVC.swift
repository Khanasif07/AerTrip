//
//  CountryVC.swift
//  AERTRIP
//
//  Created by Appinventiv on 26/03/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

class CountryVC : BaseVC {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var topNavView: TopNavigationView!
    @IBOutlet weak var countryTableView: UITableView!
    
    //MARK:- Properties
    let countryVm = CountryVM()
    
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
        self.topNavView.configureNavBar(title: LocalizedString.Country.localized, isLeftButton: true, isFirstRightButton: false, isSecondRightButton: false,isDivider : false)
        configureTableView()
        setUpViewAttributes()
        self.countryVm.getCountries()
        self.countryVm.preSelectIndia()
        self.countryTableView.reloadData()
    }
    
    func setUpViewAttributes(){
        searchBar.delegate = self
        searchBar.showsBookmarkButton = true
        searchBar.setImage(#imageLiteral(resourceName: "microphone"), for: .bookmark, state: .normal)
        searchBar.backgroundImage = UIImage()
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
        searchBar.backgroundColor = UIColor.clear
        searchBar.setTextField(color: AppColors.themeGray04)
    }
    
    private func configureTableView(){
        self.countryTableView.register(UINib(nibName: "CountryCell", bundle: nil), forCellReuseIdentifier: "CountryCell")
        self.countryTableView.dataSource = self
        self.countryTableView.delegate = self
    }
    
}

extension CountryVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        AppFlowManager.default.popViewController(animated: true)
    }
}

extension CountryVC : UISearchBarDelegate {
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let txt = searchBar.text else { return }
        self.countryVm.searchText = txt
        if txt.isEmpty{
            self.countryVm.clearFilteredData()
            self.countryTableView.reloadData()
        }else {
            self.countryVm.filterCountries(txt: txt)
            self.countryTableView.reloadData()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
}

extension CountryVC : CountryVcDelegate {
    func showUnderDevelopmentPopUp(){
       _ = ATAlertController.alert(title: "", message: LocalizedString.UnderDevelopment.localized, buttons: [LocalizedString.Ok.localized], tapBlock: nil)
    }
}
