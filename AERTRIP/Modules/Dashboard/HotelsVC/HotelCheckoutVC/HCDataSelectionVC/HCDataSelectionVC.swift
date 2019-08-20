//
//  HCDataSelectionVC.swift
//  AERTRIP
//
//  Created by Admin on 12/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class HCDataSelectionVC: BaseVC {
    // MARK: - IBOutlets
    
    // MARK: -
    
    @IBOutlet weak var topNavView: TopNavigationView!
    @IBOutlet weak var tableView: ATTableView!
    @IBOutlet weak var continueContainerView: UIView!
    
    // continue
    @IBOutlet weak var fareDetailContainerView: UIView!
    @IBOutlet weak var fareDetailBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var totalFareLabel: UILabel!
    @IBOutlet weak var infoTextLabel: UILabel!
    @IBOutlet weak var upArrowImageView: UIImageView!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var infoButton: UIButton!
    
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
    
    // MARK: - Properties
    
    // MARK: - Public
    
    let viewModel = HCDataSelectionVM()
    var hotelCheckOutDetailsVIew: HotelCheckOutDetailsVIew?
    var isHotelDetailsCheckOutViewOpen: Bool = false
    var statusBarHeight: CGFloat {
        return UIApplication.shared.statusBarFrame.height
    }
    
    var isFromFinalCheckout: Bool = false
    var confirmationCall: Int = 1

    var apiCount: Int = 0
    var isGrossValueZero: Bool = false
    // MARK: - Private
    
    private let hotelFormData = HotelsSearchVM.hotelFormData
    
    // MARK: - ViewLifeCycle
    
    // MARK: -
    
    override func initialSetup() {
        registerXIBs()
        
        setupNavView()
        
        statusBarStyle = .default
        configureHotelCheckOutDetailsVIew()
        animateFareDetails(isHidden: true, animated: false)
        
        continueContainerView.addGredient(isVertical: false)
        
        viewModel.fetchConfirmItineraryData()
        fillData()
        
//        manageLoader(shouldStart: true)
        
        manageLoader(shouldStart: false)
        AppGlobals.shared.startLoading()
        
        setUpUserEmailMobile()
        
        setupGuestArray()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let hotelCheckOutDetailsVIew = self.hotelCheckOutDetailsVIew {
            hotelCheckOutDetailsVIew.frame = CGRect(x: 0.0, y: AppFlowManager.default.safeAreaInsets.top, width: hotelCheckOutDetailsContainerVIew.width, height: hotelCheckOutDetailsContainerVIew.bounds.height - AppFlowManager.default.safeAreaInsets.top)
        }
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
        activityLoader.style = .whiteLarge
        activityLoader.color = AppColors.themeGreen
        activityLoader.startAnimating()
        
        loaderContainerView.backgroundColor = AppColors.themeWhite.withAlphaComponent(0.5)
        
        loaderContainerView.isHidden = !shouldStart
    }
    
    private func configureHotelCheckOutDetailsVIew() {
        hotelCheckOutDetailsVIew = HotelCheckOutDetailsVIew(frame: CGRect(x: 0.0, y: AppFlowManager.default.safeAreaInsets.top, width: hotelCheckOutDetailsContainerVIew.width, height: hotelCheckOutDetailsContainerVIew.bounds.height - AppFlowManager.default.safeAreaInsets.top))
        if let hotelCheckOutDetailsView = self.hotelCheckOutDetailsVIew {
            hotelCheckOutDetailsView.delegate = self
            hotelCheckOutDetailsContainerVIew.addSubview(hotelCheckOutDetailsView)
        }
    }
    
    private func updateHotelCheckOutDetailsVIew() {
        if let hotelCheckOutDetailsView = self.hotelCheckOutDetailsVIew {
            hotelCheckOutDetailsView.sectionData.removeAll()
            hotelCheckOutDetailsView.roomRates.removeAll()
            hotelCheckOutDetailsView.viewModel = self.viewModel.itineraryData?.hotelDetails ?? HotelDetails()
            hotelCheckOutDetailsView.hotelInfo = self.viewModel.hotelInfo ?? HotelSearched()
            hotelCheckOutDetailsView.placeModel = self.viewModel.placeModel ?? PlaceModel()
            hotelCheckOutDetailsView.sectionData = self.viewModel.sectionData
            hotelCheckOutDetailsView.roomRates = self.viewModel.roomRates
            hotelCheckOutDetailsView.updateData()
        }
    }
    
    private func fillData() {
        totalFareLabel.text = (viewModel.itineraryData?.total_fare ?? 0.0).amountInDelimeterWithSymbol
        setupFareBreakup()
        
        hotelNameLabel.text = viewModel.itineraryData?.hotelDetails?.hname ?? ""
        
        var finalDate = ""
        if let chIn = viewModel.itineraryData?.hotelDetails?.checkin, !chIn.isEmpty {
            finalDate = Date.getDateFromString(stringDate: chIn, currentFormat: "yyyy-MM-dd", requiredFormat: "dd MMM") ?? ""
        }
        
        if let chOut = viewModel.itineraryData?.hotelDetails?.checkout, !chOut.isEmpty {
            let txt = Date.getDateFromString(stringDate: chOut, currentFormat: "yyyy-MM-dd", requiredFormat: "dd MMM") ?? ""
            
            if finalDate.isEmpty {
                finalDate = txt
            }
            else {
                finalDate += " - \(txt)"
            }
        }
        checkInOutDate.text = finalDate
    }
    
    private func setupNavView() {
        topNavView.delegate = self
        topNavView.configureNavBar(title: LocalizedString.Guests.localized, isLeftButton: true, isFirstRightButton: true, isSecondRightButton: false, isDivider: true)
        
        topNavView.configureFirstRightButton(normalImage: #imageLiteral(resourceName: "plusButton2"), selectedImage: #imageLiteral(resourceName: "plusButton2"))
    }
    
    private func registerXIBs() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = AppColors.themeGray04
        
        tableView.registerCell(nibName: EmptyTableViewCell.reusableIdentifier)
        tableView.registerCell(nibName: HCEmailTextFieldCell.reusableIdentifier)
        tableView.registerCell(nibName: ContactTableCell.reusableIdentifier)
    }
    
    // MARK: - Methods
    
    // MARK: - Private
    
    private func setupFareBreakup() {
        if let room = viewModel.itineraryData?.hotelDetails?.num_rooms, let night = viewModel.itineraryData?.hotelDetails?.no_of_nights {
            let roomText = (room > 1) ? LocalizedString.Rooms.localized : LocalizedString.Room.localized
            let nightText = (night > 1) ? LocalizedString.Nights.localized : LocalizedString.Night.localized
            fareDetailLabel.text = "\(LocalizedString.For.localized) \(room) \(roomText) & \(night) \(nightText)"
        }
        
        totalFareAmountLabel.text = "$ \(Int(viewModel.itineraryData?.total_fare ?? 0.0))"
    }
    
    private func toggleFareDetailView() {
        animateFareDetails(isHidden: fareDetailBottomConstraint.constant >= 0, animated: true)
    }
    
    private func animateFareDetails(isHidden: Bool, animated: Bool) {
        let rotateTrans = isHidden ? CGAffineTransform.identity : CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        if !isHidden {
            fareDetailContainerView.isHidden = false
            if isHotelDetailsCheckOutViewOpen {
                hotelDetailsContainerViewHeightConstraint.constant = view.height - (hotelDetailsParentContainerView.height + fareDetailContainerView.height + AppFlowManager.default.safeAreaInsets.top)
            }
        }
        else {
            if isHotelDetailsCheckOutViewOpen {
                hotelDetailsContainerViewHeightConstraint.constant = view.height - (hotelDetailsParentContainerView.height + AppFlowManager.default.safeAreaInsets.top)
            }
        }
        UIView.animate(withDuration: animated ? AppConstants.kAnimationDuration : 0.0, animations: { [weak self] in
            guard let sSelf = self else { return }
            
            sSelf.fareDetailBottomConstraint.constant = isHidden ? -(sSelf.fareDetailContainerView.height) : 0.0
            sSelf.upArrowImageView.transform = rotateTrans
            
            sSelf.view.layoutIfNeeded()
            
        }, completion: { [weak self] _ in
            if isHidden {
                self?.fareDetailContainerView.isHidden = true
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
                    guest.passengerType = PassengersType.child
                    let childIdx = (j - hotelFormData.adultsCount[i])
                    guest.numberInRoom = childIdx + 1
                    guest.age = hotelFormData.childrenAge[i][childIdx]
                    guest.id = "\(childIdx)"
                }
                temp.append(guest)
            }
            GuestDetailsVM.shared.guests.append(temp)
        }
    }
    
    private func sendToFinalCheckoutVC() {
        if !isFromFinalCheckout {
//            AppFlowManager.default.moveToFinalCheckoutVC(delegate: self, viewModel.itineraryData, viewModel.itineraryPriceDetail, originLat: viewModel.hotelInfo?.lat ?? "", originLong: viewModel.hotelInfo?.long ?? "")
            if !isGrossValueZero {
                AppFlowManager.default.moveToFinalCheckoutVC(delegate: self, viewModel.itineraryData, viewModel.itineraryPriceDetail, originLat: viewModel.hotelInfo?.lat ?? "", originLong: viewModel.hotelInfo?.long ?? "")
            }
            else {
                AppToast.default.showToastMessage(message: "Please enter a valid phone number")
            }
        }
    }
    
    // MARK: - Public
    
    // MARK: - Action
    
    @IBAction func fareInfoButtonAction(_ sender: UIButton) {
        toggleFareDetailView()
    }
    
    @IBAction func continueButtonAction(_ sender: UIButton) {
        isFromFinalCheckout = false
        if viewModel.isValidateData(vc: self) {
            if UserInfo.loggedInUser != nil {
                self.viewModel.fetchRecheckRatesData()
            } else {
                self.viewModel.logInUserApi()
            }
        }
    }
    
    @IBAction func detailsButtonAction(_ sender: UIButton) {
        if viewModel.itineraryData != nil {
            hotelDetailsContainerView.isHidden = true
            hotelCheckOutDetailsContainerVIew.isHidden = false
            UIView.animate(withDuration: AppConstants.kAnimationDuration, animations: {
                if self.fareDetailContainerView.isHidden {
                    self.hotelDetailsContainerViewHeightConstraint.constant = self.view.height - (self.hotelDetailsParentContainerView.height + AppFlowManager.default.safeAreaInsets.top)
                }
                else {
                    self.hotelDetailsContainerViewHeightConstraint.constant = self.view.height - (self.hotelDetailsParentContainerView.height + self.fareDetailContainerView.height + AppFlowManager.default.safeAreaInsets.top)
                }
                self.view.layoutIfNeeded()
            }, completion: { [weak self] _ in
                self?.isHotelDetailsCheckOutViewOpen = true
            })
        }
    }
}

extension HCDataSelectionVC: HCDataSelectionVMDelegate {
    func updateFavouriteSuccess(withMessage: String) {
        if let hotelCheckOutDetailsVIew = self.hotelCheckOutDetailsVIew {
//            hotelCheckOutDetailsVIew.hotelDetailsTableView.reloadData()
            sendDataChangedNotification(data: self)
            let buttonImage: UIImage = viewModel.hotelInfo?.fav == "1" ? #imageLiteral(resourceName: "saveHotelsSelected") : #imageLiteral(resourceName: "saveHotels")
            hotelCheckOutDetailsVIew.headerView.leftButton.setImage(buttonImage, for: .normal)
        }
    }
    
    func updateFavouriteFail(errors: ErrorCodes) {
        AppNetworking.hideLoader()
        if let hotelCheckOutDetailsVIew = self.hotelCheckOutDetailsVIew {
            sendDataChangedNotification(data: self)
            let buttonImage: UIImage = viewModel.hotelInfo?.fav == "1" ? #imageLiteral(resourceName: "saveHotelsSelected") : #imageLiteral(resourceName: "saveHotels")
            hotelCheckOutDetailsVIew.headerView.leftButton.setImage(buttonImage, for: .normal)
            
            if let _ = UserInfo.loggedInUser {
                if errors.contains(array: [-1]) {
                    AppGlobals.shared.showErrorOnToastView(withErrors: errors, fromModule: .profile)
                }
                else {
                    AppGlobals.shared.showErrorOnToastView(withErrors: errors, fromModule: .hotelsSearch)
                }
            }
        }
    }
    
    // ItenaryDataTraveller
    
    func willCallForItenaryDataTraveller() {
        //
    }
    
    func callForItenaryDataTravellerSuccess() {
        self.isGrossValueZero = false
        if apiCount <= 5, viewModel.itineraryPriceDetail.grossAmount.toDouble ?? 0 <= 0 {
            viewModel.webserviceForItenaryDataTraveller()
            apiCount += 1
        }
    }
    
    func callForItenaryDataTravellerFail(errors: ErrorCodes) {
        self.isGrossValueZero = true
        AppGlobals.shared.showErrorOnToastView(withErrors: errors, fromModule: .hotelsSearch)
    }
    
    func willFetchConfirmItineraryData() {
        AppGlobals.shared.startLoading()
//        manageLoader(shouldStart: true)
    }
    
    func fetchConfirmItineraryDataSuccess() {
        if viewModel.itineraryData == nil, confirmationCall < 5 {
            confirmationCall += 1
            viewModel.fetchConfirmItineraryData()
        }
        else {
            GuestDetailsVM.shared.travellerList = viewModel.itineraryData?.traveller_master ?? []
//            manageLoader(shouldStart: false)
            AppGlobals.shared.stopLoading()
            fillData()
            self.viewModel.getHotelDetailsSectionData()
            self.updateHotelCheckOutDetailsVIew()
        }
    }
    
    func fetchConfirmItineraryDataFail() {
//        manageLoader(shouldStart: false)
        AppGlobals.shared.stopLoading()
        if viewModel.itineraryData == nil, confirmationCall < 5 {
            confirmationCall += 1
            viewModel.fetchConfirmItineraryData()
        }
    }
    
    func willFetchRecheckRatesData() {
//        manageLoader(shouldStart: true)
        AppGlobals.shared.startLoading()
    }
    
    func fetchRecheckRatesDataFail(errors: ErrorCodes) {
        if errors.contains(array: [11]) {
            //send to result screen and re-hit the search API
            self.sendDataChangedNotification(data: ATNotification.GRNSessionExpired)
            for vc in AppFlowManager.default.mainNavigationController.viewControllers {
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
        }
//        manageLoader(shouldStart: false)
        AppGlobals.shared.stopLoading()
    }
    
    func fetchRecheckRatesDataSuccess(recheckedData: ItineraryData) {
//        manageLoader(shouldStart: false)
        AppGlobals.shared.stopLoading()
        if viewModel.isValidateData(vc: self) {
            viewModel.webserviceForItenaryDataTraveller()
        }
        if let oldAmount = viewModel.itineraryData?.total_fare {
            let newAmount = recheckedData.total_fare
            
            viewModel.itineraryData = recheckedData
            
            let diff = newAmount - oldAmount
            if diff > 0 {
                // increased
                FareUpdatedPopUpVC.showPopUp(isForIncreased: true, decreasedAmount: 0.0, increasedAmount: diff, totalUpdatedAmount: newAmount, continueButtonAction: { [weak self] in
                    guard let sSelf = self else { return }
                    sSelf.sendToFinalCheckoutVC()
                    }, goBackButtonAction: { [weak self] in
                        guard let sSelf = self else { return }
                        sSelf.topNavBarLeftButtonAction(sSelf.topNavView.leftButton)
                })
            }
            else if diff < 0 {
                // dipped
                FareUpdatedPopUpVC.showPopUp(isForIncreased: false, decreasedAmount: -diff, increasedAmount: 0, totalUpdatedAmount: 0, continueButtonAction: nil, goBackButtonAction: nil)
                delay(seconds: 2.0) { [weak self] in
                    guard let sSelf = self else { return }
                    sSelf.sendToFinalCheckoutVC()
                }
            }
            else {
                sendToFinalCheckoutVC()
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
        GuestDetailsVM.shared.guests.removeAll()
        AppFlowManager.default.popViewController(animated: true)
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
        return hotelFormData.adultsCount.count + 8
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let newRow = indexPath.row - hotelFormData.adultsCount.count
        
        if newRow < 0 {
            // room data cell
            let totalCount = hotelFormData.adultsCount[indexPath.row] + hotelFormData.childrenCounts[indexPath.row]
            return (115.0 * ((totalCount <= 4) ? 1.0 : 2.0)) + 25.0
        }
        else {
            switch newRow {
            case 0, 2, 7:
                // space
                return 35.0
                
            case 1:
                // prefrences
                return 78.0
                
            case 3:
                // contact details text
                return 54.0
                
            case 4:
                // mobile number
                return 60.0
                
            case 5:
                // email
                return 60.0
                
            case 6:
                //text message
                return 60.0
                
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
            case 0, 2, 7:
                // space
                guard let cell = tableView.dequeueReusableCell(withIdentifier: EmptyTableViewCell.reusableIdentifier) as? EmptyTableViewCell else {
                    return UITableViewCell()
                }
                
                cell.contentView.backgroundColor = AppColors.themeGray04
                cell.backgroundColor = AppColors.themeGray04
                
                cell.bottomDividerView.isHidden = newRow == 7
                
                return cell
                
            case 1:
                // prefrences
                guard let cell = tableView.dequeueReusableCell(withIdentifier: HCDataSelectionPrefrencesCell.reusableIdentifier) as? HCDataSelectionPrefrencesCell else {
                    return UITableViewCell()
                }
                
                return cell
                
            case 3:
                // contact details text
                guard let cell = tableView.dequeueReusableCell(withIdentifier: HCDataSelectionTextLabelCell.reusableIdentifier) as? HCDataSelectionTextLabelCell else {
                    return UITableViewCell()
                }
                
                cell.titleLabel.font = AppFonts.SemiBold.withSize(18.0)
                cell.titleLabel.textColor = AppColors.themeBlack
                cell.titleLabel.text = "Contact Details"
                cell.topConstraint.constant = 16.0
                
                return cell
                
            case 4:
                // mobile number
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ContactTableCell.reusableIdentifier) as? ContactTableCell else {
                    return UITableViewCell()
                }
                cell.delegate = self
                return cell
                
            case 5:
                // email
           guard let cell = tableView.dequeueReusableCell(withIdentifier: HCEmailTextFieldCell.reusableIdentifier) as? HCEmailTextFieldCell else {
                    return UITableViewCell()
                }
                
//                cell.downArrowImageView.isHidden = true
//                cell.titleLabel.font = AppFonts.Regular.withSize(18.0)
//                cell.titleLabel.textColor = AppColors.themeGray20
//                cell.titleLabel.text = LocalizedString.Email_ID.localized
                cell.editableTextField.isEnabled = UserInfo.loggedInUserId == nil
                cell.delegate = self
                cell.editableTextField.text = UserInfo.loggedInUser?.email
                cell.editableTextField.font = AppFonts.Regular.withSize(18.0)
                cell.editableTextField.textColor = UserInfo.loggedInUserId == nil ? AppColors.themeBlack : AppColors.themeGray40
                cell.editableTextField.keyboardType = .emailAddress
                cell.editableTextField.placeholder = LocalizedString.Email_ID.localized
           
                
                return cell
                
            case 6:
                //text message
                guard let cell = tableView.dequeueReusableCell(withIdentifier: HCDataSelectionTextLabelCell.reusableIdentifier) as? HCDataSelectionTextLabelCell else {
                    return UITableViewCell()
                }
                
                cell.topConstraint.constant = 6.0
                cell.configUI()
                
                return cell
                
            default:
                return UITableViewCell()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Redirect to Selection Preference VC
        if let _ = tableView.cellForRow(at: indexPath) as? HCDataSelectionPrefrencesCell, let specialRequests = self.viewModel.itineraryData?.special_requests {
            AppFlowManager.default.presentHCSpecialRequestsVC(specialRequests: specialRequests,selectedRequestIds: self.viewModel.selectedSpecialRequest,delegate: self)
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
    func didPassSelectedRequestsId(ids: [Int], preferences: String, request: String) {
        printDebug("\(ids),\t\(preferences),\t\(request)")
        self.viewModel.selectedSpecialRequest = ids
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
    func setIsdCode(_ country: PKCountryModel) {
        viewModel.mobileIsd = country.countryCode
    }
    
    func textFieldText(_ textField: UITextField) {
        viewModel.mobileNumber = textField.text ?? ""
    }
}
