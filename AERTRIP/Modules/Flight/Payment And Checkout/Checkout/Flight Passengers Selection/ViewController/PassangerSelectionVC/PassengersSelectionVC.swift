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
    @IBOutlet weak var addContactIndicator: UIActivityIndicatorView!
    
    var viewModel = PassengerSelectionVM()
    weak var intFareBreakupVC:IntFareBreakupVC?
//    var detailsBaseVC:FlightDetailsBaseVC?
    var viewForFare = UIView()
    var dismissController:(()->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FirebaseEventLogs.shared.logEventsWithoutParam(with: .OpenPassengerDetails)
        self.registerCell()
        self.viewModel.delegate = self
        self.apiCall()
        self.setupFont()
        self.navigationController?.navigationBar.isHidden = true
        self.passengerTableview.separatorStyle = .none
        self.passengerTableview.delegate = self
        self.passengerTableview.dataSource = self
        self.progressView.progressTintColor = UIColor.AertripColor
        self.progressView.trackTintColor = .clear
        self.manageLoader()
        self.passengerTableview.contentInset = UIEdgeInsets(top: (backNavigationView.height - 0.5), left: 0, bottom: 0, right: 0)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        self.navigationController?.navigationBar.isHidden = true
        
        self.statusBarStyle = .darkContent
    }
    
    func apiCall(){
        if self.viewModel.sid != GuestDetailsVM.shared.sid{
            GuestDetailsVM.shared.guests.removeAll()
        }
        self.viewModel.setupGuestArray()
        self.viewModel.webserviceForGetCountryList()
        self.viewModel.setupLoginData()
        self.viewModel.setupItineraryData()
        self.addButtomView()
    }
    
    private func registerCell(){
        self.passengerTableview.registerCell(nibName: FlightEmptyCell.reusableIdentifier)
        self.passengerTableview.registerCell(nibName: FlightContactCell.reusableIdentifier)
        self.passengerTableview.registerCell(nibName: PassengerGridCell.reusableIdentifier)
        self.passengerTableview.registerCell(nibName: FlightEmailFieldCell.reusableIdentifier)
        self.passengerTableview.registerCell(nibName: UseGSTINCell.reusableIdentifier)
        self.passengerTableview.registerCell(nibName: CommunicationTextCell.reusableIdentifier)
        self.passengerTableview.registerCell(nibName: TravellSefetyCell.reusableIdentifier)
    }
        
    private func setupFont(){
        self.navigationController?.navigationBar.tintColor = AppColors.themeGreen
        self.titleLabel.font = AppFonts.SemiBold.withSize(18)
        self.passengerTableview.backgroundColor = AppColors.themeGray04
        self.titleLabel.text = "Passengers"
//        addButtomView()
        self.addButton.setImage(AppImages.AddPassenger, for: .normal)
        self.addButton.isHidden = !(self.viewModel.isLogin)
    }
    
    private func addButtomView(){
        viewForFare.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        viewForFare.tag = 5100
        self.view.addSubview(viewForFare)
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
        let bottomSpecing = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        self.tableViewBottomConsctraint.constant = (vc.view.frame.height - bottomSpecing)
        
        self.intFareBreakupVC = vc
    }
    
    func showProgressView(){
        UIView.animate(withDuration: 2) {[weak self] in
            guard let self = self else {return}
            self.progressView.isHidden = false
            self.progressViewHeight.constant = 1
        }
    }
    
    func hideProgressView(){
        UIView.animate(withDuration: 2) {[weak self] in
        guard let self = self else {return}
            self.progressViewHeight.constant = 0
            self.progressView.isHidden = true
        }
    }
    
    private func manageLoader() {
        self.addContactIndicator.style = .medium
        self.addContactIndicator.tintColor = AppColors.themeGreen
        self.addContactIndicator.color = AppColors.themeGreen
        self.addContactIndicator.startAnimating()
        self.hideShowLoader(isHidden:true)
    }
    
    func hideShowLoader(isHidden:Bool){
        DispatchQueue.main.async {
            self.addButton.isHidden = !isHidden
            if isHidden{
                self.addContactIndicator.stopAnimating()
                
            }else{
                self.addContactIndicator.startAnimating()
            }
            
        }
    }
    
    @IBAction func tapBackButton(_ sender: UIButton) {
        if #available(iOS 13, *) {
            self.statusBarStyle = .lightContent
        }
        self.dismissAsPopAnimation(){[weak self] in
            self?.dismissController?()
        }
        
    }
    
    @IBAction func tapAddButton(_ sender: UIButton) {
        self.hideShowLoader(isHidden: false)
        self.viewModel.logEvent(with: .openSelectGuest )
        AppFlowManager.default.presentHCSelectGuestsVC(delegate: self, productType: .flight)
        delay(seconds: 1.7){[weak self] in
            self?.hideShowLoader(isHidden: true)
        }
    }
}

extension PassengersSelectionVC: UseGSTINCellDelegate, FareBreakupVCDelegate, JourneyDetailsTapDelegate{
    
    func bookButtonTapped(journeyCombo: [CombinationJourney]?) {
        let validation = self.viewModel.validateGuestData()
        if validation.success{
            self.viewModel.checkValidationForNextScreen()
        }else{
            self.viewModel.isContinueButtonTapped = true
            self.passengerTableview.reloadData()
            AppToast.default.showToastMessage(message: validation.msg)
        }
    }
    
    func infoButtonTapped(isViewExpanded: Bool) {
        
        if isViewExpanded == true{
            viewForFare.frame = CGRect(x: 0, y: 0, width: UIScreen.width, height: UIScreen.height)
            UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut], animations: {[weak self] in
                self?.viewForFare.backgroundColor = AppColors.blackWith20PerAlpha
            })
        }else{
            UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut], animations: {[weak self] in
                self?.viewForFare.backgroundColor = AppColors.clear
            },completion: {[weak self] _ in
                self?.viewForFare.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
            })
        }
        
    }
    
    
    func changeSwitchValue(isOn: Bool) {
        if self.viewModel.itineraryData.itinerary.gstRequired{
            self.viewModel.isSwitchOn = true
            AppToast.default.showToastMessage(message: "GSTIN is mandatory for this booking.")
        }else{
           self.viewModel.isSwitchOn = isOn
        }
        self.passengerTableview.beginUpdates()
        let indexs = [IndexPath(row: 4, section: 1), IndexPath(row: 5, section: 1)]
        self.passengerTableview.reloadRows(at: indexs, with: .automatic)
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
    }
    
    func openDetailsButton(){
        let vc = FlightDetailsBaseVC.instantiate(fromAppStoryboard: .FlightDetailsBaseVC)
        vc.isInternational = true//self.viewModel.itineraryData.itinerary.isInternational
        vc.bookFlightObject = self.viewModel.bookingObject ?? BookFlightObject()
        vc.taxesResult = self.viewModel.taxesResult
        vc.isFromPassangerDetails = true
        vc.isForCheckOut = true
        vc.sid = self.viewModel.sid
        vc.itineraryId = self.viewModel.itineraryData.itinerary.id
        vc.airlineData = self.viewModel.itineraryData.itinerary.details.aldet
        vc.intJourney = [self.viewModel.itineraryData.itinerary.details]
        vc.intAirportDetailsResult = self.viewModel.intAirportDetailsResult
        vc.intAirlineDetailsResult = self.viewModel.intAirlineDetailsResult
        vc.selectedJourneyFK = [self.viewModel.itineraryData.itinerary.details.fk]
        vc.journeyTitle = self.viewModel.bookingTitle
        vc.journeyDate = self.viewModel.journeyDate
        vc.modalPresentationStyle = .popover
        self.present(vc, animated: true, completion: nil)
        
    }
    
    func updateHeight(to height: CGFloat) {
            
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
            self.viewModel.logEvent(with: .fareIncrease)
            FareUpdatedPopUpVC.showPopUp(isForIncreased: true, decreasedAmount: 0.0, increasedAmount: Double(diff), totalUpdatedAmount: Double(amount), continueButtonAction: { [weak self] in
                guard let self = self else { return }
                if let freeType = self.viewModel.freeServiceType{
                    FreeMealAndSeatVC.showMe(type: freeType)
                    self.viewModel.logEvent(with: .continueWithFareIncrease)
                }
                }, goBackButtonAction: { [weak self] in
                    guard let self = self else { return }
                    self.viewModel.logEvent(with: .backWithFareIncrease)
                    self.getListingController()
            })
        }
        else {
            // dipped
            self.viewModel.logEvent(with: .fareDipped)
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
          nav.dismiss(animated: true) {[weak self] in
            guard let self = self else {return}
            DispatchQueue.main.async {//[weak self] in
//                guard let self = self else {return}
                if let vc = nav.viewControllers.first(where: {$0.isKind(of: FlightResultBaseViewController.self)}) as? FlightResultBaseViewController{
//                    nav.popToViewController(vc, animated: true)
                    vc.searchApiResult(flightItinary: self.viewModel.itineraryData)
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
        self.progressView.setProgress(0, animated: false)

               self.showProgressView()
               delay(seconds: 0.5){[weak self] in
               guard let self = self else {return}
                UIView.animate(withDuration: 2){[weak self] in
                guard let self = self else {return}
                    self.progressView.setProgress(0.25, animated: true)
                }
               }
    }
    
    func startFechingAddnsMasterData(){
        self.view.isUserInteractionEnabled = false
        UIView.animate(withDuration: 2) {[weak self] in
        guard let self = self else {return}
        self.progressView.setProgress(0.75, animated: true)
        }
    }
    
    func startFechingGSTValidationData(){
        self.intFareBreakupVC?.hideShowLoader(isHidden: false)
    }
    
    func startFechingLoginData(){
        self.intFareBreakupVC?.hideShowLoader(isHidden: false)
    }
    
    func getResponseFromConfirmation(_ success:Bool, error:ErrorCodes){
        // AppGlobals.shared.stopLoading()
        if success{
            UIView.animate(withDuration: 2) {[weak self] in
            guard let self = self else {return}
                self.progressView.setProgress(0.5, animated: true)
            }
        }else{
            
            self.hideProgressView()
            AppGlobals.shared.showErrorOnToastView(withErrors: error, fromModule: .flights)
        }
    }
    
    func getResponseFromAddnsMaster(_ success:Bool, error:ErrorCodes){
        self.view.isUserInteractionEnabled = true
        if success {
            
            UIView.animate(withDuration: 2, animations: {[weak self] in
            guard let self = self else {return}
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
        self.intFareBreakupVC?.hideShowLoader(isHidden: true)
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
        self.intFareBreakupVC?.hideShowLoader(isHidden: true)
        if !success{
            AppGlobals.shared.showErrorOnToastView(withErrors: error, fromModule: .flights)
        }
    }
}
