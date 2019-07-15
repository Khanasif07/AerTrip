//
//  SelectTripVC.swift
//  AERTRIP
//
//  Created by Admin on 08/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol SelectTripVCDelegate: class {
    func selectTripVC(sender: SelectTripVC, didSelect trip: TripModel, tripDetails: TripDetails?)
}

class SelectTripVC: BaseVC {
    // MARK: - IBOutlets
    
    // MARK: -
    
    @IBOutlet var topNavView: TopNavigationView!
    @IBOutlet var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.separatorStyle = .none
            tableView.showsVerticalScrollIndicator = false
            tableView.showsHorizontalScrollIndicator = false
        }
    }
    
    @IBOutlet var creatNewContainerView: UIView!
    @IBOutlet var creatNewButton: UIButton!
    
    // MARK: - Properties
    
    // MARK: - Public
    
    let viewModel = SelectTripVM()
    weak var delegate: SelectTripVCDelegate?
    var selectionComplition: ((TripModel, TripDetails?) -> Void)?
    
    // MARK: - Private
    
    private let cellIdentifier = "cellIdentifier"
    
    // MARK: - ViewLifeCycle
    
    // MARK: -
    
    override func initialSetup() {
        topNavView.delegate = self
        topNavView.configureNavBar(title: LocalizedString.SelectTrip.localized, isLeftButton: true, isFirstRightButton: true, isSecondRightButton: false, isDivider: true)
        
        topNavView.configureLeftButton(normalTitle: LocalizedString.Cancel.localized, normalColor: AppColors.themeGreen, font: AppFonts.Regular.withSize(18.0))
        
        var btnTitle: String = ""
        
        if viewModel.usingFor == .bookingTripChange {
            btnTitle = LocalizedString.Move.localized
        } else {
            btnTitle = viewModel.tripDetails == nil ? LocalizedString.Add.localized : LocalizedString.Move.localized
        }
        
        topNavView.configureFirstRightButton(normalTitle: btnTitle, normalColor: AppColors.themeGreen, font: AppFonts.SemiBold.withSize(18.0))
        
        if viewModel.allTrips.isEmpty {
            viewModel.fetchAllTrips()
        }
    }
    
    override func setupColors() {
        creatNewButton.setTitleColor(AppColors.themeGreen, for: .normal)
        
        AppGlobals.shared.addBlurEffect(forView: creatNewContainerView)
    }
    
    override func setupTexts() {
        creatNewButton.setTitle(LocalizedString.CreateNewTrip.localized, for: .normal)
    }
    
    override func setupFonts() {
        creatNewButton.titleLabel?.font = AppFonts.Regular.withSize(18.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        statusBarStyle = .default
    }
    
    override func bindViewModel() {
        viewModel.delegate = self
    }
    
    // MARK: - Methods
    
    // MARK: - Private
    
    // MARK: - Public
    
    // MARK: - Action
    
    @IBAction func createNewButtonAction(_ sender: UIButton) {
        AppFlowManager.default.presentCreateNewTripVC(delegate: self, onViewController: self)
    }
}

// MARK: - CreateNewTripVC delegat methods

// MARK: -

extension SelectTripVC: CreateNewTripVCDelegate {
    func createNewTripVC(sender: CreateNewTripVC, didCreated trip: TripModel) {
        viewModel.allTrips.insert(trip, at: 0)
        viewModel.selectedIndexPath = IndexPath(row: 0, section: 0)
        tableView.reloadData()
    }
}

// MARK: - View Model delegat methods

// MARK: -

extension SelectTripVC: SelectTripVMDelegate {
    func willMoveAndUpdateTripAPI() {}
    
    func moveAndUpdateTripAPISuccess() {
        selectionCompleted()
    }
    
    func moveAndUpdateTripAPIFail() {}
    
    func willFetchAllTrips() {}
    
    func fetchAllTripsSuccess() {
        tableView.reloadData()
    }
    
    func fetchAllTripsFail() {}
}

// MARK: - Navigation View delegat methods

// MARK: -

extension SelectTripVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func topNavBarFirstRightButtonAction(_ sender: UIButton) {
        if  let indexPath = viewModel.selectedIndexPath {
            // move and update trip
            viewModel.moveAndUpdateTripAPI(selectedTrip: viewModel.allTrips[indexPath.row])
        } else {
            selectionCompleted()
        }
    }
    
    func selectionCompleted() {
        if let indexPath = viewModel.selectedIndexPath {
            if let handler = self.selectionComplition {
                handler(viewModel.allTrips[indexPath.row], viewModel.tripDetails)
            }
            delegate?.selectTripVC(sender: self, didSelect: viewModel.allTrips[indexPath.row], tripDetails: viewModel.tripDetails)
        }
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Table View Datasources and Delegates

// MARK: -

extension SelectTripVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.allTrips.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }
        
        cell?.textLabel?.font = AppFonts.Regular.withSize(18.0)
        cell?.textLabel?.text = viewModel.allTrips[indexPath.row].name
        cell?.tintColor = AppColors.themeGreen
        cell?.accessoryType = .none
        
        if let idxPath = viewModel.selectedIndexPath, idxPath.row == indexPath.row {
            cell?.accessoryType = .checkmark
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectedIndexPath = indexPath
        tableView.reloadData()
    }
}
