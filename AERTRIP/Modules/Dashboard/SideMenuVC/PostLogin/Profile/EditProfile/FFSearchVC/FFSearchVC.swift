//
//  SearchVC.swift
//  AERTRIP
//
//  Created by apple on 26/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit

protocol SearchVCDelegate: class {
    func frequentFlyerSelected(_ flyer: FlyerModel)
}

class FFSearchVC: BaseVC {
    // MARK: - IB Outlets
    
    @IBOutlet weak var tableView: ATTableView!
    
    @IBOutlet weak var searchBar: ATSearchBar!
    @IBOutlet weak var topNavView: TopNavigationView!
    
    // MARK: - Variable
    
    let cellIdentifier = "SearchTableViewCell"
    var searchData: [FlyerModel] = []
    var defaultAirlines: [FlyerModel] = []
    let viewModel = FFSearchVM()
    weak var delgate: SearchVCDelegate?
    
    //MARK:- Private
    private lazy var emptyView: EmptyScreenView = {
        let newEmptyView = EmptyScreenView()
        newEmptyView.vType = .noResult
        return newEmptyView
    }()
    
    
    // MARK: - View Life cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.statusBarStyle = .default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        searchBar.placeholder = LocalizedString.SearchAirlines.localized
        searchBar.delegate = self
        
        doInitialSetUp()
        registerXib()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.statusBarStyle = .lightContent
    }
    
    //
    
    override func bindViewModel() {
        viewModel.delegate = self
    }
    
    // MARK: - Helper Methods
    
    func doInitialSetUp() {
        
        self.topNavView.delegate = self
        self.topNavView.configureNavBar(title: LocalizedString.FrequentFlyer.localized, isLeftButton: true, isFirstRightButton: false, isSecondRightButton: false, isDivider: false)
        self.topNavView.configureLeftButton(normalTitle: LocalizedString.Cancel.localized, normalColor: AppColors.themeGreen)
        searchData = defaultAirlines
        tableView.separatorStyle = .none
        tableView.backgroundView = emptyView
        tableView.reloadData()
    }
    
    func registerXib() {
        tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
    }
    
    private func searchForText(_ searchText: String) {
        if searchText.isEmpty {
            searchData.removeAll()
            searchData = defaultAirlines
            tableView.reloadData()
        }
        else {
            NSObject.cancelPreviousPerformRequests(withTarget: self)
            perform(#selector(performSearchForText(_:)), with: searchText, afterDelay: 0.5)
        }
    }
    
    @objc private func performSearchForText(_ searchText: String) {
        searchData.removeAll()
        tableView.reloadData()
        viewModel.webserviceForGetTravelDetail(searchText)
    }
}

// MARK: - UITableViewDataSource methods

extension FFSearchVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.backgroundView?.isHidden = !self.searchData.isEmpty
        return searchData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SearchTableViewCell else {
            fatalError("SearchTableViewCell not found")
        }
        if searchData.count > 0 {
            cell.configureCell(searchData[indexPath.row].logoUrl, searchData[indexPath.row].label, searchData[indexPath.row].iata)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delgate?.frequentFlyerSelected(searchData[indexPath.row])
        dismiss(animated: true, completion: nil)
    }
}

extension FFSearchVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

extension FFSearchVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchForText(searchText)
        emptyView.searchTextLabel.isHidden = false
        emptyView.searchTextLabel.text = "for \(searchText.quoted)"
        tableView.backgroundView = searchText.isEmpty ? nil : emptyView
    }
}

extension FFSearchVC: SearchVMDelegate {
    func willGetDetail() {
        //
    }
    
    func getSuccess(_ data: [FlyerModel]) {
        searchData = data
        tableView.reloadData()
    }
    
    func getFail(errors: ErrorCodes) {
    }
}
