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

protocol TripCancelDelegate:NSObjectProtocol {
    func addTripCancelled()
}

class SelectTripVC: BaseVC {
    
    // MARK: - IBOutlets
    
    // MARK: -
    
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
    
    // MARK: - Properties
    
    // MARK: - Public
    
    let viewModel = SelectTripVM()
    weak var delegate: SelectTripVCDelegate?
    weak var cancelDelegate:TripCancelDelegate?
    var selectionComplition: ((TripModel, TripDetails?) -> Void)?
    var presentingStatusBarStyle: UIStatusBarStyle = .darkContent
    var dismissalStatusBarStyle: UIStatusBarStyle = .darkContent
    
    // MARK: - Private
    
    private let cellIdentifier = "cellIdentifier"
    
    // MARK: - ViewLifeCycle
    
    // MARK: -
    
    override func initialSetup() {
        self.tableView.contentInset = UIEdgeInsets(top: topNavView.height , left: 0.0, bottom: 10.0, right: 0.0)

        let swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        swipeGesture.delegate = self
        self.view.addGestureRecognizer(swipeGesture)
        
        
        topNavView.delegate = self
        topNavView.firstLeftButtonLeadingConst.constant = 5.0
        topNavView.configureNavBar(title: LocalizedString.SelectTrip.localized, isLeftButton: true, isFirstRightButton: true, isSecondRightButton: false, isDivider: true)
        
        topNavView.configureLeftButton(normalTitle: LocalizedString.Cancel.localized, normalColor: AppColors.themeGreen, font: AppFonts.Regular.withSize(18.0))
        
        var btnTitle: String = ""
        
        if viewModel.usingFor == .bookingTripChange {
            btnTitle = LocalizedString.Move.localized
        } else {
            btnTitle = viewModel.tripDetails == nil ? LocalizedString.Save.localized : LocalizedString.Move.localized
        }
        
        topNavView.configureFirstRightButton(normalTitle: btnTitle, normalColor: AppColors.themeGreen, font: AppFonts.SemiBold.withSize(18.0))
        
        if viewModel.allTrips.isEmpty {
            viewModel.fetchAllTrips()
        }
        viewModel.setSelectedTripIndexPath()
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
        
        statusBarStyle = presentingStatusBarStyle
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        statusBarStyle = dismissalStatusBarStyle
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
    
    func moveAndUpdateTripAPIFail() {
        AppToast.default.showToastMessage(message: LocalizedString.SomethingWentWrong.localized)
    }
    
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
        self.cancelDelegate?.addTripCancelled()
        dismiss(animated: true, completion: nil)
    }
    
    func topNavBarFirstRightButtonAction(_ sender: UIButton) {
        
        switch self.viewModel.usingFor{
        case .hotel, .flight:
            if viewModel.selectedIndexPath != nil {
                selectionCompleted()
            } else {
                AppToast.default.showToastMessage(message: LocalizedString.PleaseSelectTrip.localized)
                
            }
        case .bookingTripChange, .bookingAddToTrip:
            if  let indexPath = viewModel.selectedIndexPath {
                // move and update trip
                viewModel.moveAndUpdateTripAPI(selectedTrip: viewModel.allTrips[indexPath.row])
            } else {
                if viewModel.usingFor == .bookingTripChange {
                    AppToast.default.showToastMessage(message: LocalizedString.PleaseSelectTrip.localized)
                } else {
                    selectionCompleted()
                }
            }
        }
    }
    
    func selectionCompleted() {
        if let indexPath = viewModel.selectedIndexPath {
            if let handler = self.selectionComplition {
                handler(viewModel.allTrips[indexPath.row], viewModel.tripDetails)
            }
            if viewModel.tripDetails == nil {
                var trip = TripDetails()
                trip.event_id = viewModel.eventId
                trip.trip_id = viewModel.allTrips[indexPath.row].id
                trip.name = viewModel.allTrips[indexPath.row].name
                viewModel.tripDetails = trip
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
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }
        
        cell?.textLabel?.font = AppFonts.Regular.withSize(18.0)
        cell?.textLabel?.text = viewModel.allTrips[indexPath.row].name
        cell?.tintColor = AppColors.themeGreen
        cell?.accessoryView = nil
        
        if let idxPath = viewModel.selectedIndexPath, idxPath.row == indexPath.row {
            let checkMarckImageView = UIImageView(image: UIImage(named: "checkIcon"))
            checkMarckImageView.contentMode = .center
            cell?.accessoryView = checkMarckImageView
        }
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectedIndexPath = indexPath
        tableView.reloadData()
    }
}

extension SelectTripVC {
    
    @objc func handleSwipes(_ sender: UIPanGestureRecognizer) {
        let touchPoint = sender.location(in: view?.window)
        var initialTouchPoint = CGPoint.zero
        
        switch sender.state {
        case .began:
            initialTouchPoint = touchPoint
        case .changed:
            if touchPoint.y > initialTouchPoint.y {
                view.frame.origin.y = touchPoint.y - initialTouchPoint.y
            }
        case .ended, .cancelled:
            if touchPoint.y - initialTouchPoint.y > 300 {
                dismiss(animated: true, completion: nil)
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.view.frame = CGRect(x: 0,
                                             y: 0,
                                             width: self.view.frame.size.width,
                                             height: self.view.frame.size.height)
                })
            }
        case .failed, .possible:
            break
        }
    }
}
