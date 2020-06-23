//
//  AddOnsVC.swift
//  AERTRIP
//
//  Created by Appinventiv on 22/05/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

protocol AddonsUpdatedDelegate : class {
    func baggageUpdated()
    func mealsUpdated()
    func othersUpdated()
    func seatsUpdated()
}

class AddOnVC : BaseVC {
    
    @IBOutlet weak var topNavView: TopNavigationView!
    @IBOutlet weak var adonsTableView: UITableView!
    
    let adonsVm = AdonsVM()
    var fareBreakupVC:IntFareBreakupVC?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetups()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigation()
    }
    
    override func setupColors() {
        super.setupColors()
        
    }
    
    override func setupTexts() {
        super.setupTexts()
        
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        self.adonsVm.delegate = self
    }
}

//MARK:- Methods
extension AddOnVC {
    
    private func initialSetups() {
        self.adonsVm.setAdonsOptions()
        configureTableView()
        setupBottomView()
    }
    
    func configureNavigation(){
        self.topNavView.delegate = self
        self.topNavView.configureNavBar(title: "", isLeftButton: true, isFirstRightButton: true, isSecondRightButton: false,isDivider : false)
        self.topNavView.configureFirstRightButton(normalTitle: LocalizedString.Skip.localized, normalColor: AppColors.themeGreen, font: AppFonts.Bold.withSize(18))
    }
    
    private func configureTableView(){
        self.adonsTableView.register(UINib(nibName: "AdonsCell", bundle: nil), forCellReuseIdentifier: "AdonsCell")
        self.adonsTableView.separatorStyle = .none
        //        self.adonsTableView.estimatedRowHeight = 104
        self.adonsTableView.rowHeight = UITableView.automaticDimension
        self.adonsTableView.dataSource = self
        self.adonsTableView.delegate = self
    }
    
    func setupBottomView() {
//           viewForFare.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
//           viewForFare.tag = 5100
//           self.view.addSubview(viewForFare)
        let dataStore = AddonsDataStore.shared
           let vc = IntFareBreakupVC.instantiate(fromAppStoryboard: .InternationalReturnAndMulticityDetails)
           vc.taxesResult = dataStore.taxesResult
            vc.journey = [dataStore.itinerary.details]
            vc.sid = dataStore.itinerary.sid
            vc.bookFlightObject = self.adonsVm.bookingObject
           vc.view.autoresizingMask = []
           vc.delegate = self
           vc.view.tag = 2500
           vc.modalPresentationStyle = .overCurrentContext
           vc.selectedJourneyFK = [dataStore.itinerary.details.fk]
            vc.fewSeatsLeftViewHeightFromFlightDetails = 0
           let ts = CATransition()
           ts.type = .moveIn
           ts.subtype = .fromTop
           ts.duration = 0.4
           ts.timingFunction = .init(name: CAMediaTimingFunctionName.easeOut)
           vc.view.layer.add(ts, forKey: nil)
           self.view.addSubview(vc.view)
           self.addChild(vc)
           vc.didMove(toParent: self)
           self.fareBreakupVC = vc
     }
}

extension AddOnVC : FareBreakupVCDelegate {
    
    func bookButtonTapped(journeyCombo: [CombinationJourney]?) {
        self.adonsVm.bookFlightWithAddons()
    }
 
    func infoButtonTapped(isViewExpanded: Bool) {

    }
    
}

extension AddOnVC: TopNavigationViewDelegate {
    
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        AppFlowManager.default.popViewController(animated: true)
    }
    
    func topNavBarFirstRightButtonAction(_ sender: UIButton) {
        self.adonsVm.bookFlight()
    }
}



extension AddOnVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.adonsVm.addonsData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.adonsVm.getCellHeight(index: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AdonsCell", for: indexPath) as? AdonsCell else { fatalError("AdonsCell not found") }
        cell.populateData(data: self.adonsVm.addonsData[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let type = self.adonsVm.addonsData[indexPath.row].addonsType
        
        switch type {
            
        case .meals:
            let vc = MealsContainerVC.instantiate(fromAppStoryboard: AppStoryboard.Adons)
            vc.modalPresentationStyle = .overFullScreen
            vc.delegate = self
            present(vc, animated: true, completion: nil)
            
        case .baggage:
            let vc = BaggageContainerVC.instantiate(fromAppStoryboard: AppStoryboard.Adons)
            vc.modalPresentationStyle = .overFullScreen
            vc.delegate = self
            present(vc, animated: true, completion: nil)
            
        case .seat:
            let vc = SeatMapContainerVC.instantiate(fromAppStoryboard: .Rishabh_Dev)
            vc.setViewModel(adonsVm.getSeatMapContainerVM())
            vc.modalPresentationStyle = .overFullScreen
            vc.delegate = self
            present(vc, animated: true, completion: nil)
            
        case .otheres:
            let vc = SelectOtherAdonsContainerVC.instantiate(fromAppStoryboard: AppStoryboard.Adons)
            vc.modalPresentationStyle = .overFullScreen
            vc.delegate = self
            present(vc, animated: true, completion: nil)
            
        }
    }
    
}

extension AddOnVC : BookFlightDelegate {
    
    func willBookFlight(){
            AppGlobals.shared.startLoading()
    }
    
    func bookFlightSuccessFully(){
        AppGlobals.shared.stopLoading()
        let vc = FlightPaymentVC.instantiate(fromAppStoryboard: .FlightPayment)
        vc.viewModel.appliedCouponData = AddonsDataStore.shared.appliedCouponData
        vc.viewModel.taxesResult = AddonsDataStore.shared.taxesResult
        ///        vc.viewModel.passengers = GuestDetailsVM.shared.guests.first ?? []
        vc.viewModel.gstDetail = AddonsDataStore.shared.gstDetail
        vc.viewModel.email = AddonsDataStore.shared.email
        vc.viewModel.mobile = AddonsDataStore.shared.mobile
        vc.viewModel.bookingObject = self.adonsVm.bookingObject
        vc.viewModel.isd = AddonsDataStore.shared.isd
        vc.viewModel.isGSTOn = AddonsDataStore.shared.isGSTOn
        vc.viewModel.addonsMaster = AddonsDataStore.shared.addonsMaster
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func failedToBookBlight(){
        AppGlobals.shared.stopLoading()
    }
    
}


extension AddOnVC : AddonsUpdatedDelegate {
    
    func baggageUpdated() {
        self.adonsVm.setBaggageStrings()
        self.adonsTableView.reloadData()
    }
    
    func mealsUpdated() {
        self.adonsVm.setMealsString()
        self.adonsTableView.reloadData()
    }
    
    func othersUpdated() {
        self.adonsVm.setOthersString()
        self.adonsTableView.reloadData()
    }
    
    func seatsUpdated() {
        self.adonsVm.setSeatsString()
        self.adonsTableView.reloadData()
    }
    
}
