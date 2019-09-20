//
//  SelectDestinationVC.swift
//  AERTRIP
//
//  Created by Admin on 23/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol SelectDestinationVCDelegate: class {
    func didSelectedDestination(hotel: SearchedDestination)
}

class SelectDestinationVC: BaseVC {
    
    enum CurrentlyUsingFor {
        case hotelForm, bulkBooking
    }
    
    var currentlyUsingFor: CurrentlyUsingFor = .hotelForm
    
    //MARK:- IBOutlets
    //MARK:-
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var searchBar: ATSearchBar! {
        didSet {
            searchBar.delegate = self
        }
    }
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var tableView: ATTableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    @IBOutlet weak var mainCintainerBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var rectangleView: UIView!
    @IBOutlet weak var bottomViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainContainerViewHeightConstraint: NSLayoutConstraint!

    
    
    //MARK:- Properties
    //MARK:- Public
    private(set) var viewModel = SelectDestinationVM()
    weak var delegate: SelectDestinationVCDelegate?
    
    //MARK:- Private
    private let headerCellId = "TravellerListTableViewSectionView"
    private let myLocationCellId = "DestinationMyLocationTableCell"
    private let searchedCellId = "DestinationSearchedTableCell"
    
    private var isInSearchMode: Bool = false
    private let maxItemInCategory: Int = 4
    
    private lazy var noResultemptyView: EmptyScreenView = {
        let newEmptyView = EmptyScreenView()
        newEmptyView.vType = .noResult
        return newEmptyView
    }()
    
    //MARK:- ViewLifeCycle
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.initialSetups()
    }
    
    override func setupFonts() {
        cancelButton.titleLabel?.font = AppFonts.Regular.withSize(18.0)
    }
    
    override func setupTexts() {
        
        cancelButton.setTitle(LocalizedString.Cancel.localized, for: .normal)
        cancelButton.setTitle(LocalizedString.Cancel.localized, for: .selected)
        
        searchBar.placeholder = LocalizedString.CityAreaOrHotels.localized
    }
    
    override func setupColors() {
        cancelButton.setTitleColor(AppColors.themeGreen, for: .normal)
        cancelButton.setTitleColor(AppColors.themeGreen, for: .selected)
        
        cancelButton.setTitle(LocalizedString.Cancel.localized, for: .selected)
    }
    
    override func bindViewModel() {
        self.viewModel.delegate = self
    }
    
    //MARK:- Methods
    //MARK:- Private
    private func initialSetups() {
        registerXib()
        
        self.view.alpha = 1.0
        self.view.backgroundColor = AppColors.clear//AppColors.themeBlack.withAlphaComponent(0.3)
        self.bottomViewHeightConstraint.constant = AppFlowManager.default.safeAreaInsets.bottom

        //self.headerView.roundCorners(corners: [.topLeft, .topRight], radius: 15.0)
        self.rectangleView.cornerRadius = 15.0
        self.rectangleView.layer.masksToBounds = true
        self.hide(animated: false)
        delay(seconds: 0.1) { [weak self] in
            self?.show(animated: true)
        }
        
        self.viewModel.getAllPopularHotels()
        
        self.tableView.backgroundView = self.noResultemptyView
    }
    
    private func registerXib() {
        
        tableView.register(UINib(nibName: headerCellId, bundle: nil), forHeaderFooterViewReuseIdentifier: headerCellId)
    }
    
    private func show(animated: Bool) {
        self.bottomView.isHidden = false
        let toDeduct = (AppFlowManager.default.safeAreaInsets.top + AppFlowManager.default.safeAreaInsets.bottom)
        let finalValue = (self.currentlyUsingFor == .hotelForm) ? (self.view.height - toDeduct) : (self.view.height - (15.0 + toDeduct))
        
        func setValue() {
            self.mainCintainerBottomConstraint.constant = 0.0
            self.mainContainerViewHeightConstraint.constant = finalValue
            self.view.backgroundColor = AppColors.themeBlack.withAlphaComponent(0.3)
            self.view.layoutIfNeeded()
        }
        
        if animated {
            let animater = UIViewPropertyAnimator(duration: AppConstants.kAnimationDuration, curve: .linear) {
                setValue()
            }
            
            animater.addCompletion { (position) in
                self.reloadData()
            }
            
            animater.startAnimation()
        }
        else {
            setValue()
        }
    }
    
    private func hide(animated: Bool, shouldRemove: Bool = false) {
        
        func setValue() {
            self.mainCintainerBottomConstraint.constant = -(self.mainContainerView.height + 100)
            self.view.backgroundColor = AppColors.themeBlack.withAlphaComponent(0.001)
            self.view.layoutIfNeeded()
        }
        
        self.bottomView.isHidden = true
        if animated {
            let animater = UIViewPropertyAnimator(duration: AppConstants.kAnimationDuration, curve: .linear) {
                setValue()
            }
            
            animater.addCompletion { (position) in
                if shouldRemove {
                    self.removeFromParentVC
                }
            }
            
            animater.startAnimation()
        }
        else {
            setValue()
        }
    }
    
    private func reloadData(){
        self.tableView.reloadData()
    }
    
    //MARK:- Public
    
    
    //MARK:- Action
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.hide(animated: true, shouldRemove: true)
    }
}

//MARK:- View Model Delegate
//MARK:-
extension SelectDestinationVC: SelectDestinationVMDelegate {
    
    func getAllPopularHotelsSuccess() {
        self.reloadData()
    }
    
    func getAllPopularHotelsFail() {
        self.reloadData()
    }
    
    func willSearchDestination() {
        self.tableView.backgroundView?.isHidden = true
    }
    
    func searchDestinationSuccess() {
        if isInSearchMode, let searchText = self.searchBar.text {
            self.noResultemptyView.messageLabel.text = "\(LocalizedString.noResults.localized + " " + LocalizedString.For.localized) '\(searchText)'"
            self.tableView.backgroundView?.isHidden = !self.viewModel.allTypes.isEmpty
        }
        else {
            self.noResultemptyView.messageLabel.text = ""
            self.tableView.backgroundView?.isHidden = true
        }
        self.reloadData()
    }
    
    func searchDestinationFail() {
        self.reloadData()
    }
    
    func getMyLocationSuccess(selected: SearchedDestination) {
        self.view.endEditing(true)
        self.hide(animated: true, shouldRemove: true)
        self.delegate?.didSelectedDestination(hotel: selected)
    }
    
    func getMyLocationFail() {
        printDebug("Error in searching Location")
    }
    
}

//MARK:- Search bar delegate
//MARK:-
extension SelectDestinationVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            //clear all data and reload to initial view
            self.isInSearchMode = false
        } else if searchText.count >= AppConstants.kSearchTextLimit {
            //search text
            self.isInSearchMode = true
            self.viewModel.searchDestination(forText: searchText)
        }
        
        self.reloadData()
    }
}

//MARK:- Table view datasource and delegate methods
//MARK:-
extension SelectDestinationVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if isInSearchMode {
            return self.viewModel.allTypes.count
        }
        else {
            tableView.backgroundView?.isHidden = true
            return (self.viewModel.recentSearchLimit > 0) ? 3 : 2
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isInSearchMode {
            let hotelsForSection = self.viewModel.searchedHotels[self.viewModel.allTypes[section].rawValue] as? [SearchedDestination] ?? []
            return min(hotelsForSection.count, maxItemInCategory)
        }
        else {
            
            if (self.viewModel.recentSearchLimit > 0) {
                return [1, self.viewModel.recentSearchLimit, self.viewModel.popularDestinationLimit][section]
            }
            else {
                return [1, self.viewModel.popularDestinationLimit][section]
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if isInSearchMode {
            return 28.0
        }
        else {
            switch section {
            case 0:
                //my location
                return 0
                
            case 1:
                //recent search,
                if let userId = UserInfo.loggedInUser?.userId ,!userId.isEmpty
                {
                    return 28.0
                } else {
                    return 0
                }
               
                //popular destination
            case 2:
                return 28.0
            default:
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerCellId) as? TravellerListTableViewSectionView else {
            return UIView()
        }
        
        if isInSearchMode {
            view.headerLabel.font = AppFonts.Regular.withSize(14.0)
            view.headerLabel.textColor = AppColors.themeGray60
            view.configureCell(self.viewModel.allTypes[section].title.uppercased())
        }
        else {
            
            var titleText = ""
            if section == 0 {
                return nil
            }
            else if (self.viewModel.recentSearchLimit > 0), (section == 1) {
                titleText = LocalizedString.RecentlySearchedDestinations.localized
            }
            else {
                titleText = LocalizedString.PopularDestinations.localized
            }
            
            view.headerLabel.font = AppFonts.Regular.withSize(14.0)
            view.headerLabel.textColor = AppColors.themeGray60
            view.configureCell(titleText.uppercased())
        }
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isInSearchMode {
            return 65.0
        }
        else {
            switch indexPath.section {
            case 0:
                //my location
                return 44.5//50.0
                
            case 1:
                //recent search
                if let userId = UserInfo.loggedInUser?.userId , !userId.isEmpty {
                      return 65.0
                } else {
                    return 0
                }
            case 2: // popular destination
                return 65.0
                
            default:
                return 0.0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if isInSearchMode {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: searchedCellId) as? DestinationSearchedTableCell else {
                return UITableViewCell()
            }
            
            let hotelsForSection = self.viewModel.searchedHotels[self.viewModel.allTypes[indexPath.section].rawValue] as? [SearchedDestination] ?? []
            cell.configureData(data: hotelsForSection[indexPath.row], forText: self.searchBar.text ?? "")
            cell.dividerView.isHidden = (min(hotelsForSection.count, maxItemInCategory) - 1) == indexPath.row
            
            return cell
        }
        else {
            switch indexPath.section {
            case 0:
                //my location
                guard let cell = tableView.dequeueReusableCell(withIdentifier: myLocationCellId) as? DestinationMyLocationTableCell else {
                    return UITableViewCell()
                }
                cell.configure(title: LocalizedString.HotelsNearMe.localized)
                return cell
                
            case 1, 2:
                //recent search, popular destination
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: searchedCellId) as? DestinationSearchedTableCell else {
                    return UITableViewCell()
                }
                
                
                if (self.viewModel.recentSearchLimit > 0), indexPath.section == 1 {
                    cell.configureData(data: self.viewModel.recentSearches[indexPath.row], forText: "")
                    cell.dividerView.isHidden = (self.viewModel.recentSearchLimit - 1) == indexPath.row
                }
                else {
                    cell.configureData(data: self.viewModel.popularHotels[indexPath.row], forText: "")
                }
                
                return cell
                
                
            default:
                return UITableViewCell()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 && !isInSearchMode {
            self.viewModel.hotelsNearByMe()
        } else {
            var selected = SearchedDestination(json: [:])
            if isInSearchMode {
                let hotelsForSection = self.viewModel.searchedHotels[self.viewModel.allTypes[indexPath.section].rawValue] as? [SearchedDestination] ?? []
                selected = hotelsForSection[indexPath.row]
            }
            else {
                if (self.viewModel.recentSearchLimit > 0), indexPath.section == 1 {
                    selected = self.viewModel.recentSearches[indexPath.row]
                }
                else {
                    selected = self.viewModel.popularHotels[indexPath.row]
                }
            }
            self.viewModel.updateRecentSearch(hotel: selected)
            self.view.endEditing(true)
            self.hide(animated: true, shouldRemove: true)
            self.delegate?.didSelectedDestination(hotel: selected)
        }
    }
}
