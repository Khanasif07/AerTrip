//
//  TravellerListVC.swift
//  AERTRIP
//
//  Created by apple on 04/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class TravellerListVC: BaseVC {
    // MARK: - IB Outlets
    
    @IBOutlet var navigationTitleLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var searchBar: ATSearchBar!
    
    // MARK: - Variables
    
    var travellerListHeaderView: TravellerListHeaderView = TravellerListHeaderView()
    var tableViewHeaderCellIdentifier = "TravellerListTableViewSectionView"
    let cellIdentifier = "TravellerListTableViewCell"
    let viewModel = TravellerListVM()
    struct Objects {
        var sectionName: String!
        var sectionObjects: [TravellerModel]!
    }
    
    var objectArray = [Objects]()
    
    // MARK: - View Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doInitialSetUp()
        registerXib()
        viewModel.callSearchTravellerListAPI()
        setUpTravellerHeader()
    }
    
    override func viewDidLayoutSubviews() {
        guard let headerView = tableView.tableHeaderView else {
            return
        }
        
        let size = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        if headerView.frame.size.height != size.height {
            headerView.frame.size.height = size.height
            tableView.tableHeaderView = headerView
            tableView.layoutIfNeeded()
        }
    }
    
    override func bindViewModel() {
        viewModel.delegate = self
    }
    
    // MARK: - IB Action
    
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addTravellerTapped(_ sender: Any) {}
    
    @IBAction func popOverOptionTapped(_ sender: Any) {
        NSLog("edit buttn tapped")
        _ = AKAlertController.actionSheet(nil, message: nil, sourceView: view, buttons: [LocalizedString.Select.localized, LocalizedString.Preferences.localized, LocalizedString.Import.localized], tapBlock: { [weak self] _, index in
            
            if index == 0 {
                NSLog("select traveller")
            } else if index == 1 {
                NSLog("preferences  traveller")
                AppFlowManager.default.moveToPreferencesVC()
            } else if index == 2 {
                NSLog("import traveller")
            }
            
        })
    }
    
    // MARK: - Helper methods
    
    func doInitialSetUp() {
        navigationTitleLabel.text = LocalizedString.TravellerList.localized
        
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        travellerListHeaderView = TravellerListHeaderView.instanceFromNib()
        travellerListHeaderView.frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: view.frame.size.width, height: 44)
        tableView.tableHeaderView = travellerListHeaderView
        searchBar.delegate = self
    }
    
    func registerXib() {
        tableView.register(UINib(nibName: tableViewHeaderCellIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: tableViewHeaderCellIdentifier)
        tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
    }
    
    func setUpTravellerHeader() {
        let string = "\("\(UserInfo.loggedInUser?.firstName ?? "N")") \("\(UserInfo.loggedInUser?.lastName ?? "A")")"
        travellerListHeaderView.userNameLabel.text = string
        if UserInfo.loggedInUser?.profileImage != "" {
            travellerListHeaderView.profileImageView.kf.setImage(with: URL(string: UserInfo.loggedInUser?.profileImage ?? ""))
        } else {
            travellerListHeaderView.profileImageView.image = UserInfo.loggedInUser?.profileImagePlaceholder
        }
    }
}

extension TravellerListVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return objectArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objectArray[section].sectionObjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TravellerListTableViewCell else {
            fatalError("TravellerListTableViewCell not found")
        }
        cell.configureCell(salutation: objectArray[indexPath.section].sectionObjects[indexPath.row].salutation, dob: objectArray[indexPath.section].sectionObjects[indexPath.row].dob, userName: objectArray[indexPath.section].sectionObjects[indexPath.row].firstName)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: tableViewHeaderCellIdentifier) as? TravellerListTableViewSectionView else {
            fatalError("ViewProfileDetailTableViewSectionView not found")
        }
        print("section is \(Array(viewModel.travellersDict.keys)[section])")
        headerView.configureCell(Array(viewModel.travellersDict.keys)[section])
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog("\(indexPath.row) clicked")
    }
}

// MARK: - TravellerListVMDelegate methods

extension TravellerListVC: TravellerListVMDelegate {
    func willSearchForTraveller() {}
    
    func searchTravellerSuccess() {
        for (key, value) in viewModel.travellersDict {
            print("\(key) -> \(value)")
            objectArray.append(Objects(sectionName: key, sectionObjects: (value as! [TravellerModel])))
        }
        tableView.reloadData()
    }
    
    func searchTravellerFail() {}
}

// MARK: - UISearchBarDelegate methods

extension TravellerListVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count >= AppConstants.kSearchTextLimit {
            viewModel.searchTraveller(forText: searchText)
        }
    }
}
