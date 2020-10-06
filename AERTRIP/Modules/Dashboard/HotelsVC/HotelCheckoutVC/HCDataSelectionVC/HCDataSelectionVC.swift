//
//  HCDataSelectionVC.swift
//  AERTRIP
//
//  Created by Admin on 12/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol HCDataSelectionVCDelegate: class {
    func updateFarePrice()
}

class HCDataSelectionVC: BaseVC {
    // MARK: - IBOutlets
    
    // MARK: -
    
    @IBOutlet weak var mainIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var topNavView: TopNavigationView!
    @IBOutlet weak var tableView: ATTableView!
    @IBOutlet weak var continueContainerView: UIView!
    @IBOutlet weak var continueGradientView: UIView!
    @IBOutlet weak var continueViewBottomConstraint: NSLayoutConstraint!
    
    // continue
    @IBOutlet weak var fareDetailContainerView: UIView!
    @IBOutlet weak var fareDetailBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var totalFareLabel: UILabel!
    @IBOutlet weak var infoTextLabel: UILabel!
    @IBOutlet weak var upArrowImageView: UIImageView!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var continueButtonActivityIndicator: UIActivityIndicatorView!
    
    // minimized hotel details
    @IBOutlet weak var hotelDetailsParentContainerView: UIView!
    @IBOutlet weak var hotelDetailsContainerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var hotelDetailsContainerView: UIView!
    @IBOutlet weak var hotelCheckOutDetailsContainerVIew: UIView!
    @IBOutlet weak var hotelNameLabel: UILabel!
    @IBOutlet weak var checkInOutDate: UILabel!
    @IBOutlet weak var detailsButton: UIButton!
    @IBOutlet weak var fareBreakupTitleLabel: UILabel!
    @IBOutlet weak var fareDetailLabel: UILabel!
    @IBOutlet weak var totalPayableTextLabel: UILabel!
    @IBOutlet weak var totalFareAmountLabel: UILabel!
    @IBOutlet weak var loaderContainerView: UIView!
    @IBOutlet weak var activityLoader: UIActivityIndicatorView!
    @IBOutlet weak var fareDetailBlackView: UIView!
    
    // MARK: - Properties
    
    // MARK: - Public
    
    let viewModel = HCDataSelectionVM()
    var isHotelDetailsCheckOutViewOpen: Bool = false
    var statusBarHeight: CGFloat {
        return UIApplication.shared.statusBarFrame.height
    }
    
    var isFromFinalCheckout: Bool = false
    var confirmationCall: Int = 1
    
    var apiCount: Int = 0
    var isGrossValueZero: Bool = false
    weak var delegate: HCDataSelectionVCDelegate?
    internal var checkoutSessionExpireCompletionHandler: (() -> Void)? = nil
    
    // MARK: - Private
    
    let hotelFormData = HotelsSearchVM.hotelFormData
    
    // MARK: - ViewLifeCycle
    
    // MARK: -
    
    override func initialSetup() {
        setupNavView()
        setUpIndicatorView()
        
        statusBarStyle = .default
        animateFareDetails(isHidden: true, animated: false)
        
        continueContainerView.backgroundColor = .clear
        continueGradientView.addGredient(isVertical: false)
        viewModel.fetchConfirmItineraryData()
        //        self.fetchConfirmItineraryDataSuccess()
        fillData()
        
        //        manageLoader(shouldStart: true)
        manageLoader(shouldStart: false)
        startLoading()
        continueButtonActivityIndicator.color = AppColors.themeWhite
        
        setUpUserEmailMobile()
        
        setupGuestArray()
        registerXIBs()
        
        self.checkoutSessionExpireCompletionHandler = { [weak self] in
            guard let strongSelf = self else {return}
            //AppFlowManager.default.mainNavigationController.popToRootController(animated: true)
            AppFlowManager.default.mainNavigationController.dismiss(animated: false, completion: nil)
            AppFlowManager.default.mainNavigationController.popToRootController(animated: false)
            //AppFlowManager.default.currentNavigation?.dismiss(animated: true, completion: nil)
            strongSelf.topNavBarLeftButtonAction(strongSelf.topNavView.leftButton)
            delay(seconds: 0.2) {
                NotificationCenter.default.post(name: .checkoutSessionExpired, object: nil)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        delay(seconds: 0.2) {
            self.statusBarColor = AppColors.clear
            self.statusBarStyle = .darkContent
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func setupFonts() {
        // continue button
        totalFareLabel.font = AppFonts.SemiBold.withSize(20.0)
        infoTextLabel.font = AppFonts.Regular.withSize(14.0)
        continueButton.titleLabel?.font = AppFonts.SemiBold.withSize(20.0)
        
        // hotel details
        hotelNameLabel.font = AppFonts.SemiBold.withSize(18.0)
        checkInOutDate.font = AppFonts.Regular.withSize(16.0)
        detailsButton.titleLabel?.font = AppFonts.Regular.withSize(18.0)
        
        // fare breakup
        fareBreakupTitleLabel.font = AppFonts.SemiBold.withSize(16.0)
        fareDetailLabel.font = AppFonts.Regular.withSize(16.0)
        totalPayableTextLabel.font = AppFonts.Regular.withSize(20.0)
        totalFareAmountLabel.font = AppFonts.SemiBold.withSize(20.0)
    }
    
    override func setupTexts() {
        // continue button
        infoTextLabel.text = LocalizedString.Info.localized
        continueButton.setTitle(LocalizedString.Continue.localized, for: .normal)
        
        // hotel details
        detailsButton.setTitle(LocalizedString.Details.localized, for: .normal)
        
        // fare breakup
        fareBreakupTitleLabel.text = LocalizedString.FareBreakup.localized
        totalPayableTextLabel.text = LocalizedString.TotalPayableNow.localized
    }
    
    func setUpIndicatorView() {
        self.mainIndicatorView.isHidden = true
        self.mainIndicatorView.style = .whiteLarge
        self.mainIndicatorView.color = AppColors.themeGreen
    }
    override func setupColors() {
        // continue button
        totalFareLabel.textColor = AppColors.themeWhite
        infoTextLabel.textColor = AppColors.themeWhite
        continueButton.setTitleColor(AppColors.themeWhite, for: .normal)
        
        // hotel details
        hotelNameLabel.textColor = AppColors.themeBlack
        checkInOutDate.textColor = AppColors.themeGray40
        detailsButton.setTitleColor(AppColors.themeGreen, for: .normal)
    }
    
    override func bindViewModel() {
        viewModel.delegate = self
    }
    
    private func manageLoader(shouldStart: Bool) {
        self.mainIndicatorView.isHidden = true
        self.mainIndicatorView.style = .whiteLarge
        self.mainIndicatorView.color = AppColors.themeGreen
        activityLoader.style = .whiteLarge
        activityLoader.color = AppColors.themeGreen
        activityLoader.startAnimating()
        
        loaderContainerView.backgroundColor = AppColors.themeWhite.withAlphaComponent(0.5)
        
        loaderContainerView.isHidden = !shouldStart
    }
    
    private func fillData() {
        totalFareLabel.text = (viewModel.itineraryData?.total_fare ?? 0.0).amountInDelimeterWithSymbol
        setupFareBreakup()
        
        hotelNameLabel.text = viewModel.itineraryData?.hotelDetails?.hname ?? ""
        
        var finalDate = ""
        if let chIn = viewModel.itineraryData?.hotelDetails?.checkin, !chIn.isEmpty {
            finalDate = Date.getDateFromString(stringDate: chIn, currentFormat: "yyyy-MM-dd", requiredFormat: "d MMM") ?? ""
        }
        
        if let chOut = viewModel.itineraryData?.hotelDetails?.checkout, !chOut.isEmpty {
            let txt = Date.getDateFromString(stringDate: chOut, currentFormat: "yyyy-MM-dd", requiredFormat: "d MMM") ?? ""
            
            if finalDate.isEmpty {
                finalDate = txt
            }
            else {
                finalDate += " - \(txt)"
            }
        }
        
        checkInOutDate.text = finalDate
        checkInOutDate.isHidden = finalDate.isEmpty
    }
    
    private func setupNavView() {
        topNavView.delegate = self
        topNavView.configureNavBar(title: LocalizedString.Guests.localized, isLeftButton: true, isFirstRightButton: true, isSecondRightButton: false, isDivider: true)
        
        topNavView.configureFirstRightButton(normalImage: #imageLiteral(resourceName: "AddPassenger"), selectedImage: #imageLiteral(resourceName: "AddPassenger"))
    }
    
    private func registerXIBs() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = AppColors.themeGray04
        
        tableView.registerCell(nibName: EmptyTableViewCell.reusableIdentifier)
        tableView.registerCell(nibName: HCEmailTextFieldCell.reusableIdentifier)
        tableView.registerCell(nibName: ContactTableCell.reusableIdentifier)
        tableView.registerCell(nibName: HCPanCardTextFieldCell.reusableIdentifier)
        
    }
    
    // MARK: - Methods
    
    // MARK: - Private
    
    private func setupFareBreakup() {
        if let room = viewModel.itineraryData?.hotelDetails?.num_rooms, let night = viewModel.itineraryData?.hotelDetails?.no_of_nights {
            let roomText = (room > 1) ? LocalizedString.Rooms.localized : LocalizedString.Room.localized
            let nightText = (night > 1) ? LocalizedString.Nights.localized : LocalizedString.Night.localized
            fareBreakupTitleLabel.text = "\(LocalizedString.FareBreakup.localized) (\(room) \(roomText) & \(night) \(nightText))"
        }
        
        totalFareAmountLabel.text = (viewModel.itineraryData?.total_fare ?? 0.0).amountInDelimeterWithSymbol
        
    }
    
    private func toggleFareDetailView() {
        animateFareDetails(isHidden: fareDetailBottomConstraint.constant >= 0, animated: true)
    }
    
    private func animateFareDetails(isHidden: Bool, animated: Bool) {
        let rotateTrans = isHidden ? CGAffineTransform.identity : CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        var blackViewAlpha: CGFloat = 1.0
        if !isHidden {
            fareDetailContainerView.isHidden = false
            fareDetailBlackView.isHidden = false
            blackViewAlpha = 1.0
            if isHotelDetailsCheckOutViewOpen {
                //                self.hotelCheckOutDetailsContainerVIew.transform = CGAffineTransform(translationX: 0, y: view.height - (hotelDetailsParentContainerView.height + fareDetailContainerView.height + AppFlowManager.default.safeAreaInsets.top))
                hotelDetailsContainerViewHeightConstraint.constant = view.height - (hotelDetailsParentContainerView.height + fareDetailContainerView.height)
            }
        }
        else {
            blackViewAlpha = 0.0
            if isHotelDetailsCheckOutViewOpen {
                //                 self.hotelCheckOutDetailsContainerVIew.transform = CGAffineTransform(translationX: 0, y: view.height - (hotelDetailsParentContainerView.height +  AppFlowManager.default.safeAreaInsets.top))
                hotelDetailsContainerViewHeightConstraint.constant = view.height - (hotelDetailsParentContainerView.height )
            }
        }
        UIView.animate(withDuration: animated ? AppConstants.kAnimationDuration : 0.0, animations: { [weak self] in
            guard let sSelf = self else { return }
            //            sSelf.fareDetailContainerView.transform = isHidden ? CGAffineTransform(translationX: 0, y: -(sSelf.fareDetailContainerView.height)) : CGAffineTransform(translationX: 0, y: 0)
            let safeDistance:CGFloat = AppFlowManager.default.safeAreaInsets.bottom
            sSelf.fareDetailBottomConstraint.constant = isHidden ? -(sSelf.fareDetailContainerView.height) : safeDistance
            sSelf.upArrowImageView.transform = rotateTrans
            sSelf.continueViewBottomConstraint.constant = isHidden ? safeDistance : 0
            sSelf.fareDetailBlackView.alpha = blackViewAlpha
            sSelf.view.layoutIfNeeded()
            
            }, completion: { [weak self] _ in
                if isHidden {
                    self?.fareDetailContainerView.isHidden = true
                    self?.fareDetailBlackView.isHidden = true
                }
        })
    }
    
    private func setupGuestArray() {
        GuestDetailsVM.shared.guests.removeAll()
        for i in 0..<hotelFormData.adultsCount.count {
            var temp: [ATContact] = []
            for j in 0..<hotelFormData.adultsCount[i] + hotelFormData.childrenCounts[i] {
                var guest = ATContact()
                if j < hotelFormData.adultsCount[i] {
                    guest.passengerType = PassengersType.Adult
                    guest.numberInRoom = (j + 1)
                    guest.age = -1
                    guest.id = "\(j + 1)"
                }
                else {
                    guest.passengerType = PassengersType.Child
                    let childIdx = (j - hotelFormData.adultsCount[i])
                    guest.numberInRoom = childIdx + 1
                    guest.age = hotelFormData.childrenAge[i][childIdx]
                    guest.id = "\(childIdx)"
                }
                temp.append(guest)
            }
            GuestDetailsVM.shared.guests.append(temp)
        }
        GuestDetailsVM.shared.canShowSalutationError = false
    }
    
    private func sendToFinalCheckoutVC() {
        if !isFromFinalCheckout {
            //            AppFlowManager.default.moveToFinalCheckoutVC(delegate: self, viewModel.itineraryData, viewModel.itineraryPriceDetail, originLat: viewModel.hotelInfo?.lat ?? "", originLong: viewModel.hotelInfo?.long ?? "")
            if !isGrossValueZero {
                AppFlowManager.default.moveToFinalCheckoutVC(delegate: self, viewModel.itineraryData, viewModel.itineraryPriceDetail, originLat: viewModel.hotelInfo?.lat ?? "", originLong: viewModel.hotelInfo?.long ?? "")
            }
            else {
                AppToast.default.showToastMessage(message: LocalizedString.SomethingWentWrong.localized)
            }
        }
    }
    
    // MARK: Helper methods
    
    func startLoading() {
        self.continueButtonActivityIndicator.isHidden = false
        self.continueButtonActivityIndicator.startAnimating()
        self.view.isUserInteractionEnabled = false
        self.continueButton.isHidden = true
    }
    
    func stopLoading() {
        self.continueButtonActivityIndicator.isHidden = true
        self.continueButtonActivityIndicator.stopAnimating()
        self.view.isUserInteractionEnabled = true
        self.continueButton.isHidden = false
    }
    // MARK: - Public
    
    // MARK: - Action
    @IBAction func fareDetailBackgroundTapped(_ sender: Any) {
        toggleFareDetailView()
    }
    
    @IBAction func fareInfoButtonAction(_ sender: UIButton) {
        toggleFareDetailView()
    }
    
    @IBAction func continueButtonAction(_ sender: UIButton) {
        isFromFinalCheckout = false
        if viewModel.isValidateData(vc: self) {
            apiCount = 0
            if UserInfo.loggedInUser != nil {
                self.viewModel.fetchRecheckRatesData()
            } else {
                self.viewModel.logInUserApi()
            }
        } else {
            viewModel.canShowErrorForEmailPhone = true
            self.tableView.reloadData()
        }
    }
    
    @IBAction func detailsButtonAction(_ sender: UIButton) {
        if viewModel.itineraryData != nil {
            //            hotelDetailsContainerView.isHidden = true
            //            hotelCheckOutDetailsContainerVIew.isHidden = false
            //            UIView.animate(withDuration: AppConstants.kAnimationDuration, animations: {
            //                if self.fareDetailContainerView.isHidden {
            //                    self.hotelDetailsContainerViewHeightConstraint.constant = self.view.height - (UIDevice.isIPhoneX   ?  self.hotelDetailsParentContainerView.height /*+  AppFlowManager.default.safeAreaInsets.top - 5 */:  self.hotelDetailsParentContainerView.height + 3)
            //                }
            //                else {
            //                    self.hotelDetailsContainerViewHeightConstraint.constant = self.view.height - (self.hotelDetailsParentContainerView.height + self.fareDetailContainerView.height/* + AppFlowManager.default.safeAreaInsets.top */)
            //                }
            //                self.view.layoutIfNeeded()
            //            }, completion: { [weak self] _ in
            //                self?.isHotelDetailsCheckOutViewOpen = true
            //                self?.hotelCheckOutDetailsContainerVIew?.backgroundColor = AppColors.themeBlack.withAlphaComponent(0.4)
            //                //self?.statusBarColor = AppColors.themeGray140
            //
            //            })
            AppFlowManager.default.moveToHotelCheckoutDetailVC(viewModel: self.viewModel, delegate: self)
        }
        
        
    }
}

extension HCDataSelectionVC: HCDataSelectionVMDelegate {
    func updateFavouriteSuccess(withMessage: String) {
        //        if let hotelCheckOutDetailsVIew = self.hotelCheckOutDetailsVIew {
        //            //            hotelCheckOutDetailsVIew.hotelDetailsTableView.reloadData()
        //            sendDataChangedNotification(data: self)
        //            let buttonImage: UIImage = viewModel.hotelInfo?.fav == "1" ? #imageLiteral(resourceName: "saveHotelsSelected") : #imageLiteral(resourceName: "saveHotels")
        //            hotelCheckOutDetailsVIew.headerView.leftButton.setImage(buttonImage, for: .normal)
        //        }
    }
    
    func updateFavouriteFail(errors: ErrorCodes) {
        AppNetworking.hideLoader()
        //        if let hotelCheckOutDetailsVIew = self.hotelCheckOutDetailsVIew {
        //            sendDataChangedNotification(data: self)
        //            let buttonImage: UIImage = viewModel.hotelInfo?.fav == "1" ? #imageLiteral(resourceName: "saveHotelsSelected") : #imageLiteral(resourceName: "saveHotels")
        //            hotelCheckOutDetailsVIew.headerView.leftButton.setImage(buttonImage, for: .normal)
        //        }
        if let _ = UserInfo.loggedInUser {
            if errors.contains(array: [-1]) {
                AppGlobals.shared.showErrorOnToastView(withErrors: errors, fromModule: .profile)
            }
            else {
                AppGlobals.shared.showErrorOnToastView(withErrors: errors, fromModule: .hotelsSearch)
            }
        }
    }
    
    // ItenaryDataTraveller
    
    func willCallForItenaryDataTraveller() {
        //
        self.startLoading()
    }
    
    func callForItenaryDataTravellerSuccess() {
        self.isGrossValueZero = false
        if apiCount <= 5, viewModel.itineraryPriceDetail.grossAmount.toDouble ?? 0 <= 0 {
            viewModel.webserviceForItenaryDataTraveller()
            apiCount += 1
        } else {
            self.stopLoading()
        }
        
        if viewModel.itineraryPriceDetail.grossAmount.toDouble ?? 0 > 0 {
            self.sendToFinalCheckoutVC()
        }
        
    }
    
    func callForItenaryDataTravellerFail(errors: ErrorCodes) {
        self.stopLoading()
        self.isGrossValueZero = true
        if errors.contains(55) {
            AppToast.default.showToastMessage(message: LocalizedString.ResultUnavailable.localized, onViewController: self, buttonTitle: LocalizedString.ReloadResults.localized, buttonAction: self.checkoutSessionExpireCompletionHandler)
        } else {
            AppGlobals.shared.showErrorOnToastView(withErrors: errors, fromModule: .hotelsSearch)
        }
    }
    
    func willFetchConfirmItineraryData() {
        self.startLoading()
        //        manageLoader(shouldStart: true)
    }
    
    func fetchConfirmItineraryDataSuccess() {
        self.stopLoading()
        if viewModel.itineraryData == nil, confirmationCall < 5 {
            confirmationCall += 1
            viewModel.fetchConfirmItineraryData()
        }
        else {
            HCSelectGuestsVM.shared.clearAllSelectedData()
            GuestDetailsVM.shared.travellerList = viewModel.itineraryData?.traveller_master ?? []
            manageLoader(shouldStart: false)
            AppGlobals.shared.stopLoading()
            self.fillData()
            self.viewModel.getHotelDetailsSectionData()
        }
        self.tableView.reloadData()
        if (self.viewModel.itineraryData?.hotelDetails?.is_price_change ?? false) {
            
            if let newAmount = viewModel.itineraryData?.total_fare, let oldAmount = self.viewModel.detailPageRoomRate?.price  {
                
                let diff = newAmount - oldAmount
                if diff > 0 {
                    // increased
                    FareUpdatedPopUpVC.showPopUp(isForIncreased: true, decreasedAmount: 0.0, increasedAmount: diff, totalUpdatedAmount: newAmount, continueButtonAction: { [weak self] in
                        guard let sSelf = self else { return }
                        //                        sSelf.sendToFinalCheckoutVC()
                        }, goBackButtonAction: { [weak self] in
                            guard let sSelf = self else { return }
                            sSelf.delegate?.updateFarePrice()
                            sSelf.topNavBarLeftButtonAction(sSelf.topNavView.leftButton)
                    })
                }
                else if diff < 0 {
                    // dipped
                    //                    FareUpdatedPopUpVC.showPopUp(isForIncreased: false, decreasedAmount: -diff, increasedAmount: 0, totalUpdatedAmount: 0, continueButtonAction: nil, goBackButtonAction: nil)
                    //                    delay(seconds: 2.0) { [weak self] in
                    //                        guard let sSelf = self else { return }
                    //                        sSelf.sendToFinalCheckoutVC()
                    //                    }
                }
                
            }
        }
    }
    
    func fetchConfirmItineraryDataFail(errors: ErrorCodes) {
        //        manageLoader(shouldStart: false)
        //        AppGlobals.shared.stopLoading()
        self.stopLoading()
        if viewModel.itineraryData == nil, confirmationCall < 5 {
            confirmationCall += 1
            viewModel.fetchConfirmItineraryData()
        } else {
            if errors.contains(55) {
                AppToast.default.showToastMessage(message: LocalizedString.ResultUnavailable.localized, onViewController: self, buttonTitle: LocalizedString.ReloadResults.localized, buttonAction: self.checkoutSessionExpireCompletionHandler)
            } else {
                AppGlobals.shared.showErrorOnToastView(withErrors: errors, fromModule: .hotelsSearch)
            }
        }
    }
    
    func willFetchRecheckRatesData() {
        self.startLoading()
        //  manageLoader(shouldStart: true)
        //AppGlobals.shared.startLoading()
        //        self.mainIndicatorView.isHidden = false
        //        self.mainIndicatorView.startAnimating()
        //       startLoading()
    }
    
    func fetchRecheckRatesDataFail(errors: ErrorCodes) {
        // self.stopLoading()
        self.stopLoading()
        //        self.mainIndicatorView.isHidden = true
        //        manageLoader(shouldStart: true)
        if errors.contains(array: [11]) {
            //send to result screen and re-hit the search API
            self.sendDataChangedNotification(data: ATNotification.GRNSessionExpired)
            for vc in AppFlowManager.default.currentNavigation?.viewControllers ?? [] {
                if let obj = vc as? HotelResultVC {
                    //close hotel details if open
                    for vc in obj.children {
                        if let detailVC = vc as? HotelDetailsVC {
                            detailVC.hide(animated: true)
                            break
                        }
                    }
                    AppFlowManager.default.popViewController(animated: true)
                }
            }
        } else if errors.contains(55) {
            AppToast.default.showToastMessage(message: LocalizedString.ResultUnavailable.localized, onViewController: self, buttonTitle: LocalizedString.ReloadResults.localized, buttonAction: self.checkoutSessionExpireCompletionHandler)
        }else {
            AppGlobals.shared.showErrorOnToastView(withErrors: errors, fromModule: .hotelsSearch)
        }
        //        manageLoader(shouldStart: false)
        
        
        //AppGlobals.shared.stopLoading()
    }
    
    func fetchRecheckRatesDataSuccess(recheckedData: ItineraryData) {
        // manageLoader(shouldStart: false)
        // stopLoading()
        self.stopLoading()
        //        self.mainIndicatorView.stopAnimating()
        //        self.mainIndicatorView.isHidden = true
        
        func fetchIternaryData() {
            if viewModel.isValidateData(vc: self) {
                viewModel.webserviceForItenaryDataTraveller()
            }
        }
        
        if let oldAmount = viewModel.itineraryData?.total_fare {
            let newAmount = recheckedData.total_fare
            
            viewModel.itineraryData = recheckedData
            
            let diff = newAmount - oldAmount
            if diff > 0 {
                // increased
                FareUpdatedPopUpVC.showPopUp(isForIncreased: true, decreasedAmount: 0.0, increasedAmount: diff, totalUpdatedAmount: newAmount, continueButtonAction: { [weak self] in
                    guard let sSelf = self else { return }
                    fetchIternaryData()
                    }, goBackButtonAction: { [weak self] in
                        guard let sSelf = self else { return }
                        sSelf.topNavBarLeftButtonAction(sSelf.topNavView.leftButton)
                })
            }
            else if diff < 0 {
                // dipped
                FareUpdatedPopUpVC.showPopUp(isForIncreased: false, decreasedAmount: -diff, increasedAmount: 0, totalUpdatedAmount: 0, continueButtonAction: nil, goBackButtonAction: nil)
                self.startLoading()
                delay(seconds: 2.0) { [weak self] in
                    guard let sSelf = self else { return }
                    fetchIternaryData()
                }
            }
            else {
                fetchIternaryData()
                //sendToFinalCheckoutVC()
            }
        }
    }
    
    func userLoginApiSuccess() {
        self.viewModel.fetchRecheckRatesData()
    }
    
    func userLoginFailed(errors: ErrorCodes) {
        AppGlobals.shared.showErrorOnToastView(withErrors: errors, fromModule: .login)
    }
    
    /*
     user login success
     
     */
}

extension HCDataSelectionVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        // back button action
        //AppFlowManager.default.popViewController(animated: true)
        if #available(iOS 13.0, *) {
            statusBarStyle = .lightContent
        }
        self.dismissAsPopAnimation()
        delay(seconds: 0.1) {
            GuestDetailsVM.shared.guests.removeAll()
        }
    }
    
    func topNavBarFirstRightButtonAction(_ sender: UIButton) {
        // plus button action
        AppFlowManager.default.presentHCSelectGuestsVC(delegate: self)
    }
}

extension HCDataSelectionVC: HCSelectGuestsVCDelegate {
    func didAddedContacts() {
        tableView.reloadData()
    }
}

extension HCDataSelectionVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hotelFormData.adultsCount.count + 11
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let newRow = indexPath.row - hotelFormData.adultsCount.count
        
        if newRow < 0 {
            // room data cell
            let totalCount = hotelFormData.adultsCount[indexPath.row] + hotelFormData.childrenCounts[indexPath.row]
            var isEmptyText = true
            for i in stride(from: 0, to: totalCount, by: 1) {
                if GuestDetailsVM.shared.guests.count > indexPath.row, GuestDetailsVM.shared.guests[indexPath.row].count > i {
                    let object = GuestDetailsVM.shared.guests[indexPath.row][i]
                    if (!object.firstName.isEmpty || !object.lastName.isEmpty) {
                        isEmptyText = false
                    }
                }
            }
            
            let constantHeight: CGFloat = isEmptyText ? 140 : 157
            var extraHeight:CGFloat = 0
            if isEmptyText {
                extraHeight = (indexPath.row == hotelFormData.adultsCount.count - 1) ? 16 : 0
            } else {
                extraHeight = (indexPath.row == hotelFormData.adultsCount.count - 1) ? 17 : 0
            }
            if (totalCount <= 4)  {
                return constantHeight * ((totalCount <= 4) ? 1.0 : 2.0) + extraHeight
            } else {
                var isEmptyText = true
                for i in stride(from: 4, to: totalCount, by: 1) {
                    if GuestDetailsVM.shared.guests.count > indexPath.row, GuestDetailsVM.shared.guests[indexPath.row].count > i {
                        let object = GuestDetailsVM.shared.guests[indexPath.row][i]
                        if (!object.firstName.isEmpty || !object.lastName.isEmpty) {
                            isEmptyText = false
                        }
                    }
                }
                if isEmptyText {
                    extraHeight = (indexPath.row == hotelFormData.adultsCount.count - 1) ? 16 : 0
                    let height = constantHeight + 111
                    return height + extraHeight
                    
                } else {
                    return constantHeight * ((totalCount <= 4) ? 1.0 : 2.0) + extraHeight
                }
            }
            
        }
        else {
            switch newRow {
            case 0, 2, 8, 10:
                // space
                return 35.0
                
            case 1:
                // prefrences
                return 78.0
                
            case 3:
                // contact details text
                return 37.0
                
            case 4:
                // mobile number
                return 60.0
                
            case 5:
                // email
                return 60.0
                
            case 6:
                //text message
                return 58.0
                
            case 7:
                //pan card
                return (self.viewModel.itineraryData?.hotelDetails?.pan_required ?? false) ? 60.0 : CGFloat.leastNormalMagnitude
                
            case 9:
                //Travel Safety Guidelines
                return 44.0
                
            default:
                return 0.0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let newRow = indexPath.row - hotelFormData.adultsCount.count
        
        if newRow < 0 {
            // room data cell
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HCDataSelectionRoomDetailCell.reusableIdentifier) as? HCDataSelectionRoomDetailCell else {
                return UITableViewCell()
            }
            cell.configData(forIndexPath: indexPath)
            
            return cell
        }
        else {
            switch newRow {
            case 0, 2, 8, 10:
                // space
                guard let cell = tableView.dequeueReusableCell(withIdentifier: EmptyTableViewCell.reusableIdentifier) as? EmptyTableViewCell else {
                    return UITableViewCell()
                }
                
                cell.contentView.backgroundColor = AppColors.themeGray04
                cell.backgroundColor = AppColors.themeGray04
                cell.bottomDividerView.isHidden = newRow == 10
                
                return cell
                
            case 1:
                // prefrences
                guard let cell = tableView.dequeueReusableCell(withIdentifier: HCDataSelectionPrefrencesCell.reusableIdentifier) as? HCDataSelectionPrefrencesCell else {
                    return UITableViewCell()
                }
                cell.configureData(prefrenceNames: self.viewModel.selectedRequestsName, request: self.viewModel.specialRequest, other: self.viewModel.other)
                cell.titleLabel.font = AppFonts.Regular.withSize(18)
                return cell
                
            case 3:
                // contact details text
                guard let cell = tableView.dequeueReusableCell(withIdentifier: HCDataSelectionTextLabelCell.reusableIdentifier) as? HCDataSelectionTextLabelCell else {
                    return UITableViewCell()
                }
                
                cell.titleLabel.font = AppFonts.SemiBold.withSize(16.0)
                cell.titleLabel.textColor = AppColors.themeBlack
                cell.titleLabel.text = "Contact Details"
                cell.topConstraint.constant = 16.0
                
                return cell
                
            case 4:
                // mobile number
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ContactTableCell.reusableIdentifier) as? ContactTableCell else {
                    return UITableViewCell()
                }
                cell.contactTitleLabel.isHidden = true
                cell.minContactLimit = self.viewModel.minContactLimit
                cell.contactNumberTextField.setUpAttributedPlaceholder(placeholderString: LocalizedString.Mobile.localized,with: "")
                if viewModel.canShowErrorForEmailPhone {
                    cell.checkForErrorStateOfTextfield()
                }
                cell.delegate = self
                return cell
                
            case 5:
                // email
                guard let cell = tableView.dequeueReusableCell(withIdentifier: HCEmailTextFieldCell.reusableIdentifier) as? HCEmailTextFieldCell else {
                    return UITableViewCell()
                }
                
                cell.editableTextField.isEnabled = UserInfo.loggedInUserId == nil
                cell.editableTextField.setUpAttributedPlaceholder(placeholderString: LocalizedString.Email_ID.localized,with: "")
                cell.delegate = self
                cell.editableTextField.text = viewModel.email
//                cell.editableTextField.font = AppFonts.Regular.withSize(18.0)
                cell.editableTextField.textColor = UserInfo.loggedInUserId == nil ? AppColors.themeBlack : AppColors.themeGray40
                cell.editableTextField.keyboardType = .emailAddress
                
                if viewModel.canShowErrorForEmailPhone {
                    cell.checkForErrorStateOfTextfield()
                }
                cell.editableTextField.font = AppFonts.Regular.withSize(18.0)
                return cell
                
            case 6:
                //text message
                guard let cell = tableView.dequeueReusableCell(withIdentifier: HCDataSelectionTextLabelCell.reusableIdentifier) as? HCDataSelectionTextLabelCell else {
                    return UITableViewCell()
                }
                
                cell.topConstraint.constant = 0.0
                cell.configUI()
                
                return cell
                
            case 7:
                // Pan Number
                guard let cell = tableView.dequeueReusableCell(withIdentifier: HCPanCardTextFieldCell.reusableIdentifier) as? HCPanCardTextFieldCell else {
                    return UITableViewCell()
                }
                
                
                cell.editableTextField.setUpAttributedPlaceholder(placeholderString: LocalizedString.PanCard.localized,with: "")
                cell.delegate = self
                cell.editableTextField.text = viewModel.panCard
                cell.editableTextField.font = AppFonts.Regular.withSize(18.0)
                cell.editableTextField.textColor = AppColors.themeBlack
                cell.editableTextField.keyboardType = .default
                cell.editableTextField.autocapitalizationType = .allCharacters
                if viewModel.canShowErrorForEmailPhone {
                    cell.checkForErrorStateOfTextfield()
                }
                return cell
                
            case 9:
                // Travel Safety Guidelines
                guard let cell = tableView.dequeueReusableCell(withIdentifier: HCDataSelectionTravelSafetyCell.reusableIdentifier) as? HCDataSelectionTravelSafetyCell else {
                    return UITableViewCell()
                }
                return cell
            default:
                return UITableViewCell()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Redirect to Selection Preference VC
        if let _ = tableView.cellForRow(at: indexPath) as? HCDataSelectionPrefrencesCell, let specialRequests = self.viewModel.itineraryData?.special_requests {
            AppFlowManager.default.presentHCSpecialRequestsVC(specialRequests: specialRequests,selectedRequestIds: self.viewModel.selectedSpecialRequest, selectedRequestNames: self.viewModel.selectedRequestsName, other: self.viewModel.other, specialRequest: self.viewModel.specialRequest,delegate: self)
        } else if let _ = tableView.cellForRow(at: indexPath) as? HCDataSelectionTravelSafetyCell {
            AppToast.default.showToastMessage(message: LocalizedString.UnderDevelopment.localized)
        }
    }
    
    func setUpUserEmailMobile() {
        viewModel.mobileNumber = UserInfo.loggedInUser?.mobile ?? ""
        viewModel.mobileIsd = AppConstants.kIndianIsdCode
        viewModel.email = UserInfo.loggedInUser?.email ?? ""
    }
}

// Mark:- HCSpecialRequestsDelegate
//================================
extension HCDataSelectionVC: HCSpecialRequestsDelegate {
    func didPassSelectedRequestsId(ids: [Int], names: [String], other: String, specialRequest: String) {
        printDebug("\(ids),\t\(other),\t\(specialRequest)")
        self.viewModel.selectedSpecialRequest = ids
        self.viewModel.other = other
        self.viewModel.specialRequest = specialRequest
        self.viewModel.selectedRequestsName = names
        self.tableView.reloadData()
    }
}

extension HCDataSelectionVC: FinalCheckOutVCDelegate {
    func cancelButtonTapped() {
        isFromFinalCheckout = true
        if viewModel.isValidateData(vc: self) {
            viewModel.webserviceForItenaryDataTraveller()
        }
    }
}

extension HCDataSelectionVC: HotelCheckOutDetailsVIewDelegate {
    func addHotelInFevList() {
        viewModel.updateFavourite()
    }
    
    func crossButtonTapped() {
        self.hotelCheckOutDetailsContainerVIew.backgroundColor = AppColors.clear
        //self.statusBarColor =  AppColors.themeWhite
        UIView.animate(withDuration: AppConstants.kAnimationDuration, animations: {
            self.hotelDetailsContainerViewHeightConstraint.constant = 0.0
            self.view.layoutIfNeeded()
        }) { [weak self] _ in
            guard let sSelf = self else { return }
            sSelf.isHotelDetailsCheckOutViewOpen = false
            sSelf.hotelDetailsContainerView.isHidden = false
            sSelf.hotelCheckOutDetailsContainerVIew.isHidden = true
            
        }
    }
}

extension HCDataSelectionVC: ContactTableCellDelegate {
    func setIsdCode(_ country: PKCountryModel,_ sender: UIButton) {
        viewModel.mobileIsd = country.countryCode
        viewModel.minContactLimit = country.minNSN
        viewModel.maxContactLimit = country.minNSN
        guard  let cell = sender.tableViewCell as? ContactTableCell  else {
            return
        }
        guard let indexPath = self.tableView.indexPath(for: cell) else {return}
        self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        
    }
    
    func textFieldText(_ textField: UITextField) {
        viewModel.mobileNumber = (textField.text ?? "").alphanumeric
    }
}
