//
//  PassengersSelectionVC.swift
//  Aertrip
//
//  Created by Apple  on 04.05.20.
//  Copyright © 2020 Aertrip. All rights reserved.
//

import UIKit

class PassengersSelectionVC: UIViewController {

    @IBOutlet weak var backNavigationView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var passengerTableview: UITableView!
    @IBOutlet weak var tableViewBottomConsctraint: NSLayoutConstraint!
    
    var viewModel = PassengerSelectionVM()
    var intFareBreakupVC:IntFareBreakupVC?
    var detailsBaseVC:FlightDetailsBaseVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerCell()
        self.viewModel.setupGuestArray()
        self.setupFont()
        self.navigationController?.navigationBar.isHidden = true
        self.passengerTableview.separatorStyle = .none
        self.passengerTableview.delegate = self
        self.passengerTableview.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    
    
    private func registerCell(){
        self.passengerTableview.register(UINib(nibName: "FlightEmptyCell", bundle: nil), forCellReuseIdentifier: "FlightEmptyCell")
        self.passengerTableview.register(UINib(nibName: "FlightContactCell", bundle: nil), forCellReuseIdentifier: "FlightContactCell")
        self.passengerTableview.register(UINib(nibName: "PassengerGridCell", bundle: nil), forCellReuseIdentifier: "PassengerGridCell")
        self.passengerTableview.register(UINib(nibName: "FlightEmailFieldCell", bundle: nil), forCellReuseIdentifier: "FlightEmailFieldCell")
        self.passengerTableview.register(UINib(nibName: "UseGSTINCell", bundle: nil), forCellReuseIdentifier: "UseGSTINCell")
        self.passengerTableview.register(UINib(nibName: "CommunicationTextCell", bundle: nil), forCellReuseIdentifier: "CommunicarionCell")
    }
    
    
    private func setupFont(){
        self.navigationController?.navigationBar.tintColor = AppColors.themeGreen
        self.titleLabel.font = AppFonts.SemiBold.withSize(18)
        self.passengerTableview.backgroundColor = AppColors.themeGray04
        self.titleLabel.text = "Passengers"
        addButtomView()
        ///Uncomment once login flow is added.
//        DispatchQueue.main.async {
//            self.addButton.isHidden = !(self.viewModel.isLogin)
//        }
    }
    
    private func addButtomView(){
        let vc = IntFareBreakupVC.instantiate(fromAppStoryboard: .InternationalReturnAndMulticityDetails)
        vc.isFewSeatsLeftViewVisible = true
        vc.taxesResult = self.viewModel.taxesResult
        vc.journey = self.viewModel.intJourney
        vc.intFlights = self.viewModel.intFlights
        vc.delegate = self
        vc.detailsDelegate = self
        vc.sid = self.viewModel.sid
        if self.viewModel.intJourney.first?.fsr == 1{
            vc.fewSeatsLeftViewHeightFromFlightDetails = 40
        }else{
            vc.fewSeatsLeftViewHeightFromFlightDetails = 0
        }
        vc.isFromFlightDetails = false
        vc.isForSelectionAndCheckout = true
        vc.bookFlightObject = self.viewModel.bookingObject ?? BookFlightObject()
        vc.view.autoresizingMask = []
        self.view.addSubview(vc.view)
        self.addChild(vc)
        vc.didMove(toParent: self)
        self.intFareBreakupVC = vc
        
    }
    
    @IBAction func tapBackButton(_ sender: UIButton) {
        self.dismissAsPopAnimation()
    }
    
    @IBAction func tapAddButton(_ sender: UIButton) {
        AppFlowManager.default.presentHCSelectGuestsVC(delegate: self)
    }
    

}

extension PassengersSelectionVC: UseGSTINCellDelegate, FareBreakupVCDelegate, JourneyDetailsTapDelegate{
    
    
    func bookButtonTapped(journeyCombo: [CombinationJourney]?) {
        
    }
    
    func infoButtonTapped(isViewExpanded: Bool) {
        
    }
    
    
    func changeSwitchValue(isOn: Bool) {
        self.viewModel.isSwitchOn = isOn
        self.passengerTableview.beginUpdates()
        self.passengerTableview.reloadRows(at: [IndexPath(row: 4, section: 1)], with: .automatic)
        self.passengerTableview.endUpdates()
    }
    
    func tapOnSelectGST() {
        let vc = GSTINListVC.instantiate(fromAppStoryboard: .PassengersSelection)
        vc.viewModel.returnGSTIN = {[weak self] gst in
            self?.viewModel.selectedGST = gst
            self?.passengerTableview.reloadRows(at: [IndexPath(row: 4, section: 1)], with: .automatic)
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tappedDetailsButton(){
        guard self.detailsBaseVC == nil else { return }
        let vc = FlightDetailsBaseVC.instantiate(fromAppStoryboard: .FlightDetailsBaseVC)
        vc.isInternational = true
        vc.bookFlightObject = self.viewModel.bookingObject ?? BookFlightObject()
        vc.taxesResult = self.viewModel.taxesResult
        vc.sid = self.viewModel.sid
        vc.intJourney = self.viewModel.intJourney
        vc.intAirportDetailsResult = self.viewModel.intAirportDetailsResult
        vc.intAirlineDetailsResult = self.viewModel.intAirlineDetailsResult
        vc.selectedJourneyFK = self.viewModel.selectedJourneyFK
        vc.needToAddFareBreakup = false
        vc.view.autoresizingMask = []
        self.view.addSubview(vc.view)
        self.addChild(vc)
        vc.didMove(toParent: self)
        self.detailsBaseVC = vc
        if let newView = self.intFareBreakupVC?.view{
            vc.view.frame = CGRect(x: 0, y: UIScreen.height, width: UIScreen.main.bounds.width, height: UIScreen.height - newView.frame.height)
            self.view.bringSubviewToFront(newView)
            UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseOut], animations: {
                vc.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.height - newView.frame.height)
                vc.view.layoutSubviews()
                vc.view.setNeedsLayout()
            })
        }
    }
    
    func updateHeight(to height: CGFloat) {
        
//        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut], animations: {
            self.detailsBaseVC?.view.frame.size.height = UIScreen.height - height
            self.detailsBaseVC?.view.layoutSubviews()
            self.detailsBaseVC?.view.setNeedsLayout()
//        })
    }
    
}

extension PassengersSelectionVC: HCSelectGuestsVCDelegate{
    
    func didAddedContacts(){
        self.passengerTableview.reloadData()
    }
    
}
