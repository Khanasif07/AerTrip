//
//  UpgradePlanContrainerVC.swift
//  AERTRIP
//
//  Created by Appinventiv  on 26/08/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit
import Parchment

class UpgradePlanContrainerVC: BaseVC, UpgradePlanListVCDelegate {
    
    @IBOutlet weak var grabberView: UIView!
    @IBOutlet weak var upgradeYourFlightLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var containerViewBottom: NSLayoutConstraint!
    
    //MARK:- Variable Declaration
    
    var parchmentView:PagingViewController?
    var viewModel = UpgradePlanVM()
    var allChildVCs = [UpgradePlanListVC]()
    var fareBreakupVC : FareBreakupVC?
    var intFareBreakup:IntFareBreakupVC?
    var viewForFare = UIView()
    var innerControllerBottomConstraint: CGFloat = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.delegate = self
        self.getMenuTitle()
        if self.viewModel.isInternational{
            self.setupIntFarebreakupView()
        }else{
            self.setupFarebreakupView()
        }
        
        FirebaseEventLogs.shared.logEventsWithoutParam(with: .UpgradePlan)


        
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.parchmentView?.view.frame = self.containerView.bounds
        self.parchmentView?.loadViewIfNeeded()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.parchmentView?.view.frame = self.containerView.bounds
        self.view.addGredient(isVertical: true, cornerRadius: 0, colors: AppConstants.appthemeGradientColors.reversed()) // [AppColors.themeGreen, AppColors.dashboardGradientColor] To be Check Gradient Nitin
        self.parchmentView?.view.frame.size.height = self.containerView.height - innerControllerBottomConstraint
        self.parchmentView?.loadViewIfNeeded()
    }
    
    
    private func getMenuTitle(){
        self.viewModel.allTabsStr.removeAll()
        if !(self.viewModel.isInternational), let journeys  = self.viewModel.oldJourney{
            for journey in journeys{
                let titel = self.createAttHeaderTitle(journey.originIATACode, journey.destinationIATACode)
                self.viewModel.allTabsStr.append(titel)
            }
        }else if let journeys  = self.viewModel.oldIntJourney{
            for journey in journeys{
                let titel = self.createAttHeaderTitle(journey.originIATACode, journey.destinationIATACode)
                self.viewModel.allTabsStr.append(titel)
            }
        }
        self.updateUI()
        self.setupPagger()
    }
    
    private func updateUI(){
        self.upgradeYourFlightLabel.text = "Upgrade your flight"
        self.upgradeYourFlightLabel.font = AppFonts.SemiBold.withSize(18.0)
        self.upgradeYourFlightLabel.textColor = AppColors.themeWhite
        self.grabberView.layer.cornerRadius = 2.0
        self.grabberView.clipsToBounds = true
    }
    
    func setupPagger(){
        self.viewModel.currentIndex = 0
        self.allChildVCs.removeAll()
        for i in 0..<self.viewModel.allTabsStr.count{
            let vc = UpgradePlanListVC.instantiate(fromAppStoryboard: .InternationalReturnAndMulticityDetails)
            vc.viewModel = self.viewModel
            vc.delegate = self
            vc.usedIndexFor = i
            allChildVCs.append(vc)
        }
        self.view.layoutIfNeeded()
        if let _ = self.parchmentView{
            self.parchmentView?.view.removeFromSuperview()
            self.parchmentView = nil
        }
        self.setupParchmentPageController()
        if self.viewModel.isInternational{
            self.apiCallForIntOtherFare()
        }else{
            self.apiCallForOtherFare()
        }
        
    }
    
    private func setupParchmentPageController(){
        
        self.parchmentView = PagingViewController()
        self.parchmentView?.menuItemSpacing = 30
        self.parchmentView?.menuInsets = UIEdgeInsets(top: 0.0, left: 15, bottom: 0.0, right: 15)
        if (self.viewModel.oldJourney?.count == 1) || (self.viewModel.oldIntJourney?.count == 1){
            self.parchmentView?.menuItemSize = .sizeToFit(minWidth: 150, height: 0)
        }else{
            self.parchmentView?.menuItemSize = .sizeToFit(minWidth: 150, height: 55)
        }
        self.parchmentView?.indicatorOptions = PagingIndicatorOptions.visible(height: 2, zIndex: Int.max, spacing: UIEdgeInsets.zero, insets: UIEdgeInsets.zero)
        self.parchmentView?.borderOptions = PagingBorderOptions.visible(
            height: 0.5,
            zIndex: Int.max - 1,
            insets: UIEdgeInsets(top: 0, left: -400, bottom: 0, right: -400))
        let nib = UINib(nibName: "MenuItemCollectionCell", bundle: nil)
        self.parchmentView?.register(nib, for: MenuItem.self)
        self.parchmentView?.borderColor = AppColors.themeGray214
        self.parchmentView?.font = AppFonts.Regular.withSize(16.0)
        self.parchmentView?.selectedFont = AppFonts.SemiBold.withSize(16.0)
        self.parchmentView?.indicatorColor = AppColors.themeWhite
        self.parchmentView?.selectedTextColor = AppColors.themeWhite
        if self.parchmentView != nil{
            self.containerView.addSubview(self.parchmentView!.view)
        }
        
        self.parchmentView?.dataSource = self
        self.parchmentView?.delegate = self
        self.parchmentView?.sizeDelegate = self
        self.parchmentView?.select(index: 0)
        
        self.parchmentView?.reloadData()
        self.parchmentView?.reloadMenu()
        self.parchmentView?.menuBackgroundColor = UIColor.clear
        self.parchmentView?.collectionView.backgroundColor = UIColor.clear
        self.parchmentView?.contentInteraction = .none
    }
    
    private func createAttHeaderTitle(_ origin: String,_ destination: String) -> NSAttributedString {
//        let fullString = NSMutableAttributedString(string: origin + "" )
//        let desinationAtrributedString = NSAttributedString(string: "" + destination)
//        let imageString = getStringFromImage(name : "oneway")
//        fullString.append(imageString)
//        fullString.append(desinationAtrributedString)
        
        let string = "\(origin) → \(destination)"
        let fullString = NSAttributedString(string: string, attributes: [.foregroundColor: AppColors.themeWhite, .font: AppFonts.Regular.withSize(16.0)])
        return fullString
    }
    
    private func getStringFromImage(name : String) -> NSAttributedString {
        let imageAttachment = NSTextAttachment()
        let sourceSansPro18 = AppFonts.SemiBold.withSize(18.0)
        let iconImage = UIImage(named: name ) ?? UIImage()
        imageAttachment.image = iconImage
        
        let yCordinate  = roundf(Float(sourceSansPro18.capHeight - iconImage.size.height) / 2.0)
        imageAttachment.bounds = CGRect(x: CGFloat(0.0), y: CGFloat(yCordinate) , width: iconImage.size.width, height: iconImage.size.height )
        let imageString = NSAttributedString(attachment: imageAttachment)
        return imageString
    }
    
    func apiCallForOtherFare(){
     

        guard let journeys = self.viewModel.oldJourney else {return}
        self.viewModel.ohterFareData = []
        self.viewModel.selectedOhterFareData = []
        for (index, value) in journeys.enumerated(){
            self.viewModel.ohterFareData.append([])
            self.viewModel.selectedOhterFareData.append(nil)
            if (value.otherfares ?? false){
                self.viewModel.getOtherFare(with: value.fk, oldFare: "\(value.farepr)", index: index)
            }else{
                self.viewModel.ohterFareData[index] = nil
                self.viewModel.selectedOhterFareData[index] = nil
                self.allChildVCs[index].shouldStartIndicator(isDataFetched: false)
            }
        }
    }
    
    
    
    func apiCallForIntOtherFare(){

        guard let journeys = self.viewModel.oldIntJourney else {return}
        self.viewModel.ohterFareData = []
        self.viewModel.selectedOhterFareData = []
        for (index, value) in journeys.enumerated(){
            self.viewModel.ohterFareData.append([])
            self.viewModel.selectedOhterFareData.append(nil)
            if (value.otherFares){
                self.viewModel.getOtherFare(with: value.fk, oldFare: "\(value.farepr)", index: index)
            }else{
                self.viewModel.ohterFareData[index] = nil
                self.viewModel.selectedOhterFareData[index] = nil
                self.allChildVCs[index].shouldStartIndicator(isDataFetched: false)
            }
        }
    }
    
    private func setupFarebreakupView(){

        self.addTranparentView()
        let fbVC =  FareBreakupVC(nibName: "FareBreakupVC", bundle: nil)
        fbVC.taxesResult = self.viewModel.taxesResult
        fbVC.journey = self.viewModel.oldJourney
        fbVC.sid = self.viewModel.sid
        fbVC.delegate = self
        fbVC.isFromFlightDetails = true
        fbVC.fromScreen = "upgradePlan"
        fbVC.isUpgradePlanScreenVisible = true
        fbVC.flightAdultCount = self.viewModel.flightAdultCount
        fbVC.flightChildrenCount = self.viewModel.flightChildrenCount
        fbVC.flightInfantCount = self.viewModel.flightInfantCount
        fbVC.bookingObject = self.viewModel.bookingObject
        self.view.addSubview(fbVC.view)
        self.addChild(fbVC)
        fbVC.didMove(toParent: self)
        self.fareBreakupVC = fbVC
        let bottomSpecing = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        self.innerControllerBottomConstraint = (fbVC.view.frame.height - bottomSpecing)
        
    }
    
    func setupIntFarebreakupView(){

        self.addTranparentView()
        let intFBVC = IntFareBreakupVC.instantiate(fromAppStoryboard: .InternationalReturnAndMulticityDetails)
        intFBVC.taxesResult = self.viewModel.taxesResult
        intFBVC.journey = self.viewModel.oldIntJourney
        intFBVC.sid = self.viewModel.sid
        intFBVC.isFromFlightDetails = true
        intFBVC.fromScreen = "upgradePlan"
        intFBVC.isUpgradePlanScreenVisible = true
        intFBVC.delegate = self
        intFBVC.bookFlightObject = self.viewModel.bookingObject ??  BookFlightObject()
        intFBVC.fewSeatsLeftViewHeightFromFlightDetails = 0
        intFBVC.view.autoresizingMask = []
        self.view.addSubview(intFBVC.view)
        self.addChild(intFBVC)
        intFBVC.didMove(toParent: self)
        self.intFareBreakup = intFBVC
        var bottomSpecing = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0.0
        if bottomSpecing != 0.0{
            bottomSpecing = 20.0
        }
        self.innerControllerBottomConstraint = (intFBVC.view.frame.height - bottomSpecing)
    }
    
    private func addTranparentView(){
        viewForFare.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        self.view.addSubview(viewForFare)
    }
    
    func updateFareBreakupView(fareAmount: String){
        if self.viewModel.isInternational{
            intFareBreakup?.journey = self.viewModel.oldIntJourney
            intFareBreakup?.reloadDataForAddons()
        }else{
            fareBreakupVC?.updateData(with: self.viewModel.getOtherModelForDomestic())
        }
        
    }
    
    @IBAction func tapCloseButton(_ sender: Any) {
                
        FirebaseEventLogs.shared.logEventsWithoutParam(with: .CloseButtonClicked)

        self.dismiss(animated: true, completion: nil)
    }
    
}

extension UpgradePlanContrainerVC: UpgradePlanVMDelegate{
    func willFetchDataAt(index: Int) {
        self.allChildVCs[index].shouldStartIndicator(isDataFetched: false)
    }
    
    func didFetchDataAt(index: Int, data: [OtherFareModel]?) {
        self.viewModel.ohterFareData[index] = data
        self.viewModel.selectedOhterFareData[index] = data?.first(where: {$0.isDefault})
        self.allChildVCs[index].shouldStartIndicator(isDataFetched: true)
        
    }
    
    func failsWithError(index: Int) {
        self.viewModel.ohterFareData[index] = nil
        self.allChildVCs[index].shouldStartIndicator(isDataFetched: false)
    }

}



extension UpgradePlanContrainerVC: PagingViewControllerDataSource , PagingViewControllerDelegate ,PagingViewControllerSizeDelegate{
    
    func pagingViewController(_: PagingViewController, widthForPagingItem pagingItem: PagingItem, isSelected: Bool) -> CGFloat {
        
        if let pagingIndexItem = pagingItem as? MenuItem, let text = pagingIndexItem.attributedTitle {
            let attText = NSMutableAttributedString(attributedString: text)
            attText.addAttribute(.font, value: AppFonts.SemiBold.withSize(16), range: NSRange(location: 0, length: attText.length))
            let width = attText.widthOfText(50, font: AppFonts.SemiBold.withSize(16))
            return (width + 20.0)
            
        }
        
        return 100.0
    }
    
    
    func numberOfViewControllers(in pagingViewController: PagingViewController) -> Int {
        viewModel.allTabsStr.count
    }
    
    func pagingViewController(_ pagingViewController: PagingViewController, viewControllerAt index: Int) -> UIViewController {
        allChildVCs[index]
    }
    
    func pagingViewController(_: PagingViewController, pagingItemAt index: Int) -> PagingItem {
        
//        return LogoMenuItem(index: index, isSelected: true, attributedTitle: viewModel.allTabsStr[index], logoUrl: AppConstants.airlineMasterBaseUrl + viewModel.allFlightsData[index].al + ".png")
        
        return MenuItem(title: "", index: index, isSelected:true, attributedTitle: viewModel.allTabsStr[index])
    }
    
    func pagingViewController(_ pagingViewController: PagingViewController, didScrollToItem pagingItem: PagingItem, startingViewController: UIViewController?, destinationViewController: UIViewController, transitionSuccessful: Bool)  {
        
        if let pagingIndexItem = pagingItem as? MenuItem {
            viewModel.currentIndex = pagingIndexItem.index
        }
    }
}


extension UpgradePlanContrainerVC : FareBreakupVCDelegate{

    func bookButtonTapped(journeyCombo: [CombinationJourney]?)
    {
        FirebaseEventLogs.shared.logUpgradePlanEvent(with: .UpgradePlanBookOptionSelected)


        if #available(iOS 13.0, *) {
            self.isModalInPresentation = true
        }
        AppFlowManager.default.proccessIfUserLoggedInForFlight(verifyingFor: .loginVerificationForCheckout,presentViewController: true, vc: self) { [weak self](isGuest) in
            guard let self = self else {return}
            if self.viewModel.isInternational{
                self.intFareBreakup?.hideShowLoader(isHidden: false)
            }else{
                self.fareBreakupVC?.hideShowLoader(isHidden: false)
            }
            let vc = PassengersSelectionVC.instantiate(fromAppStoryboard: .PassengersSelection)
            vc.viewModel.taxesResult = self.viewModel.taxesResult
            vc.viewModel.sid = self.viewModel.sid
            vc.viewModel.bookingObject = self.viewModel.bookingObject
            AppFlowManager.default.removeLoginConfirmationScreenFromStack()
            self.pushToPassenserSelectionVC(vc)
        }
    }


    func pushToPassenserSelectionVC(_ vc: PassengersSelectionVC){
        

        FirebaseEventLogs.shared.logUpgradePlanEvent(with: .UpgradePlanPresentPessangerSelectionScreen)

        self.presentedViewController?.dismiss(animated: false, completion: nil)
        self.view.isUserInteractionEnabled = false
        self.viewModel.fetchConfirmationData(){[weak self] success, errorCodes in
            guard let self = self else {return}
            self.view.isUserInteractionEnabled = true
            if self.viewModel.isInternational{
                self.intFareBreakup?.hideShowLoader(isHidden: true)
            }else{
                self.fareBreakupVC?.hideShowLoader(isHidden: true)
            }
            if success{
                DispatchQueue.main.async{
                    if #available(iOS 13.0, *) {
                        self.isModalInPresentation = false
                    }
                    vc.viewModel.newItineraryData = self.viewModel.itineraryData
                    let nav = UINavigationController(rootViewController: vc)
                    nav.modalPresentationStyle = .fullScreen
                    nav.modalPresentationCapturesStatusBarAppearance = true
                    self.present(nav, animated: true, completion: nil)
                }
            }else{
                AppGlobals.shared.showErrorOnToastView(withErrors: errorCodes, fromModule: .flightConfirmation)
            }

        }
    }

    
    func infoButtonTapped(isViewExpanded: Bool)
    {
        FirebaseEventLogs.shared.logUpgradePlanEvent(with: .UpgradePlanInfoOptionSelected)

        if isViewExpanded{
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
