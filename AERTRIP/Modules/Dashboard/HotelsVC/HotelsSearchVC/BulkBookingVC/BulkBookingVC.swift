//
//  BulkBookingVC.swift
//  AERTRIP
//
//  Created by Admin on 24/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit
import IQKeyboardManager

protocol BulkBookingVCDelegate: class {
    func didSelectedDestination(checkinDate: Date?, checkOutDate: Date?, location: SearchedDestination?)
}

class BulkBookingVC: BaseVC {
    
    //Mark:- Properties
    //=================
    internal var checkInOutView: CheckInOutView?
    var returnUserId: String? {
        return UserInfo.loggedInUserId
    }
    
    
    //MARK:- IBOutlets
    //MARK:-
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var rectangleView: UIView!
    @IBOutlet weak var topNavView: TopNavigationView!
    @IBOutlet weak var mainCintainerBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var childContainerView: UIView!
    @IBOutlet weak var whereContainerView: UIView!
    @IBOutlet weak var datePickerView: UIView!
    @IBOutlet weak var bulkBookingView: UIView!
    @IBOutlet weak var dateInfoView : UIView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var whereBtnOutlet: UIButton!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var stateNameLabel: UILabel!
    @IBOutlet weak var firstLineView: ATDividerView!
    @IBOutlet weak var secondLineView: ATDividerView!
    @IBOutlet weak var thirdLineView: ATDividerView!
    @IBOutlet weak var fourthLineView: ATDividerView!
    @IBOutlet weak var searchButtonOutlet: ATButton!
    @IBOutlet weak var bulkBookingLabel: UILabel!
    @IBOutlet weak var roomCountLabel: UILabel!
    @IBOutlet weak var adultCountLabel: UILabel!
    @IBOutlet weak var childCountLabel: UILabel!
    @IBOutlet weak var preferredHotelsLabel: UILabel!
    @IBOutlet weak var specialReqLabel: UILabel!
    @IBOutlet weak var bulkBookingPopUpBtn: UIButton!
    
    @IBOutlet weak var specialReqTextView: PKTextField!{
        didSet {
            specialReqTextView.pkDelegate = self
        }
    }
    
    @IBOutlet weak var dateFlexibleLabel: UILabel!
    
    @IBOutlet weak var whereLabel: UILabel!
    @IBOutlet weak var bottomViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var prefredTextContainer: UIView!
    @IBOutlet weak var specialTextContainer: UIView!
    
    
    //MARK:- Properties
    //MARK:- Public
    let viewModel = BulkBookingVM()
    var initialTouchPoint: CGPoint = CGPoint(x: 0.0, y: 0.0)
    weak var delegate: BulkBookingVCDelegate?
    var viewTranslation = CGPoint(x: 0, y: 0)
    
    //MARK:- Private
    
    //MARK:- ViewLifeCycle
    //MARK:-
    
    deinit {
        FirebaseEventLogs.shared.logHotelBulkBookingEvent(name: .CloseBulkBooking)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.initialSetups()
    }
    
    override func bindViewModel() {
        self.viewModel.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        IQKeyboardManager.shared().isEnableAutoToolbar = false
        
        self.searchButtonOutlet.isLoading = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        IQKeyboardManager.shared().isEnableAutoToolbar = true
    }
    
    override func viewDidLayoutSubviews() {
        if let view = self.checkInOutView {
            view.frame = self.datePickerView.bounds
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        self.view.endEditing(true)
    }
    
    override func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            let expectedScreenH = self.specialReqTextView.convert(self.specialReqTextView.frame, to: self.view).origin.y + keyboardSize.height
            let difH = expectedScreenH - UIDevice.screenHeight
            if difH > 0 {
                self.view.frame = CGRect(x: 0.0, y: -difH, width: self.view.width, height: self.view.height)
            }
        }
    }
    
    override func keyboardWillHide(notification: Notification) {
        self.view.frame = CGRect(x: 0.0, y: 0.0, width: self.view.width, height: self.view.height)
    }
    
    override func setupFonts() {
        self.bulkBookingLabel.font = AppFonts.Regular.withSize(16.0)
        self.preferredHotelsLabel.font = AppFonts.Regular.withSize(16.0)
        self.specialReqLabel.font = AppFonts.Regular.withSize(16.0)
        self.roomCountLabel.font = AppFonts.SemiBold.withSize(18.0)
        self.adultCountLabel.font = AppFonts.SemiBold.withSize(18.0)
        self.childCountLabel.font = AppFonts.SemiBold.withSize(18.0)
        self.specialReqTextView.font = AppFonts.Regular.withSize(16.0)
        self.dateFlexibleLabel.font = AppFonts.Regular.withSize(17.0)
        self.cityNameLabel.font = AppFonts.SemiBold.withSize(26.0)
        self.stateNameLabel.font = AppFonts.Regular.withSize(16.0)
    }
    
    override func setupTexts() {
        self.whereLabel.text = LocalizedString.WhereButton.localized
        
        if let _ = self.returnUserId {
            self.searchButtonOutlet.setTitle(LocalizedString.Submit.localized, for: .normal)
        } else {
            self.searchButtonOutlet.setTitle(LocalizedString.LoginAndSubmit.localized, for: .normal)
        }
        self.bulkBookingLabel.text = LocalizedString.Guests.localized
        self.preferredHotelsLabel.text = LocalizedString.MyDatesAre.localized
        self.specialReqLabel.text = LocalizedString.SpecialRequest.localized
        self.dateFlexibleLabel.text = LocalizedString.Fixed.localized
        self.viewModel.preferred = self.dateFlexibleLabel.text ?? ""
    }
    
    override func setupColors() {
        
        self.whereLabel.textColor = AppColors.themeGray40
        self.cityNameLabel.textColor = AppColors.textFieldTextColor51
        self.stateNameLabel.textColor = AppColors.textFieldTextColor51
        self.bulkBookingLabel.textColor = AppColors.themeGray40
        self.preferredHotelsLabel.textColor = AppColors.themeGray40
        self.specialReqLabel.textColor = AppColors.themeGray40
        self.specialReqTextView.textColor = AppColors.textFieldTextColor51
        let regularFontSize16 = AppFonts.Regular.withSize(16.0)
        
        
        self.searchButtonOutlet.shadowColor = AppColors.themeBlack.withAlphaComponent(0.16)
        self.searchButtonOutlet.layer.applySketchShadow(color: AppColors.themeBlack, alpha: 0.16, x: 0, y: 2, blur: 6, spread: 0)
        
        self.specialReqTextView.attributedPlaceholder = NSMutableAttributedString(string: LocalizedString.IfAny.localized, attributes: [NSAttributedString.Key.foregroundColor: AppColors.themeGray20,NSAttributedString.Key.font: regularFontSize16])
        self.specialReqTextView.textAlignment = .center
        self.specialReqTextView.returnKeyType = .done
    }
    
    //MARK:- Methods
    //MARK:- Private
    ///InitialSetUp
    private func initialSetups() {
        
        //AddGesture:-
        let swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        mainContainerView.isUserInteractionEnabled = true
        swipeGesture.delegate = self
        if #available(iOS 13.0, *) {} else {
            self.mainContainerView.addGestureRecognizer(swipeGesture)
        }
        
        self.view.alpha = 1.0
        self.view.backgroundColor = .clear//AppColors.themeBlack.withAlphaComponent(0.001)
        self.bottomViewHeightConstraint.constant = AppFlowManager.default.safeAreaInsets.bottom
        self.mainContainerView.roundTopCorners(cornerRadius: 10.0)
        
        self.topNavView.delegate = self
        self.topNavView.configureNavBar(title: LocalizedString.BulkBooking.localized, isLeftButton: false, isFirstRightButton: true, isSecondRightButton: false, isDivider: true)
        self.topNavView.configureFirstRightButton(normalTitle: LocalizedString.Cancel.localized, selectedTitle: LocalizedString.Cancel.localized, normalColor: AppColors.themeGreen, selectedColor: AppColors.themeGreen, font: AppFonts.Regular.withSize(18.0))
        self.searchButtonOutlet.setTitleFont(font: AppFonts.SemiBold.withSize(17.0), for: .normal)
        self.searchButtonOutlet.setTitleFont(font: AppFonts.SemiBold.withSize(17.0), for: .selected)
        self.searchButtonOutlet.setTitleFont(font: AppFonts.SemiBold.withSize(17.0), for: .highlighted)
        
        self.searchButtonOutlet.layer.cornerRadius = 25.0
        //self.rectangleView.roundCorners(corners: [.topLeft, .topRight], radius: 15.0)
        if #available(iOS 13.0, *) {
            self.rectangleView.cornerradius = 10.0
        } else {
            self.rectangleView.cornerradius = 15.0
            self.hide(animated: false)
            delay(seconds: 0.1) { [weak self] in
                self?.show(animated: true)
            }
        }
        self.rectangleView.layer.masksToBounds = true
        self.configureCheckInOutView()
        
        self.setWhere(cityName: "", stateName: "")
        
        
        self.setSearchFormData()
        
        let prefTapGest = UITapGestureRecognizer(target: self, action: #selector(preferredButtonAction))
        self.prefredTextContainer.addGestureRecognizer(prefTapGest)
        
        let specTapGest = UITapGestureRecognizer(target: self, action: #selector(specialReqAction))
        self.specialTextContainer.addGestureRecognizer(specTapGest)
        
        self.navigationController?.presentationController?.delegate = self
    }
    
    private func setSearchFormData() {
        let oldData = self.viewModel.oldData
        
        self.viewModel.destination = oldData.destName
        self.viewModel.source = oldData.destName
        self.viewModel.checkInDate = oldData.checkInDate
        self.viewModel.checkOutDate = oldData.checkOutDate
        self.viewModel.roomCounts = 5
        self.viewModel.adultsCount = 10
        self.viewModel.childrenCounts = 0
        
        if oldData.destType.lowercased() == "hotel" {
            self.setWhere(cityName: oldData.destName, stateName: oldData.stateName)
        } else {
            self.setWhere(cityName: oldData.cityName, stateName: oldData.stateName)
        }
        
        self.checkInOutView?.setDates(fromData: oldData)
        
        self.updateRoomData(rooms: self.viewModel.roomCounts, adults: self.viewModel.adultsCount, children: self.viewModel.childrenCounts)
        
        for star in oldData.ratingCount {
            self.updateStarButtonState(forStar: star)
        }
        
    }
    
    private func setWhere(cityName: String, stateName: String) {
        self.whereLabel.font = cityName.isEmpty ? AppFonts.Regular.withSize(20.0) : AppFonts.Regular.withSize(16.0)
        self.cityNameLabel.text = cityName
        self.stateNameLabel.text = stateName
        self.cityNameLabel.isHidden = cityName.isEmpty
        self.stateNameLabel.isHidden = stateName.isEmpty
    }
    
    ///ConfigureCheckInOutView
    private func configureCheckInOutView() {
        self.checkInOutView = CheckInOutView(frame: self.datePickerView.bounds)
        if let view = self.checkInOutView {
            view.delegate = self
            self.datePickerView.addSubview(view)
        }
    }
    
    ///Show View
    private func show(animated: Bool) {
        self.bottomView.isHidden = false
        
        func setValue() {
            self.mainCintainerBottomConstraint.constant = 0.0
            if #available(iOS 13.0, *) {} else {
            self.view.backgroundColor = AppColors.themeBlack.withAlphaComponent(0.3)
            }
            self.view.layoutIfNeeded()
        }
        
        if animated {
            let animater = UIViewPropertyAnimator(duration: AppConstants.kAnimationDuration, curve: .linear) {
                setValue()
            }
            animater.startAnimation()
        }
        else {
            setValue()
        }
    }
    
    ///Hide View
    private func hide(animated: Bool, shouldRemove: Bool = false) {
        self.bottomView.isHidden = true
        applyBulkBookingChanges()
        func setValue() {
            self.mainCintainerBottomConstraint.constant = -(self.mainContainerView.frame.height + 100)
            self.view.backgroundColor = AppColors.themeBlack.withAlphaComponent(0.001)
            self.view.layoutIfNeeded()
        }
        
        if animated {
            let animater = UIViewPropertyAnimator(duration: AppConstants.kAnimationDuration, curve: .linear) {
                setValue()
            }
            
            animater.addCompletion { (position) in
                if shouldRemove {
                    self.removeFromParentVC
                }
            }
            
            //animater.startAnimation()
            self.dismiss(animated: true, completion: nil)
        }
        else {
            setValue()
        }
    }
    
    ///Star Button State
    private func updateStarButtonState(forStar: Int, isSettingFirstTime: Bool = false) {
        guard 1...5 ~= forStar else {return}
        
        //updating the selection array
        if let idx = self.viewModel.ratingCount.firstIndex(of: forStar) {
            self.viewModel.ratingCount.remove(at: idx)
        }
        else {
            self.viewModel.ratingCount.append(forStar)
        }
        
        if self.viewModel.ratingCount.isEmpty || self.viewModel.ratingCount.count == 5 {
            self.viewModel.ratingCount.removeAll()
        }
        else {
            
        }
    }
    
    ///Get Star Rating
    private func getStarString(fromArr: [Int], maxCount: Int) -> String {
        var arr = Array(Set(fromArr))
        arr.sort()
        var final = ""
        var start: Int?
        var end: Int?
        var prev: Int?
        
        if arr.isEmpty || arr.count == maxCount {
            final = "All \(LocalizedString.stars.localized)"//"0 \(LocalizedString.stars.localized)"
            return final
        }
            //        else if arr.count == maxCount {
            //            final = "All \(LocalizedString.stars.localized)"
            //            return final
            //        }
        else if arr.count == 1 {
            final = "\(arr[0]) \((arr[0] == 1) ? "\(LocalizedString.star.localized)" : "\(LocalizedString.stars.localized)")"
            return final
        }
        
        for (idx,value) in arr.enumerated() {
            let diff = value - (prev ?? 0)
            if diff == 1 {
                //number is successor
                if start == nil {
                    start = prev
                }
                end = value
            }
            else if diff > 1 {
                //number is not successor
                if start == nil {
                    
                    if let p = prev {
                        final += "\(p), "
                    }
                    
                    if idx == (arr.count - 1) {
                        final += "\(value), "
                    }
                }
                else {
                    if let s = start, let e = end {
                        final += (s != e) ? "\(s) - \(e), " : "\(s), "
                        start = nil
                        end = nil
                        prev = nil
                        if idx == (arr.count - 1) {
                            final += "\(value), "
                        }
                    }
                    else {
                        if idx == (arr.count - 1) {
                            final += "\(value), "
                        }
                    }
                }
            }
            prev = value
        }
        
        if let s = start, let e = end {
            final += (s != e) ? "\(s) - \(e), " : "\(s), "
            start = nil
            end = nil
        }
        final.removeLast(2)
        return final + " \(LocalizedString.stars.localized)"
    }
    
    ///Data For Api
    private func dataForApi(hotel: SearchedDestination) {
        self.viewModel.destination = hotel.city
        self.viewModel.source = hotel.dest_name
        self.viewModel.searchedLocation = hotel
    }
    
    ///Update Room Data
    private func updateRoomData(rooms: Int, adults: Int, children: Int) {
        self.roomCountLabel.text = rooms > 100 ? "100+" : "\(rooms)"
        self.adultCountLabel.text = adults > 200 ? "200+" : "\(adults)"
        self.childCountLabel.text = children > 200 ? "200+" : "\(children)"
    }
    private func applyBulkBookingChanges() {
        self.delegate?.didSelectedDestination(checkinDate: self.viewModel.checkIn, checkOutDate: self.viewModel.checkOut, location: self.viewModel.searchedLocation)
    }
    //MARK:- Public
    
    
    //MARK:- Action
    @IBAction func starButtonsAction(_ sender: UIButton) {
        self.updateStarButtonState(forStar: sender.tag)
    }
    
    @IBAction func bulkBookingPopUpAction(_ sender: Any) {
        //        dismissKeyboard()
        self.view.endEditing(true)
        AppFlowManager.default.showBulkRoomSelectionVC(rooms: self.viewModel.roomCounts, adults:  self.viewModel.adultsCount, children:  self.viewModel.childrenCounts, delegate: self, navigationController: self.navigationController)
    }
    
    @IBAction func whereButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        AppFlowManager.default.showSelectDestinationVC(delegate: self,currentlyUsingFor: .bulkBooking, navigationController: self.navigationController)
        FirebaseEventLogs.shared.logHotelBulkBookingEvent(name: .ClickWhere)
    }
    
    @IBAction func searchButtonAction(_ sender: ATButton) {
        
        if let _ = self.returnUserId  {
            if self.viewModel.isValidateData() {
                sender.isLoading = true
                self.viewModel.bulkBookingEnquiryApi()
                FirebaseEventLogs.shared.logHotelBulkBookingEvent(name: .SendBulkBookingQuery)
            }
        }
        else {
            self.statusBarStyle = .default
//            delay(seconds: 0.1) {
//                sender.isLoading = true
//            }
            delay(seconds: 0.1) {
                AppFlowManager.default.proccessIfUserLoggedIn(verifyingFor: .loginVerificationForBulkbooking,presentViewController: true) { [weak self] (isGuest) in
                    guard let sSelf = self else {return}
                    sender.isLoading = true
                    //                    if let vc = sSelf.navigationController {
                    sSelf.statusBarStyle = .lightContent
                    AppFlowManager.default.popToRootViewController(animated: true)
                    //                    }
                    sSelf.searchButtonOutlet.setTitle(LocalizedString.Submit.localized, for: .normal)
                    delay(seconds: 0.05) {
                        self?.searchButtonAction(sSelf.searchButtonOutlet)
                    }
                }
            }
        }
    }
    
    @objc func preferredButtonAction() {
        self.dateFlexibleLabel.text = self.dateFlexibleLabel.text == LocalizedString.Fixed.localized ? LocalizedString.Flexible.localized : LocalizedString.Fixed.localized
        self.viewModel.preferred = self.dateFlexibleLabel.text ?? ""
    }
    
    @objc func specialReqAction() {
        self.view.endEditing(true)
        _ = self.specialReqTextView.becomeFirstResponder()
    }
}

//MARK:- TextView delegate
extension BulkBookingVC: PKTextFieldDelegate {
    
    func pkTextFieldDidBeginEditing(_ pkTextField: PKTextField) {
        printDebug(pkTextField)
        if pkTextField === specialReqTextView {
            
        } else {
            self.statusBarStyle = .default
        }
    }
    
    func pkTextFieldShouldReturn(_ pkTextField: PKTextField) -> Bool {
        pkTextField.endEditing(true)
        self.statusBarStyle = .lightContent
        return true
    }
    
    func pkTextFieldDidEndEditing(_ pkTextField: PKTextField) {
        var finalText: String = (pkTextField.text ?? "").removeSpaceAsSentence
        finalText.insert(" ", at: finalText.startIndex)
        finalText.insert(" ", at: finalText.startIndex)
        pkTextField.text = finalText
        self.viewModel.specialRequest = finalText
        
        
    }
    
    func pkTextField(_ pkTextField: PKTextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if pkTextField.text?.count == AppConstants.kMaxTextLimit {
            return false
        }
        return true
    }
}

//MARK:- TopNavigationViewDelegate
//==================================
extension BulkBookingVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
    }
    
    func topNavBarFirstRightButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.hide(animated: true, shouldRemove: true)
    }
}

//MARK:- SelectDestinationVCDelegate
//==================================
extension BulkBookingVC: SelectDestinationVCDelegate {
    func didSelectedDestination(hotel: SearchedDestination) {
        printDebug("selected: \(hotel)")
        var city = ""
        if hotel.dest_type.lowercased() == "hotel" {
            self.cityNameLabel.text = hotel.dest_name
            city = hotel.dest_name
        }else if !hotel.city.isEmpty {
            city = hotel.city
        } else {
            let newValue = hotel.value.components(separatedBy: ",")
            printDebug(newValue.first)
            city = newValue.first ?? ""
        }
        
        var splittedStringArray = hotel.value.components(separatedBy: ",")
        splittedStringArray.removeFirst()
        let stateName = splittedStringArray.joined(separator: ",")
        
        self.setWhere(cityName: city, stateName: stateName)
        
        self.dataForApi(hotel: hotel)
        
        if hotel.isHotelNearMeSelected {
            FirebaseEventLogs.shared.logHotelBulkBookingEvent(name: .SearchNearby)
        }
        
        switch hotel.dest_type.lowercased() {
        case "poi": FirebaseEventLogs.shared.logHotelBulkBookingEvent(name: .SearchPOI)
        case "area": FirebaseEventLogs.shared.logHotelBulkBookingEvent(name: .SearchByArea)
        case "city": FirebaseEventLogs.shared.logHotelBulkBookingEvent(name: .SearchByCity)
        case "hotel": FirebaseEventLogs.shared.logHotelBulkBookingEvent(name: .SearchByHotel)
        default: break
        }
    }
}

//MARK:- BulkRoomSelectionVCDelegate
//==================================
extension BulkBookingVC: BulkRoomSelectionVCDelegate {
    func didSelectRooms(rooms: Int, adults: Int, children: Int) {
        printDebug("\(rooms),\(adults),\(children)")
        self.viewModel.roomCounts = rooms
        self.viewModel.adultsCount = adults
        self.viewModel.childrenCounts = children
        self.updateRoomData(rooms: rooms, adults: adults, children: children)
        FirebaseEventLogs.shared.logHotelBulkBookingEvent(name: .CountTotalRooms, value: "\(rooms)")
        FirebaseEventLogs.shared.logHotelBulkBookingEvent(name: .CountTotalAdults, value: "\(adults)")
        FirebaseEventLogs.shared.logHotelBulkBookingEvent(name: .CountTotalChildren, value: "\(children)")
        
    }
}

//MARK:- BulkBookingVMDelegate
//============================
extension BulkBookingVC: BulkBookingVMDelegate {
    func bulkBookingEnquirySuccess(enquiryId: String) {
        printDebug(enquiryId)
        self.applyBulkBookingChanges()
        self.searchButtonOutlet.isLoading = false
        //self.hide(animated: true, shouldRemove: true)
        
        var config = BulkEnquirySuccessfulVC.ButtonConfiguration()
        config.text = LocalizedString.Submit.localized
        config.cornerRadius = 25.0
        if let font = self.searchButtonOutlet.titleLabel?.font {
            config.textFont = font
        }
        let point = searchButtonOutlet.convert(searchButtonOutlet.frame.origin, to: self.mainContainerView)
        let y = self.view.height - (point.y)
        config.width = self.searchButtonOutlet.width
        config.spaceFromBottom = y
        AppFlowManager.default.showBulkEnquiryVC(buttonConfig: config, delegate: self)
    }
    
    func bulkBookingEnquiryFail(errors:ErrorCodes) {
        self.searchButtonOutlet.isLoading = false
        AppGlobals.shared.showErrorOnToastView(withErrors: errors, fromModule: .hotelsSearch)
    }
}

//MARK:- CheckInOutViewDelegate
//MARK:-
extension BulkBookingVC: CheckInOutViewDelegate {
    
    func selectCheckInDate(_ sender: UIButton) {
        AppFlowManager.default.moveHotelCalenderVC(isHotelCalendar: true,checkInDate: self.viewModel.oldData.checkInDate.toDate(dateFormat: "yyyy-MM-dd"), checkOutDate: self.viewModel.oldData.checkOutDate.toDate(dateFormat: "yyyy-MM-dd"), delegate: self, isStartDateSelection: true, navigationController: self.navigationController, isFromHotelBulkBooking:true)
        FirebaseEventLogs.shared.logHotelBulkBookingEvent(name: .OpenCheckIn)
    }
    
    func selectCheckOutDate(_ sender: UIButton) {
        
        AppFlowManager.default.moveHotelCalenderVC(isHotelCalendar: true,checkInDate: self.viewModel.oldData.checkInDate.toDate(dateFormat: "yyyy-MM-dd"), checkOutDate: self.viewModel.oldData.checkOutDate.toDate(dateFormat: "yyyy-MM-dd"), delegate: self, isStartDateSelection: false, navigationController: self.navigationController, isFromHotelBulkBooking:true)
        FirebaseEventLogs.shared.logHotelBulkBookingEvent(name: .OpenCheckOut)
    }
}

//MARK:- CalendarDataHandler
//MARK:-
extension BulkBookingVC: CalendarDataHandler {
    func selectedDates(fromCalendar startDate: Date!, end endDate: Date!, isHotelCalendar: Bool, isReturn: Bool) {
        if startDate != nil {
            self.viewModel.oldData.checkInDate = startDate.toString(dateFormat: "yyyy-MM-dd")
        } else {
            self.viewModel.oldData.checkInDate = ""
        }
        if endDate != nil {
            self.viewModel.oldData.checkOutDate = endDate.toString(dateFormat: "yyyy-MM-dd")
        } else {
            self.viewModel.oldData.checkOutDate = ""
        }
        self.viewModel.checkInDate = self.viewModel.oldData.checkInDate
        self.viewModel.checkOutDate = self.viewModel.oldData.checkOutDate

        if let checkInOutVw = self.checkInOutView {
            checkInOutVw.setDates(fromData: self.viewModel.oldData)
        }
        self.viewModel.checkIn = startDate
        self.viewModel.checkOut = endDate
        printDebug(startDate)
        printDebug(endDate)
        printDebug(isHotelCalendar)
        printDebug(isReturn)
    }
    
    func tryToSelectMoreThan30Night() {
        FirebaseEventLogs.shared.logHotelBulkBookingEvent(name: .TryForMoreThan30Nights)
    }
}

extension BulkBookingVC {
    //Handle Swipe Gesture
    @objc func handleSwipes(_ sender: UIPanGestureRecognizer) {
        func reset() {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.view.transform = .identity
            })
        }
        
        func moveView() {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.view.transform = CGAffineTransform(translationX: 0, y: self.viewTranslation.y)
            })
        }
        
        guard let direction = sender.direction, direction.isVertical, direction == .down else {
            reset()
            return
        }
        
        switch sender.state {
        case .changed:
            viewTranslation = sender.translation(in: self.view)
            moveView()
        case .ended:
            if viewTranslation.y < 200 {
                reset()
            } else {
                dismiss(animated: true, completion: nil)
            }
        case .cancelled:
            reset()
        default:
            break
        }
    }
    
    
    ///Call to use Pan Gesture Final Animation
    private func panGestureFinalAnimation(velocity: CGPoint,touchPoint: CGPoint) {
        //Down Direction
        if velocity.y < 0 {
            if velocity.y < -300 {
                self.openBottomSheet()
            } else {
                if touchPoint.y <= (UIScreen.main.bounds.height)/2 {
                    self.openBottomSheet()
                } else {
                    self.closeBottomSheet()
                }
            }
        }
            //Up Direction
        else {
            if velocity.y > 300 {
                self.closeBottomSheet()
            } else {
                if touchPoint.y <= (UIScreen.main.bounds.height)/2 {
                    self.openBottomSheet()
                } else {
                    self.closeBottomSheet()
                }
            }
        }
        printDebug(velocity.y)
    }
    
    func openBottomSheet() {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.4) {
            self.mainCintainerBottomConstraint.constant = 0.0
            self.view.layoutIfNeeded()
        }
    }
    
    func closeBottomSheet() {
        func setValue() {
            self.mainCintainerBottomConstraint.constant = -(self.mainContainerView.height)
            self.view.backgroundColor = AppColors.themeBlack.withAlphaComponent(0.001)
            self.view.layoutIfNeeded()
        }
        let animater = UIViewPropertyAnimator(duration: AppConstants.kAnimationDuration, curve: .linear) {
            setValue()
        }
        animater.addCompletion { (position) in
            self.removeFromParentVC
        }
        //animater.startAnimation()
        self.dismiss(animated: true, completion: nil)
    }
}
extension BulkBookingVC: BulkEnquirySuccessfulVCDelegate {
    func doneButtonAction() {
        self.hide(animated: true, shouldRemove: true)
    }
}
extension BulkBookingVC: UIAdaptivePresentationControllerDelegate {
    
    func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
        self.applyBulkBookingChanges()
    }
}

