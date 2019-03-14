//
//  SelectTripVC.swift
//  AERTRIP
//
//  Created by Admin on 08/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol SelectTripVCDelegate: class {
    func selectTripVC(sender: SelectTripVC, didSelect trip: TripModel)
}

class SelectTripVC: BaseVC {
    
    //MARK:- IBOutlets
    //MARK:-
    @IBOutlet weak var topNavView: TopNavigationView!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.separatorStyle = .none
            tableView.showsVerticalScrollIndicator = false
            tableView.showsHorizontalScrollIndicator = false
        }
    }
    @IBOutlet weak var creatNewContainerView: UIView!
    @IBOutlet weak var creatNewButton: UIButton!
    
    //MARK:- Properties
    //MARK:- Public
    let viewModel = SelectTripVM()
    weak var delegate: SelectTripVCDelegate?
    
    //MARK:- Private
    private let cellIdentifier = "cellIdentifier"
    
    //MARK:- ViewLifeCycle
    //MARK:-
    override func initialSetup() {
        
        topNavView.delegate = self
        topNavView.configureNavBar(title: LocalizedString.SelectTrip.localized, isLeftButton: true, isFirstRightButton: true, isSecondRightButton: false, isDivider: true)
        
        topNavView.configureLeftButton(normalTitle: LocalizedString.Cancel.localized, normalColor: AppColors.themeGreen, font: AppFonts.Regular.withSize(18.0))
        
        topNavView.configureFirstRightButton(normalTitle: LocalizedString.Save.localized, normalColor: AppColors.themeGreen, font: AppFonts.SemiBold.withSize(18.0))
        
        viewModel.fetchAllTrips()
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
        
        self.statusBarStyle = .default
    }
    
    override func bindViewModel() {
        viewModel.delegate = self
    }
    
    //MARK:- Methods
    //MARK:- Private
    
    //MARK:- Public
    
    
    //MARK:- Action
    @IBAction func createNewButtonAction(_ sender: UIButton) {
        AppFlowManager.default.presentCreateNewTripVC(delegate: self, onViewController: self)
    }
}

//MARK:- CreateNewTripVC delegat methods
//MARK:-
extension SelectTripVC: CreateNewTripVCDelegate {
    func createNewTripVC(sender: CreateNewTripVC, didCreated trip: TripModel) {
        viewModel.allTrips.insert(trip, at: 0)
        viewModel.selectedIndexPath = IndexPath(row: 0, section: 0)
        tableView.reloadData()
    }
}

//MARK:- View Model delegat methods
//MARK:-
extension SelectTripVC: SelectTripVMDelegate{
    func willFetchAllTrips() {
    }
    
    func fetchAllTripsSuccess() {
        tableView.reloadData()
    }
    
    func fetchAllTripsFail() {
    }
}
//MARK:- Navigation View delegat methods
//MARK:-
extension SelectTripVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func topNavBarFirstRightButtonAction(_ sender: UIButton) {
        if let indexPath = viewModel.selectedIndexPath {
            self.delegate?.selectTripVC(sender: self, didSelect: viewModel.allTrips[indexPath.row])
        }
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK:- Table View Datasources and Delegates
//MARK:-
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
        cell?.textLabel?.text = viewModel.allTrips[indexPath.row].title
        cell?.tintColor = AppColors.themeGreen
        cell?.accessoryType = .none
        
        if let idxPath = viewModel.selectedIndexPath, idxPath.row == indexPath.row {
           cell?.accessoryType = .checkmark
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewModel.selectedIndexPath = indexPath
        tableView.reloadData()
    }
}
