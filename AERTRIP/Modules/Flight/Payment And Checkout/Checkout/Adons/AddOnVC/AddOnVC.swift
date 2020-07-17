//
//  AddOnsVC.swift
//  AERTRIP
//
//  Created by Appinventiv on 22/05/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

protocol AddonsUpdatedDelegate : class {
    func baggageUpdated(amount : String)
    func mealsUpdated(amount : String)
    func othersUpdated(amount : String)
    func seatsUpdated(amount: Int)
    func resetMeals()
}

class AddOnVC : BaseVC {
    
    @IBOutlet weak var topNavView: TopNavigationView!
    @IBOutlet weak var adonsTableView: UITableView!
    @IBOutlet weak var bookNowLabel: UILabel!
    
    let adonsVm = AdonsVM()
    var fareBreakupVC:IntFareBreakupVC?
    var indicator = UIActivityIndicatorView()
    var viewForFare = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetups()
        self.manageLoader()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.reloadFareBreakup()
        self.setSkipButton()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.indicator.center = self.topNavView.firstRightButton.center
    }
    
    override func setupColors() {
        super.setupColors()
        
    }
    
    override func setupTexts() {
        super.setupTexts()
        self.bookNowLabel.attributedText = LocalizedString.Book_Now_And_Get_Off.localized.attributeStringWithColors(subString: " 20% off ", strClr: UIColor.black, substrClr: UIColor.black, strFont: AppFonts.c.withSize(38), subStrFont: AppFonts.c.withSize(38), backgroundColor: AppColors.greenBackground)
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
        self.adonsVm.initializeFreeMealsToPassengers()
        self.mealsUpdated(amount: "")
        configureTableView()
        setupBottomView()
        
    }
    
    func configureNavigation(showSkip : Bool = true){
        self.topNavView.delegate = self
        self.topNavView.configureNavBar(title: "", isLeftButton: true, isFirstRightButton: showSkip, isSecondRightButton: false,isDivider : false)
        self.topNavView.configureFirstRightButton(normalTitle: LocalizedString.Skip.localized, normalColor: AppColors.themeGreen, font: AppFonts.SemiBold.withSize(18))
    }
    
    private func configureTableView(){
        self.adonsTableView.register(UINib(nibName: "AdonsCell", bundle: nil), forCellReuseIdentifier: "AdonsCell")
        self.adonsTableView.contentInset = UIEdgeInsets(top: -12, left: 0, bottom: 0, right: 0)
        self.adonsTableView.separatorStyle = .none
        //        self.adonsTableView.estimatedRowHeight = 104
        self.adonsTableView.rowHeight = UITableView.automaticDimension
        self.adonsTableView.dataSource = self
        self.adonsTableView.delegate = self
    }
    
    private func manageLoader() {
        indicator.frame.size = CGSize(width: 25, height: 25)
        self.topNavView.addSubview(indicator)
        self.topNavView.bringSubviewToFront(indicator)
        self.indicator.style = .gray
        self.indicator.tintColor = AppColors.themeGreen
        self.indicator.color = AppColors.themeGreen
        self.indicator.stopAnimating()
        self.hideShowLoader(isHidden:true)
    }
    
    func hideShowLoader(isHidden:Bool){
        DispatchQueue.main.async {
            if self.adonsVm.isSkipButtonTap{
                if isHidden{
                    self.indicator.stopAnimating()
                    self.topNavView.firstRightButton.setTitle("Skip", for: .normal)
                }else{
                    self.topNavView.firstRightButton.setTitle("", for: .normal)
                    self.indicator.startAnimating()
                }
            }else{
                self.fareBreakupVC?.hideShowLoader(isHidden: isHidden)
            }
            
        }
    }
    
    func setupBottomView() {
        viewForFare.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        viewForFare.tag = 5100
        self.view.addSubview(viewForFare)
        let dataStore = AddonsDataStore.shared
        let vc = IntFareBreakupVC.instantiate(fromAppStoryboard: .InternationalReturnAndMulticityDetails)
        vc.taxesResult = dataStore.taxesResult
        vc.journey = [dataStore.itinerary.details]
        vc.sid = dataStore.itinerary.sid
        vc.bookFlightObject = self.adonsVm.bookingObject
        vc.view.autoresizingMask = []
        vc.addonsData = self.adonsVm.getAddonsPriceDict()
        vc.delegate = self
        vc.view.tag = 2500
        vc.modalPresentationStyle = .overCurrentContext
        vc.selectedJourneyFK = [dataStore.itinerary.details.fk]
        vc.fewSeatsLeftViewHeightFromFlightDetails = 0
        vc.isCheckoutDetails = true
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
    
    func reloadFareBreakup(){
        if let fareBreakup = self.fareBreakupVC{
            fareBreakup.addonsData = self.adonsVm.getAddonsPriceDict()
            fareBreakup.reloadDataForAddons()
        }
    }
    
    func setSkipButton() {
        self.reloadFareBreakup()
        self.configureNavigation(showSkip: !(self.adonsVm.isMealSelected() || self.adonsVm.isOthersSelected() || self.adonsVm.isBaggageSelected()))
    }
    
    
    
}

extension AddOnVC : FareBreakupVCDelegate {
    
    func bookButtonTapped(journeyCombo: [CombinationJourney]?) {
        self.adonsVm.isSkipButtonTap = false
        self.adonsVm.bookFlightWithAddons()
    }
    
    func infoButtonTapped(isViewExpanded: Bool) {
        
        if isViewExpanded == true{
            viewForFare.frame = CGRect(x: 0, y: 0, width: UIScreen.width, height: UIScreen.height)
            UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut], animations: {
                self.viewForFare.backgroundColor = AppColors.blackWith20PerAlpha
            })
        }else{
            UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut], animations: {
                self.viewForFare.backgroundColor = AppColors.clear
            },completion: { _ in
                self.viewForFare.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
            })
        }
        
    }
    
}

extension AddOnVC: TopNavigationViewDelegate {
    
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        AppFlowManager.default.popViewController(animated: true)
    }
    
    func topNavBarFirstRightButtonAction(_ sender: UIButton) {
        self.adonsVm.isSkipButtonTap = true
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
        self.hideShowLoader(isHidden: false)
        self.view.isUserInteractionEnabled = false
    }
    
    func bookFlightSuccessFully(){
        self.hideShowLoader(isHidden: true)
        self.view.isUserInteractionEnabled = true
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
    
    func failedToBookBlight(error: ErrorCodes){
        self.hideShowLoader(isHidden: true)
        self.view.isUserInteractionEnabled = true
        AppGlobals.shared.showErrorOnToastView(withErrors: error, fromModule: .flights)
    }
    
}


extension AddOnVC : AddonsUpdatedDelegate {
    
    func baggageUpdated(amount : String) {
        self.adonsVm.updateBaggageSelectionInMainArray()
        self.adonsVm.setBaggageStrings()
        self.adonsTableView.reloadData()
        let amountValue = amount.isEmpty || amount == "0" ? nil : amount
        self.adonsVm.updatePriceDict(key: "Baggage", value: amountValue?.replacingLastOccurrenceOfString(",", with: ""))
        self.setSkipButton()
    }
    
    func mealsUpdated(amount : String) {
        self.adonsVm.updateMealsSelectionInMainArray()
        self.adonsVm.setMealsString()
        self.adonsTableView.reloadData()
        let amountValue = amount.isEmpty || amount == "0" ? nil : amount
        self.adonsVm.updatePriceDict(key: "Meals", value: amountValue?.replacingLastOccurrenceOfString(",", with: ""))
        self.setSkipButton()
    }
    
    func othersUpdated(amount : String) {
//        self.adonsVm.updateOthersSelectionInMainArray()
        self.adonsVm.setOthersString()
        self.adonsTableView.reloadData()
        let amountValue = amount.isEmpty || amount == "0" ? nil : amount
        self.adonsVm.updatePriceDict(key: "Others", value: amountValue?.replacingLastOccurrenceOfString(",", with: ""))
        self.setSkipButton()
    }
    
    func seatsUpdated(amount: Int) {
        self.adonsVm.setSeatsString()
        self.adonsTableView.reloadData()
        self.adonsVm.updatePriceDict(key: "Seat", value: "\(amount)")
        self.setSkipButton()
    }
    
    func resetMeals() {
        //        self.adonsVm.initializeFreeMealsToPassengers()
        //        self.adonsTableView.reloadData()
        
    }
    
    
}
