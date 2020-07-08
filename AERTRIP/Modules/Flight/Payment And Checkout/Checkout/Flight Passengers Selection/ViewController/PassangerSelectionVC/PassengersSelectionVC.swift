//
//  PassengersSelectionVC.swift
//  Aertrip
//
//  Created by Apple  on 04.05.20.
//  Copyright © 2020 Aertrip. All rights reserved.
//

import UIKit

class PassengersSelectionVC: BaseVC {

    @IBOutlet weak var progressViewHeight: NSLayoutConstraint!
    @IBOutlet weak var progressView: UIProgressView!
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
        self.viewModel.delegate = self
//        self.viewModel.setupGuestArray()
        self.apiCall()
        self.setupFont()
        self.navigationController?.navigationBar.isHidden = true
        self.passengerTableview.separatorStyle = .none
        self.passengerTableview.delegate = self
        self.passengerTableview.dataSource = self
        self.progressView.progressTintColor = UIColor.AertripColor
        self.progressView.trackTintColor = .clear
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        self.navigationController?.navigationBar.isHidden = true
        
        self.statusBarStyle = .default
    }
    
    func apiCall(){
        GuestDetailsVM.shared.guests.removeAll()
        self.viewModel.setupGuestArray()
        self.viewModel.webserviceForGetCountryList()
        self.viewModel.setupLoginData()
        self.viewModel.setupItineraryData()
        self.addButtomView()
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
//        addButtomView()
        self.addButton.isHidden = !(self.viewModel.isLogin)
    }
    
    private func addButtomView(){
        let vc = IntFareBreakupVC.instantiate(fromAppStoryboard: .InternationalReturnAndMulticityDetails)
        vc.isFewSeatsLeftViewVisible = true
        vc.taxesResult = self.viewModel.taxesResult
        vc.journey = [self.viewModel.itineraryData.itinerary.details]
        vc.delegate = self
        vc.detailsDelegate = self
        vc.sid = self.viewModel.sid
        if self.viewModel.itineraryData.itinerary.details.fsr == 1{
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
    
    func showProgressView(){
        UIView.animate(withDuration: 2) {
            self.progressView.isHidden = false
            self.progressViewHeight.constant = 1
        }
    }
    
    func hideProgressView(){
        UIView.animate(withDuration: 2) {
            self.progressViewHeight.constant = 0
            self.progressView.isHidden = true
        }
    }
    
    @IBAction func tapBackButton(_ sender: UIButton) {
        if #available(iOS 13, *) {
            self.statusBarStyle = .lightContent
        }
        self.dismissAsPopAnimation()
    }
    
    @IBAction func tapAddButton(_ sender: UIButton) {
        AppFlowManager.default.presentHCSelectGuestsVC(delegate: self, productType: .flight)
    }
}

extension PassengersSelectionVC: UseGSTINCellDelegate, FareBreakupVCDelegate, JourneyDetailsTapDelegate{
    
    func bookButtonTapped(journeyCombo: [CombinationJourney]?) {
        let validation = self.viewModel.validateGuestData()
        if validation.success{
            self.viewModel.checkValidationForNextScreen()
        }else{
            AppToast.default.showToastMessage(message: validation.msg)
        }
    }
    
    func infoButtonTapped(isViewExpanded: Bool) {
        
    }
    
    
    func changeSwitchValue(isOn: Bool) {
        if self.viewModel.itineraryData.itinerary.gstRequired{
            self.viewModel.isSwitchOn = true
            AppToast.default.showToastMessage(message: "GSTIN is mandatory for this booking.")
        }else{
           self.viewModel.isSwitchOn = isOn
        }
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
    
    func editTextFields(_ textFiledType: GSTCellTextFields, text:String){
        switch textFiledType{
        case .companyName:
            self.viewModel.selectedGST.companyName = text
        case .billingName:
            self.viewModel.selectedGST.billingName = text
        case .gstNumber:
            self.viewModel.selectedGST.GSTInNo = text
        }
        
    }
    
    func tappedDetailsButton(){
        self.openDetailsButton()
//        guard self.detailsBaseVC == nil else { return }
//        let vc = FlightDetailsBaseVC.instantiate(fromAppStoryboard: .FlightDetailsBaseVC)
//        vc.isInternational = true
//        vc.bookFlightObject = self.viewModel.bookingObject ?? BookFlightObject()
//        vc.taxesResult = self.viewModel.taxesResult
//        vc.sid = self.viewModel.sid
//        vc.intJourney = [self.viewModel.itineraryData.itinerary.details]
//        vc.intAirportDetailsResult = self.viewModel.intAirportDetailsResult
//        vc.selectedJourneyFK = [self.viewModel.itineraryData.itinerary.details.fk]
//        vc.airlineData = self.viewModel.itineraryData.itinerary.details.aldet
//        vc.needToAddFareBreakup = false
//        vc.journey = self.viewModel.journey ?? []
//        vc.view.autoresizingMask = []
//        self.view.addSubview(vc.view)
//        self.addChild(vc)
//        vc.didMove(toParent: self)
//        self.detailsBaseVC = vc
//        if let newView = self.intFareBreakupVC?.view{
//            vc.view.frame = CGRect(x: 0, y: UIScreen.height, width: UIScreen.main.bounds.width, height: UIScreen.height - newView.frame.height)
//            self.view.bringSubviewToFront(newView)
//            UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseOut], animations: {
//                vc.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.height - newView.frame.height)
//                vc.view.layoutSubviews()
//                vc.view.setNeedsLayout()
//            })
//        }
    }
    
    func openDetailsButton(){
        let vc = FlightDetailsBaseVC.instantiate(fromAppStoryboard: .FlightDetailsBaseVC)
        vc.isInternational = true//self.viewModel.itineraryData.itinerary.isInternational
        vc.bookFlightObject = self.viewModel.bookingObject ?? BookFlightObject()
        vc.taxesResult = self.viewModel.taxesResult
        vc.isForCheckOut = true
        vc.sid = self.viewModel.sid
        vc.intJourney = [self.viewModel.itineraryData.itinerary.details]
        vc.intAirportDetailsResult = self.viewModel.intAirportDetailsResult
        vc.intAirlineDetailsResult = self.viewModel.intAirlineDetailsResult
        vc.selectedJourneyFK = [self.viewModel.itineraryData.itinerary.details.fk]
        vc.journeyTitle = self.viewModel.bookingTitle
        vc.journeyDate = self.viewModel.journeyDate
        self.present(vc, animated: true, completion: nil)
        
    }
    
    func updateHeight(to height: CGFloat) {
            self.detailsBaseVC?.view.frame.size.height = UIScreen.height - height
            self.detailsBaseVC?.view.layoutSubviews()
            self.detailsBaseVC?.view.setNeedsLayout()
    }
    
}

extension PassengersSelectionVC{
    func showFareUpdatePopup(){
        let diff = self.viewModel.itineraryData.itinerary.priceChange
        let amount = self.viewModel.itineraryData.itinerary.details.farepr
        guard diff != 0 else{
            if let freeType = self.viewModel.freeServiceType{
                FreeMealAndSeatVC.showMe(type: freeType)
            }
            return
        }
        
        if diff > 0 {
            // increased
            FareUpdatedPopUpVC.showPopUp(isForIncreased: true, decreasedAmount: 0.0, increasedAmount: Double(diff), totalUpdatedAmount: Double(amount), continueButtonAction: { [weak self] in
                guard let self = self else { return }
                if let freeType = self.viewModel.freeServiceType{
                    FreeMealAndSeatVC.showMe(type: freeType)
                }
                }, goBackButtonAction: { [weak self] in
                    guard let self = self else { return }
                    self.getListingController()
            })
        }
        else {
            // dipped
            FareUpdatedPopUpVC.showPopUp(isForIncreased: false, decreasedAmount: Double(-diff), increasedAmount: 0, totalUpdatedAmount: 0, continueButtonAction: nil, goBackButtonAction: nil)
            delay(seconds: 5.0) { [weak self] in
                guard let self = self else { return }
                if let freeType = self.viewModel.freeServiceType{
                    FreeMealAndSeatVC.showMe(type: freeType)
                }
            }
        }
    }
    
    func getListingController(){
      if let nav = self.navigationController?.presentingViewController?.presentingViewController as? UINavigationController{
          nav.dismiss(animated: true) {
              delay(seconds: 0.0) {
                if let vc = nav.viewControllers.first(where: {$0.isKind(of: FlightResultBaseViewController.self)}) as? FlightResultBaseViewController{
                    nav.popToViewController(vc, animated: true)
                    vc.searchApiResult()
                }
              }
          }
      }
    }
}

extension PassengersSelectionVC: HCSelectGuestsVCDelegate{
    
    func didAddedContacts(){
        self.passengerTableview.reloadData()
    }
    
}

//Delegate For Api
extension PassengersSelectionVC:PassengerSelectionVMDelegate{
    
    func startFechingConfirmationData(){
//        delay(seconds: 0.2){
//            AppGlobals.shared.startLoading()
//        }
        
        self.progressView.setProgress(0, animated: false)

               self.showProgressView()
               delay(seconds: 0.5){
                UIView.animate(withDuration: 2) {
                    self.progressView.setProgress(0.25, animated: true)
                }
               }
    }
    
    func startFechingAddnsMasterData(){
        self.view.isUserInteractionEnabled = false
        UIView.animate(withDuration: 2) {
        self.progressView.setProgress(0.75, animated: true)
        }
    }
    
    func startFechingGSTValidationData(){
        AppGlobals.shared.startLoading()
    }
    
    func startFechingLoginData(){
        AppGlobals.shared.startLoading()
    }
    
    func getResponseFromConfirmation(_ success:Bool, error:ErrorCodes){
        // AppGlobals.shared.stopLoading()
        if success{
            UIView.animate(withDuration: 2) {
                self.progressView.setProgress(0.5, animated: true)
            }
            self.addButtomView()
        }else{
            
            self.hideProgressView()
            AppGlobals.shared.showErrorOnToastView(withErrors: error, fromModule: .flights)
        }
    }
    
    func getResponseFromAddnsMaster(_ success:Bool, error:ErrorCodes){
        self.view.isUserInteractionEnabled = true
        if success {
            
            UIView.animate(withDuration: 2, animations: {
                self.progressView.setProgress(1, animated: true)
            }) { (success) in
                self.hideProgressView()

            }
     
              self.showFareUpdatePopup()
              self.passengerTableview.reloadData()
         } else {
            self.hideProgressView()
            AppGlobals.shared.showErrorOnToastView(withErrors: error, fromModule: .flights)
         }
    }
    
    func getResponseFromGSTValidation(_ success:Bool, error:ErrorCodes){
        AppGlobals.shared.stopLoading()
        if success{
            let vc = AddOnVC.instantiate(fromAppStoryboard: .Adons)
            vc.adonsVm.bookingObject = self.viewModel.bookingObject ?? BookFlightObject()
            AddonsDataStore.shared.initialiseItinerary(itinerary: self.viewModel.itineraryData.itinerary, addonsMaster: self.viewModel.addonsMaster)
            AddonsDataStore.shared.appliedCouponData = self.viewModel.itineraryData
            AddonsDataStore.shared.taxesResult = self.viewModel.taxesResult
            AddonsDataStore.shared.passengers = GuestDetailsVM.shared.guests.first ?? []
            AddonsDataStore.shared.gstDetail = self.viewModel.selectedGST
            AddonsDataStore.shared.email = self.viewModel.email
            AddonsDataStore.shared.mobile = self.viewModel.mobile
            AddonsDataStore.shared.isd = self.viewModel.isdCode
            AddonsDataStore.shared.isGSTOn = self.viewModel.isSwitchOn
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            AppGlobals.shared.showErrorOnToastView(withErrors: error, fromModule: .flights)
        }
    }
    
    func getResponseFromLogin(_ success:Bool, error: ErrorCodes){
        AppGlobals.shared.stopLoading()
        if !success{
            AppGlobals.shared.showErrorOnToastView(withErrors: error, fromModule: .flights)
        }
    }
}
